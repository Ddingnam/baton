function getThemeDefaultColor() {
    const theme = document.documentElement.getAttribute('data-theme') || 'purple';
    if (theme === 'blue')    return 'blue';
    if (theme === 'emerald') return 'green';
    if (theme === 'sunset')  return 'orange';
    if (theme === 'rose')    return 'pink';
    if (theme === 'slate')   return 'slate';
    return 'purple';
}

(function () {
'use strict';

const BASE      = window.CTX || '';
const DAYS_KO   = ['일','월','화','수','목','금','토'];
const MONTHS_KO = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
const ROW_H     = 60;

const COLORS = [
    { id:'purple', hex:'#7C3AED' },
    { id:'pink',   hex:'#DB2777' },
    { id:'blue',   hex:'#2563EB' },
    { id:'teal',   hex:'#0891B2' },
    { id:'green',  hex:'#059669' },
    { id:'orange', hex:'#D97706' },
    { id:'red',    hex:'#DC2626' },
    { id:'slate',  hex:'#475569' },
];

const THEMES = [
    { id:'purple',  hex:'#7C3AED' },
    { id:'blue',    hex:'#1D4ED8' },
    { id:'emerald', hex:'#059669' },
    { id:'sunset',  hex:'#EA580C' },
    { id:'rose',    hex:'#E11D48' },
    { id:'slate',   hex:'#334155' },
];

const state = {
    view:          'week',
    year:          new Date().getFullYear(),
    month:         new Date().getMonth(),
    weekStart:     getWeekStart(new Date()),
    dayDate:       new Date(),
    events:        [],
    editingId:     null,
    selectedColor: getThemeDefaultColor(),
    popoverId:     null,
};

let nowTimer      = null;
let draggedEv     = null;
let dragStartY    = 0;
let resizingEv    = null;
let resizeStartY  = 0;
let resizeOrigEnd = 0;
let resizeBlock   = null;

function pad(n)      { return String(n).padStart(2,'0'); }
function dateKey(d)  { return d.getFullYear()+'-'+pad(d.getMonth()+1)+'-'+pad(d.getDate()); }
function todayKey()  { return dateKey(new Date()); }

function getWeekStart(d) {
    const dt = new Date(d);
    dt.setDate(dt.getDate() - dt.getDay());
    dt.setHours(0,0,0,0);
    return dt;
}
function addDays(d, n) {
    const dt = new Date(d);
    dt.setDate(dt.getDate() + n);
    return dt;
}
function isSameDay(a, b) {
    return a.getFullYear()===b.getFullYear() && a.getMonth()===b.getMonth() && a.getDate()===b.getDate();
}
function timeToMin(t) {
    if (!t) return 0;
    const [h,m] = t.split(':').map(Number);
    return h*60+m;
}
function minToTime(m) { return pad(Math.floor(m/60))+':'+pad(m%60); }
function colorHex(id) { return (COLORS.find(c=>c.id===id)||COLORS[0]).hex; }
function esc(s) {
    return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
function uid() { return '_'+Math.random().toString(36).slice(2,10); }

function clearDragOver() {
    document.querySelectorAll('.drag-over').forEach(el => el.classList.remove('drag-over'));
}

function makeDragGhost(ev) {
    const el = document.createElement('div');
    el.className = 'cp-drag-ghost';
    el.style.background = colorHex(ev.color);
    el.textContent = ev.title || '(제목 없음)';
    document.body.appendChild(el);
    return el;
}

function apiGet(url) {
    return fetch(url, { credentials:'same-origin' })
        .then(r => { if (!r.ok) throw new Error('HTTP '+r.status); return r.json(); });
}
function apiPost(url, body) {
    return fetch(url, {
        method:'POST', credentials:'same-origin',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify(body)
    }).then(r => { if (!r.ok) throw new Error('HTTP '+r.status); return r.json(); });
}

function loadEvents() {
    const from = getLoadFrom();
    const to   = getLoadTo();
    apiGet(BASE+'/admin/calendar/events?from='+from+'&to='+to)
        .then(list => {
            const memoOnly = state.events.filter(e => e._memo);
            if (!Array.isArray(list)) {
                state.events = memoOnly;
                renderAll();
                return;
            }
            state.events = memoOnly.concat(list);
            renderAll();
        })
        .catch(() => renderAll());
}

function getLoadFrom() {
    if (state.view==='month') return new Date(state.year, state.month, 1).toISOString().slice(0,10);
    if (state.view==='week')  return dateKey(state.weekStart);
    return dateKey(state.dayDate);
}
function getLoadTo() {
    if (state.view==='month') return new Date(state.year, state.month+1, 0).toISOString().slice(0,10);
    if (state.view==='week')  return dateKey(addDays(state.weekStart,6));
    return dateKey(state.dayDate);
}

function saveEvent(ev)   { return apiPost(BASE+'/admin/calendar/save', ev); }
function deleteEvent(id) { return apiPost(BASE+'/admin/calendar/delete', { id }); }

function loadMemos(ym) {
    return apiGet(BASE+'/admin/util/memo/month?yearMonth='+ym)
        .then(list => {
            if (!Array.isArray(list)) return;
            list.forEach(m => {
                const existing = state.events.find(e=>e.date===m.memoDate && e._memo);
                if (!existing) {
                    state.events.push({
                        id: '_memo_'+m.memoDate,
                        title: m.content.substring(0,30)+(m.content.length>30?'…':''),
                        date: m.memoDate,
                        startTime: null, endTime: null,
                        allDay: true,
                        color: 'purple',
                        memo: m.content,
                        _memo: true
                    });
                }
            });
            renderAll();
        }).catch(()=>{});
}

function renderMini() {
    const grid  = document.getElementById('miniGrid');
    const label = document.getElementById('miniMonthLabel');
    if (!grid) return;
    label.textContent = state.year+'년 '+MONTHS_KO[state.month];
    const tDays = new Date(state.year, state.month+1, 0).getDate();
    const sDay  = new Date(state.year, state.month, 1).getDay();
    const today = new Date(); today.setHours(0,0,0,0);
    let selKey = null;
    if (state.view==='day') selKey = dateKey(state.dayDate);
    let h = '';
    ['일','월','화','수','목','금','토'].forEach(d => { h += '<div class="mwk">'+d+'</div>'; });
    for (let i=0;i<sDay;i++) h+='<div></div>';
    for (let i=1;i<=tDays;i++) {
        const dt  = new Date(state.year, state.month, i);
        const key = dateKey(dt);
        const isT = isSameDay(dt, today);
        const isSel = selKey===key;
        const hasEv = state.events.some(e=>e.date===key);
        const cls = ['mday',
            isT       ? 'is-today'   : '',
            isSel&&!isT ? 'is-selected' : '',
            hasEv     ? 'has-event'  : '',
        ].filter(Boolean).join(' ');
        h += '<div class="'+cls+'" data-key="'+key+'">'+i+'</div>';
    }
    grid.innerHTML = h;
    grid.querySelectorAll('.mday[data-key]').forEach(el => {
        el.addEventListener('click', () => {
            const [y,m,d] = el.dataset.key.split('-').map(Number);
            state.dayDate = new Date(y, m-1, d);
            state.year    = y;
            state.month   = m-1;
            setView('day');
        });
    });
}

function renderUpcoming() {
    const list  = document.getElementById('upcomingList');
    const count = document.getElementById('upcomingCount');
    if (!list) return;
    const now  = new Date(); now.setHours(0,0,0,0);
    const soon = state.events
        .filter(e => {
            const d = new Date(e.date+'T00:00:00');
            return d >= now;
        })
        .sort((a,b) => {
            const da = a.date+(a.startTime||''), db = b.date+(b.startTime||'');
            return da<db?-1:da>db?1:0;
        })
        .slice(0,20);
    if (count) count.textContent = soon.length;
    if (!soon.length) {
        list.innerHTML = '<div class="cp-upcoming-empty">예정된 일정이 없어요</div>';
        return;
    }
    list.innerHTML = soon.map(ev => {
        const hex     = colorHex(ev.color);
        const timeStr = ev.allDay ? '종일' : (ev.startTime||'')+(ev.endTime?' – '+ev.endTime:'');
        return '<div class="cp-event-chip" data-id="'+esc(ev.id)+'">' +
            '<div class="cp-event-chip-dot" style="background:'+hex+';"></div>' +
            '<div class="cp-event-chip-body">' +
            '<div class="cp-event-chip-title">'+esc(ev.title||'(제목 없음)')+'</div>' +
            '<div class="cp-event-chip-meta"><span>'+esc(ev.date)+'</span>' +
            (timeStr?'<span>'+esc(timeStr)+'</span>':'')+'</div>' +
            '</div></div>';
    }).join('');
    list.querySelectorAll('.cp-event-chip[data-id]').forEach(el => {
        el.addEventListener('click', () => {
            const ev = state.events.find(e=>e.id===el.dataset.id);
            if (ev) openEditorForEvent(ev);
        });
    });
}

function renderLabel() {
    const el = document.getElementById('mainLabel');
    if (!el) return;
    if (state.view==='month') {
        el.textContent = state.year+'년 '+MONTHS_KO[state.month];
    } else if (state.view==='week') {
        const end = addDays(state.weekStart, 6);
        el.textContent = state.weekStart.getFullYear()+'년 '+
            MONTHS_KO[state.weekStart.getMonth()]+' '+
            state.weekStart.getDate()+'일 – '+
            (state.weekStart.getMonth()!==end.getMonth() ? MONTHS_KO[end.getMonth()]+' ':'')+
            end.getDate()+'일';
    } else {
        const d = state.dayDate;
        el.textContent = d.getFullYear()+'년 '+MONTHS_KO[d.getMonth()]+' '+d.getDate()+'일 '+DAYS_KO[d.getDay()]+'요일';
    }
}

function renderMonth() {
    const grid = document.getElementById('monthGrid');
    if (!grid) return;
    const firstDay = new Date(state.year, state.month, 1);
    const lastDay  = new Date(state.year, state.month+1, 0);
    const startPad = firstDay.getDay();
    const endPad   = 6 - lastDay.getDay();
    const today    = new Date(); today.setHours(0,0,0,0);
    let h = '';
    for (let i=startPad-1;i>=0;i--) {
        h += renderMonthCell(new Date(state.year, state.month, -i), today, true);
    }
    for (let i=1;i<=lastDay.getDate();i++) {
        h += renderMonthCell(new Date(state.year, state.month, i), today, false);
    }
    for (let i=1;i<=endPad;i++) {
        h += renderMonthCell(new Date(state.year, state.month+1, i), today, true);
    }
    grid.innerHTML = h;
    grid.querySelectorAll('.cp-month-cell[data-key]').forEach(el => {
        el.addEventListener('dragover', e => {
            e.preventDefault();
            clearDragOver();
            el.classList.add('drag-over');
        });
        el.addEventListener('dragleave', e => {
            if (!el.contains(e.relatedTarget)) el.classList.remove('drag-over');
        });
        el.addEventListener('drop', e => {
            e.preventDefault();
            el.classList.remove('drag-over');
            if (!draggedEv) return;
            const newDate = el.dataset.key;
            if (draggedEv.date !== newDate) {
                draggedEv.date = newDate;
                saveEvent(draggedEv);
                renderAll();
                showToast('일정을 이동했습니다.', 'success');
            }
        });
        el.addEventListener('click', e => {
            if (e.target.closest('.cp-month-event')) return;
            if (e.target.closest('.cp-month-more')) return;
            openEditorNew(null, el.dataset.key, null, null);
        });
        el.addEventListener('contextmenu', e => {
            e.preventDefault();
            if (e.target.closest('.cp-month-event')) return;
            showCellContextMenu(e, el.dataset.key);
        });
    });
    grid.querySelectorAll('.cp-month-event[data-id]').forEach(el => {
        el.setAttribute('draggable', 'true');
        el.addEventListener('dragstart', e => {
            e.stopPropagation();
            draggedEv = state.events.find(x=>x.id===el.dataset.id);
            if (!draggedEv) return;
            el.classList.add('is-dragging');
            const ghost = makeDragGhost(draggedEv);
            e.dataTransfer.setDragImage(ghost, 60, 18);
            setTimeout(() => ghost.remove(), 0);
            e.dataTransfer.effectAllowed = 'move';
        });
        el.addEventListener('dragend', () => {
            el.classList.remove('is-dragging');
            clearDragOver();
        });
        el.addEventListener('click', e => {
            e.stopPropagation();
            const ev = state.events.find(x=>x.id===el.dataset.id);
            if (ev) showPopover(ev, el);
        });
        el.addEventListener('contextmenu', e => {
            e.stopPropagation();
            e.preventDefault();
            const ev = state.events.find(x=>x.id===el.dataset.id);
            if (ev) showEventContextMenu(e, ev);
        });
    });
}

function renderMonthCell(d, today, otherMonth) {
    const key    = dateKey(d);
    const isT    = isSameDay(d, today);
    const dayEvs = state.events.filter(e=>e.date===key)
        .sort((a,b)=>timeToMin(a.startTime)-timeToMin(b.startTime));
    const cls = ['cp-month-cell',
        otherMonth    ? 'other-month' : '',
        isT           ? 'is-today'    : '',
        dayEvs.length ? 'has-memo'    : '',
    ].filter(Boolean).join(' ');
    const dayNumHTML = isT
        ? '<div class="cp-month-today-circle">'+d.getDate()+'</div>'
        : '<span>'+d.getDate()+'</span>';
    const MAX_SHOW = 3;
    const evHTML = dayEvs.slice(0,MAX_SHOW).map(ev => {
        const hex = colorHex(ev.color);
        return '<div class="cp-month-event" data-id="'+esc(ev.id)+'" style="background:'+hex+';">' +
            '<div class="cp-month-event-dot"></div>' +
            '<div class="cp-month-event-text">' +
            (ev.startTime?'<span style="opacity:.8;font-size:9px;margin-right:3px;">'+esc(ev.startTime)+'</span>':'')+
            esc(ev.title||'(제목 없음)')+'</div></div>';
    }).join('');
    const moreHTML = dayEvs.length>MAX_SHOW
        ? '<div class="cp-month-more">+' + (dayEvs.length-MAX_SHOW) + '개 더보기</div>'
        : '';
    return '<div class="'+cls+'" data-key="'+key+'">' +
        '<div class="cp-month-day-num">'+dayNumHTML+'</div>' +
        evHTML + moreHTML + '</div>';
}

function renderWeek() {
    renderWeekHeader();
    renderWeekGrid();
    scrollToCurrentHour();
    startNowLine();
}

function renderWeekHeader() {
    const header = document.getElementById('weekHeader');
    if (!header) return;
    const today = new Date(); today.setHours(0,0,0,0);
    let h = '<div class="cp-week-header-spacer"></div>';
    for (let i=0;i<7;i++) {
        const d   = addDays(state.weekStart, i);
        const isT = isSameDay(d, today);
        const cls = ['cp-week-header-day',
            isT         ? 'is-today' : '',
            d.getDay()===0 ? 'is-sun' : '',
            d.getDay()===6 ? 'is-sat' : '',
        ].filter(Boolean).join(' ');
        h += '<div class="'+cls+'" data-key="'+dateKey(d)+'">' +
            '<div class="cp-week-header-day-name">'+DAYS_KO[d.getDay()]+'</div>' +
            '<div class="cp-week-header-day-num">'+d.getDate()+'</div></div>';
    }
    header.innerHTML = h;
    header.querySelectorAll('.cp-week-header-day[data-key]').forEach(el=>{
        el.addEventListener('click', ()=>{
            const [y,m,d] = el.dataset.key.split('-').map(Number);
            state.dayDate = new Date(y,m-1,d);
            setView('day');
        });
    });
}

function renderWeekGrid() {
    const grid = document.getElementById('weekGrid');
    if (!grid) return;
    const today = new Date(); today.setHours(0,0,0,0);
    let h = '';
    for (let hour=0; hour<24; hour++) {
        const label = hour===0 ? '' : pad(hour)+':00';
        h += '<div class="cp-time-label"><span>'+esc(label)+'</span></div>';
        for (let col=0; col<7; col++) {
            const d   = addDays(state.weekStart, col);
            const isT = isSameDay(d, today);
            const key = dateKey(d);
            h += '<div class="cp-day-col'+(isT?' is-today':'')+'" data-key="'+key+'" data-hour="'+hour+'">' +
                '<div class="cp-hour-line"></div></div>';
        }
    }
    grid.innerHTML = h;
    positionWeekBlocks(grid, today);
    grid.querySelectorAll('.cp-day-col').forEach(col=>{
        col.addEventListener('dragover', e => {
            e.preventDefault();
            e.dataTransfer.dropEffect = 'move';
            if (!col.classList.contains('drag-over')) {
                clearDragOver();
                col.classList.add('drag-over');
            }
        });
        col.addEventListener('dragleave', e => {
            if (!col.contains(e.relatedTarget)) col.classList.remove('drag-over');
        });
        col.addEventListener('drop', e => {
            e.preventDefault();
            col.classList.remove('drag-over');
            if (!draggedEv || draggedEv.allDay) return;
            const rect     = col.getBoundingClientRect();
            const relY     = e.clientY - rect.top - dragStartY;
            const hour     = parseInt(col.dataset.hour||0);
            const mins     = hour*60 + Math.floor((relY/ROW_H)*60/15)*15;
            const duration = timeToMin(draggedEv.endTime||'10:00') - timeToMin(draggedEv.startTime||'09:00');
            const newStart = Math.max(0, Math.min(mins, 24*60 - duration));
            draggedEv.date      = col.dataset.key;
            draggedEv.startTime = minToTime(newStart);
            draggedEv.endTime   = minToTime(newStart + duration);
            saveEvent(draggedEv);
            renderAll();
            showToast('일정을 이동했습니다.', 'success');
        });
        col.addEventListener('click', e=>{
            if (e.target.closest('.cp-block')) return;
            const rect  = col.getBoundingClientRect();
            const relY  = e.clientY - rect.top;
            const hour  = parseInt(col.dataset.hour||0);
            const mins  = hour*60 + Math.floor((relY/ROW_H)*60/15)*15;
            const start = minToTime(Math.min(mins, 23*60));
            const end   = minToTime(Math.min(mins+60, 24*60-1));
            openEditorNew(null, col.dataset.key, start, end);
        });
        col.addEventListener('contextmenu', e=>{
            if (e.target.closest('.cp-block')) return;
            e.preventDefault();
            const rect = col.getBoundingClientRect();
            const relY = e.clientY - rect.top;
            const hour = parseInt(col.dataset.hour||0);
            const mins = hour*60 + Math.floor((relY/ROW_H)*60/15)*15;
            const start = minToTime(Math.min(mins, 23*60));
            const end   = minToTime(Math.min(mins+60, 24*60-1));
            showCellContextMenu(e, col.dataset.key, start, end);
        });
    });
}

function positionWeekBlocks(grid, today) {
    grid.querySelectorAll('.cp-block').forEach(b=>b.remove());
    for (let col=0;col<7;col++) {
        const d   = addDays(state.weekStart, col);
        const key = dateKey(d);
        const dayEvs = state.events
            .filter(e=>e.date===key && !e.allDay)
            .sort((a,b)=>timeToMin(a.startTime)-timeToMin(b.startTime));
        const placed = assignColumns(dayEvs);
        placed.forEach(({ ev, colIdx, colCount }) => {
            const cell = grid.querySelector(`.cp-day-col[data-key="${key}"][data-hour="0"]`);
            if (!cell) return;
            const startMin = timeToMin(ev.startTime||'09:00');
            const endMin   = timeToMin(ev.endTime||'10:00');
            const duration = Math.max(endMin-startMin, 15);
            const topPx    = (startMin / 60) * ROW_H;
            const heightPx = Math.max((duration / 60) * ROW_H, 22);
            const colW     = 100 / colCount;
            const block = buildBlock(ev, topPx, heightPx, colIdx, colW);
            const wrapper = getOrCreateDayOverlay(grid, key);
            wrapper.appendChild(block);
            attachBlockEvents(block, ev);
        });
    }
    renderWeekAllDay();
}

function buildBlock(ev, topPx, heightPx, colIdx, colW) {
    const block = document.createElement('div');
    block.className = 'cp-block';
    block.dataset.id = ev.id;
    block.style.cssText = [
        'top:'+topPx+'px',
        'height:'+heightPx+'px',
        'left:'+(3 + colIdx * colW)+'%',
        'width:'+(colW - 1)+'%',
        'background:'+colorHex(ev.color),
        'position:absolute',
    ].join(';');
    block.innerHTML =
        '<div class="cp-block-title">'+esc(ev.title||'(제목 없음)')+'</div>' +
        (heightPx>36 ? '<div class="cp-block-time">'+esc((ev.startTime||'')+' – '+(ev.endTime||''))+'</div>' : '') +
        '<div class="cp-block-resize" data-resize="1"></div>';
    return block;
}

function attachBlockEvents(block, ev) {
    block.setAttribute('draggable', 'true');
    block.addEventListener('dragstart', e => {
        if (e.target.dataset.resize) { e.preventDefault(); return; }
        e.stopPropagation();
        draggedEv  = ev;
        dragStartY = e.clientY - block.getBoundingClientRect().top;
        block.classList.add('is-dragging');
        const ghost = makeDragGhost(ev);
        e.dataTransfer.setDragImage(ghost, 60, 18);
        setTimeout(() => ghost.remove(), 0);
        e.dataTransfer.effectAllowed = 'move';
    });
    block.addEventListener('dragend', () => {
        block.classList.remove('is-dragging');
        clearDragOver();
        draggedEv = null;
    });
    block.addEventListener('click', e=>{
        if (e.target.dataset.resize) return;
        e.stopPropagation();
        showPopover(ev, block);
    });
    block.addEventListener('contextmenu', e=>{
        e.stopPropagation();
        e.preventDefault();
        showEventContextMenu(e, ev);
    });
    const resizeHandle = block.querySelector('.cp-block-resize');
    if (resizeHandle) {
        resizeHandle.addEventListener('mousedown', e => {
            e.stopPropagation();
            e.preventDefault();
            resizingEv    = ev;
            resizeStartY  = e.clientY;
            resizeOrigEnd = timeToMin(ev.endTime||'10:00');
            resizeBlock   = block;
            document.body.style.cursor = 'ns-resize';
            document.body.style.userSelect = 'none';
        });
    }
}

function getOrCreateDayOverlay(grid, key) {
    let wrapper = grid.querySelector('.cp-day-overlay[data-key="'+key+'"]');
    if (!wrapper) {
        wrapper = document.createElement('div');
        wrapper.className = 'cp-day-overlay';
        wrapper.dataset.key = key;
        const cell = grid.querySelector(`.cp-day-col[data-key="${key}"][data-hour="0"]`);
        if (cell) {
            cell.style.position = 'relative';
            wrapper.style.cssText = 'position:absolute;top:0;left:0;right:0;height:'+(ROW_H*24)+'px;pointer-events:none;z-index:2;';
            cell.appendChild(wrapper);
        }
    }
    return wrapper;
}

function renderWeekAllDay() {
    const header = document.getElementById('weekHeader');
    if (!header) return;
    header.querySelectorAll('.cp-allday-row').forEach(r=>r.remove());
    const allDayEvs = state.events.filter(e=>e.allDay);
    if (!allDayEvs.length) return;
    const byDate = {};
    allDayEvs.forEach(ev=>{
        if (!byDate[ev.date]) byDate[ev.date]=[];
        byDate[ev.date].push(ev);
    });
    const rowDiv = document.createElement('div');
    rowDiv.className = 'cp-allday-row';
    rowDiv.style.cssText = 'display:grid;grid-template-columns:60px repeat(7,minmax(0,1fr));border-top:1px solid var(--border-color);';
    rowDiv.innerHTML = '<div style="padding:4px 8px;font-size:9px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:.07em;display:flex;align-items:center;">종일</div>';
    for (let i=0;i<7;i++) {
        const d   = addDays(state.weekStart, i);
        const key = dateKey(d);
        const evs = byDate[key]||[];
        const cell = document.createElement('div');
        cell.style.cssText = 'padding:3px 4px;min-height:28px;border-left:1px solid var(--border-color);display:flex;flex-wrap:wrap;gap:2px;';
        evs.forEach(ev=>{
            const chip = document.createElement('div');
            chip.dataset.id = ev.id;
            chip.style.cssText = 'background:'+colorHex(ev.color)+';color:#fff;font-size:10px;font-weight:600;padding:2px 7px;border-radius:4px;cursor:pointer;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:100%;';
            chip.textContent = ev.title||'(제목 없음)';
            chip.addEventListener('click', ()=>showPopover(ev, chip));
            chip.addEventListener('contextmenu', e=>{ e.preventDefault(); showEventContextMenu(e, ev); });
            cell.appendChild(chip);
        });
        rowDiv.appendChild(cell);
    }
    header.appendChild(rowDiv);
}

function assignColumns(evs) {
    const result = [];
    const cols   = [];
    evs.forEach(ev=>{
        const s = timeToMin(ev.startTime||'09:00');
        const e = timeToMin(ev.endTime||'10:00');
        let placed = false;
        for (let i=0;i<cols.length;i++) {
            if (cols[i] <= s) {
                cols[i] = e;
                result.push({ ev, colIdx:i, colCount:0 });
                placed = true; break;
            }
        }
        if (!placed) {
            cols.push(e);
            result.push({ ev, colIdx:cols.length-1, colCount:0 });
        }
    });
    result.forEach(r=>{ r.colCount = cols.length; });
    return result;
}

function renderDay() {
    const d     = state.dayDate;
    const today = new Date(); today.setHours(0,0,0,0);
    const dateEl = document.getElementById('dayHeaderDate');
    const dowEl  = document.getElementById('dayHeaderDow');
    if (dateEl) {
        dateEl.textContent = d.getFullYear()+'년 '+MONTHS_KO[d.getMonth()]+' '+d.getDate()+'일';
        dateEl.className   = 'cp-day-header-date'+(isSameDay(d,today)?' is-today':'');
    }
    if (dowEl) dowEl.textContent = DAYS_KO[d.getDay()]+'요일';
    const grid = document.getElementById('dayGrid');
    if (!grid) return;
    let h = '';
    for (let hour=0;hour<24;hour++) {
        const label = hour===0 ? '' : pad(hour)+':00';
        h += '<div class="cp-time-label"><span>'+esc(label)+'</span></div>' +
             '<div class="cp-day-col-single" data-hour="'+hour+'"><div class="cp-hour-line"></div></div>';
    }
    grid.innerHTML = h;
    const key    = dateKey(d);
    const dayEvs = state.events.filter(e=>e.date===key && !e.allDay)
        .sort((a,b)=>timeToMin(a.startTime)-timeToMin(b.startTime));
    const placed = assignColumns(dayEvs);
    const cell0 = grid.querySelector('.cp-day-col-single[data-hour="0"]');
    if (cell0) {
        cell0.style.position = 'relative';
        const wrap = document.createElement('div');
        wrap.style.cssText = 'position:absolute;top:0;left:0;right:0;height:'+(ROW_H*24)+'px;pointer-events:none;';
        cell0.appendChild(wrap);
        placed.forEach(({ ev, colIdx, colCount })=>{
            const startMin = timeToMin(ev.startTime||'09:00');
            const endMin   = timeToMin(ev.endTime||'10:00');
            const duration = Math.max(endMin-startMin, 15);
            const topPx    = (startMin/60)*ROW_H;
            const heightPx = Math.max((duration/60)*ROW_H, 22);
            const colW     = 100/colCount;
            const block = buildBlock(ev, topPx, heightPx, colIdx, colW);
            block.style.pointerEvents = 'auto';
            wrap.appendChild(block);
            attachBlockEvents(block, ev);
        });
    }
    const allDay = state.events.filter(e=>e.date===key && e.allDay);
    if (allDay.length) {
        const bar = document.createElement('div');
        bar.style.cssText = 'display:flex;flex-wrap:wrap;gap:4px;padding:6px 12px;background:var(--card-bg);border-bottom:1px solid var(--border-color);';
        allDay.forEach(ev=>{
            const chip = document.createElement('div');
            chip.style.cssText = 'background:'+colorHex(ev.color)+';color:#fff;font-size:11px;font-weight:600;padding:3px 10px;border-radius:5px;cursor:pointer;';
            chip.textContent = ev.title||'(제목 없음)';
            chip.addEventListener('click', ()=>showPopover(ev, chip));
            chip.addEventListener('contextmenu', e=>{ e.preventDefault(); showEventContextMenu(e, ev); });
            bar.appendChild(chip);
        });
        const body = document.getElementById('dayBody');
        if (body) body.prepend(bar);
    }
    if (isSameDay(d, today)) {
        const nowLine = document.createElement('div');
        nowLine.id = 'dayNowLine';
        nowLine.className = 'cp-now-line';
        if (cell0) { cell0.style.position = 'relative'; cell0.appendChild(nowLine); }
        updateNowLine('dayNowLine');
    }
    grid.querySelectorAll('.cp-day-col-single').forEach(col=>{
        col.addEventListener('dragover', e => {
            e.preventDefault();
            e.dataTransfer.dropEffect = 'move';
            if (!col.classList.contains('drag-over')) {
                clearDragOver();
                col.classList.add('drag-over');
            }
        });
        col.addEventListener('dragleave', e => {
            if (!col.contains(e.relatedTarget)) col.classList.remove('drag-over');
        });
        col.addEventListener('drop', e => {
            e.preventDefault();
            col.classList.remove('drag-over');
            if (!draggedEv || draggedEv.allDay) return;
            const rect     = col.getBoundingClientRect();
            const relY     = e.clientY - rect.top - dragStartY;
            const hour     = parseInt(col.dataset.hour||0);
            const mins     = hour*60 + Math.floor((relY/ROW_H)*60/15)*15;
            const duration = timeToMin(draggedEv.endTime||'10:00') - timeToMin(draggedEv.startTime||'09:00');
            const newStart = Math.max(0, Math.min(mins, 24*60 - duration));
            draggedEv.date      = key;
            draggedEv.startTime = minToTime(newStart);
            draggedEv.endTime   = minToTime(newStart + duration);
            saveEvent(draggedEv);
            renderAll();
            showToast('일정을 이동했습니다.', 'success');
        });
        col.addEventListener('click', e=>{
            if (e.target.closest('.cp-block')) return;
            const rect  = col.getBoundingClientRect();
            const relY  = e.clientY - rect.top;
            const hour  = parseInt(col.dataset.hour||0);
            const mins  = hour*60 + Math.floor((relY/ROW_H)*60/15)*15;
            const start = minToTime(Math.min(mins, 23*60));
            const end   = minToTime(Math.min(mins+60, 24*60-1));
            openEditorNew(null, key, start, end);
        });
        col.addEventListener('contextmenu', e=>{
            if (e.target.closest('.cp-block')) return;
            e.preventDefault();
            const rect = col.getBoundingClientRect();
            const relY = e.clientY - rect.top;
            const hour = parseInt(col.dataset.hour||0);
            const mins = hour*60 + Math.floor((relY/ROW_H)*60/15)*15;
            const start = minToTime(Math.min(mins, 23*60));
            const end   = minToTime(Math.min(mins+60, 24*60-1));
            showCellContextMenu(e, key, start, end);
        });
    });
    scrollToCurrentHour('dayBody');
}

function updateNowLine(id) {
    const line = document.getElementById(id||'weekNowLine');
    if (!line) return;
    const now  = new Date();
    line.style.top = ((now.getHours()*60+now.getMinutes())/60)*ROW_H+'px';
}

function startNowLine() {
    clearInterval(nowTimer);
    const today = new Date(); today.setHours(0,0,0,0);
    const grid  = document.getElementById('weekGrid');
    if (!grid) return;
    grid.querySelectorAll('.cp-now-line').forEach(l=>l.remove());
    const key  = dateKey(today);
    const cell = grid.querySelector(`.cp-day-col[data-key="${key}"][data-hour="0"]`);
    if (!cell) return;
    const line = document.createElement('div');
    line.id = 'weekNowLine';
    line.className = 'cp-now-line';
    cell.appendChild(line);
    updateNowLine('weekNowLine');
    nowTimer = setInterval(()=>updateNowLine('weekNowLine'), 60000);
}

function scrollToCurrentHour(bodyId) {
    const body = document.getElementById(bodyId||'weekBody');
    if (!body) return;
    const scrollTo = Math.max(0, (new Date().getHours()-1)*ROW_H);
    setTimeout(()=>{ body.scrollTop = scrollTo; }, 50);
}

function buildColorRow() {
    const row = document.getElementById('colorRow');
    if (!row) return;
    row.innerHTML = COLORS.map(c=>
        '<div class="cp-color-swatch'+(c.id===state.selectedColor?' active':'')+'"' +
        ' data-color="'+c.id+'" style="background:'+c.hex+';color:'+c.hex+';" title="'+c.id+'"></div>'
    ).join('');
    row.querySelectorAll('.cp-color-swatch').forEach(el=>{
        el.addEventListener('click', ()=>{
            state.selectedColor = el.dataset.color;
            row.querySelectorAll('.cp-color-swatch').forEach(s=>s.classList.remove('active'));
            el.classList.add('active');
        });
    });
}

function openEditorNew(id, date, startTime, endTime) {
    closePopover();
    state.editingId     = null;
    state.selectedColor = getThemeDefaultColor();
    const now   = new Date();
    const sTime = startTime || pad(now.getHours())+':00';
    const eTime = endTime   || pad(Math.min(now.getHours()+1,23))+':00';
    buildColorRow();
    setField('evTitle',  '');
    setField('evDate',   date||dateKey(now));
    setField('evStart',  sTime);
    setField('evEnd',    eTime);
    setField('evMemo',   '');
    setField('evType',   'basic');
    setCheck('evAllDay', false);
    toggleTimeFields(false);
    const delBtn = document.getElementById('evDeleteBtn');
    if (delBtn) delBtn.classList.add('hidden');
    openModal();
}

function openEditorForEvent(ev) {
    closePopover();
    state.editingId     = ev.id;
    state.selectedColor = ev.color||'purple';
    buildColorRow();
    setField('evTitle',  ev.title||'');
    setField('evDate',   ev.date||'');
    setField('evStart',  ev.startTime||'09:00');
    setField('evEnd',    ev.endTime||'10:00');
    setField('evMemo',   ev.memo||'');
    setField('evType',   ev.type||'basic');
    setCheck('evAllDay', !!ev.allDay);
    toggleTimeFields(!!ev.allDay);
    const delBtn = document.getElementById('evDeleteBtn');
    if (delBtn) delBtn.classList.remove('hidden');
    openModal();
}

function openModal() { 
    const overlay = document.getElementById('modalOverlay');
    if(overlay) overlay.classList.add('open');
    setTimeout(()=>{ 
        const titleInput = document.getElementById('evTitle');
        if(titleInput) titleInput.focus(); 
    }, 200); 
}

function closeModal() { 
    const overlay = document.getElementById('modalOverlay');
    if(overlay) overlay.classList.remove('open'); 
}

function setField(id, val) { const el = document.getElementById(id); if (el) el.value = val; }
function setCheck(id, val) { const el = document.getElementById(id); if (el) el.checked = val; }
function getField(id)      { return (document.getElementById(id)||{}).value||''; }
function getCheck(id)      { return !!(document.getElementById(id)||{}).checked; }

function toggleTimeFields(allDay) {
    const timeRow = document.getElementById('timeFieldsRow');
    if (timeRow) timeRow.style.display = allDay ? 'none' : 'flex';
}

function showPopover(ev, anchorEl) {
    closePopover();
    state.popoverId = ev.id;
    const hex     = colorHex(ev.color);
    const timeStr = ev.allDay ? '종일' : (ev.startTime||'')+(ev.endTime?' – '+ev.endTime:'');
    const pop = document.createElement('div');
    pop.className = 'cp-popover';
    pop.id = 'cpPopover';
    pop.innerHTML =
        '<div class="cp-popover-stripe" style="background:'+hex+';"></div>' +
        '<div class="cp-popover-inner">' +
        '<div class="cp-popover-title">'+esc(ev.title||'(제목 없음)')+'</div>' +
        '<div class="cp-popover-meta"><i class="ri-calendar-line"></i>'+esc(ev.date)+
        (timeStr?' <i class="ri-time-line"></i>'+esc(timeStr):'')+'</div>' +
        (ev.memo?'<div class="cp-popover-desc">'+esc(ev.memo)+'</div>':'') +
        '<div class="cp-popover-actions">' +
        '<button class="cp-popover-btn edit" id="popEditBtn"><i class="ri-pencil-line"></i> 편집</button>' +
        '<button class="cp-popover-btn del" id="popDelBtn"><i class="ri-delete-bin-line"></i> 삭제</button>' +
        '</div></div>';
    document.getElementById('popoverContainer').appendChild(pop);
    const rect = anchorEl.getBoundingClientRect();
    const pw = 272, ph = 180;
    let left = rect.right + 8;
    let top  = rect.top;
    if (left+pw > window.innerWidth-16) left = rect.left-pw-8;
    if (top+ph > window.innerHeight-16) top = window.innerHeight-ph-16;
    top = Math.max(8, top);
    pop.style.left = left+'px';
    pop.style.top  = top+'px';
    pop.querySelector('#popEditBtn').addEventListener('click', ()=>{ closePopover(); openEditorForEvent(ev); });
    pop.querySelector('#popDelBtn').addEventListener('click', ()=>{ closePopover(); doDeleteEvent(ev.id); });
    setTimeout(()=>{
        document.addEventListener('click', closePopoverOnOutside, { once:true });
    }, 10);
}

function closePopoverOnOutside(e) {
    const pop = document.getElementById('cpPopover');
    if (pop && !pop.contains(e.target)) closePopover();
    else document.addEventListener('click', closePopoverOnOutside, { once:true });
}

function closePopover() {
    const pop = document.getElementById('cpPopover');
    if (pop) pop.remove();
    state.popoverId = null;
}

function showEventContextMenu(e, ev) {
    closeContextMenu();
    const menu = document.createElement('div');
    menu.className = 'cp-ctx-menu';
    menu.id = 'cpCtxMenu';
    menu.innerHTML =
        '<div class="cp-ctx-item" id="ctxEdit"><i class="ri-pencil-line"></i> 일정 편집</div>' +
        '<div class="cp-ctx-sep"></div>' +
        '<div class="cp-ctx-item danger" id="ctxDel"><i class="ri-delete-bin-line"></i> 일정 삭제</div>';
    document.body.appendChild(menu);
    positionMenu(menu, e.clientX, e.clientY);
    menu.querySelector('#ctxEdit').addEventListener('click', ()=>{ closeContextMenu(); openEditorForEvent(ev); });
    menu.querySelector('#ctxDel').addEventListener('click', ()=>{ closeContextMenu(); doDeleteEvent(ev.id); });
    setTimeout(()=>{ document.addEventListener('click', closeContextMenuOnOutside, { once:true }); }, 10);
}

function showCellContextMenu(e, dateKey, startTime, endTime) {
    closeContextMenu();
    const menu = document.createElement('div');
    menu.className = 'cp-ctx-menu';
    menu.id = 'cpCtxMenu';
    menu.innerHTML =
        '<div class="cp-ctx-item" id="ctxNew"><i class="ri-add-circle-line"></i> 새 일정 추가</div>';
    document.body.appendChild(menu);
    positionMenu(menu, e.clientX, e.clientY);
    menu.querySelector('#ctxNew').addEventListener('click', ()=>{ closeContextMenu(); openEditorNew(null, dateKey, startTime||null, endTime||null); });
    setTimeout(()=>{ document.addEventListener('click', closeContextMenuOnOutside, { once:true }); }, 10);
}

function positionMenu(menu, x, y) {
    menu.style.left = x+'px';
    menu.style.top  = y+'px';
    requestAnimationFrame(()=>{
        const rect = menu.getBoundingClientRect();
        if (rect.right > window.innerWidth-8)  menu.style.left = (x - rect.width)+'px';
        if (rect.bottom > window.innerHeight-8) menu.style.top = (y - rect.height)+'px';
    });
}

function closeContextMenuOnOutside(e) {
    const menu = document.getElementById('cpCtxMenu');
    if (menu && !menu.contains(e.target)) closeContextMenu();
    else document.addEventListener('click', closeContextMenuOnOutside, { once:true });
}

function closeContextMenu() {
    const menu = document.getElementById('cpCtxMenu');
    if (menu) menu.remove();
}

function doSaveEvent() {
    const title  = getField('evTitle').trim();
    const date   = getField('evDate');
    const allDay = getCheck('evAllDay');
    const start  = getField('evStart');
    const end    = getField('evEnd');
    const memo   = getField('evMemo');
    const type   = getField('evType');
    const color  = state.selectedColor;

    if (!date) {
        showToast('날짜를 선택해주세요.', 'error');
        return;
    }

	const ev = {
	    id: state.editingId ? state.editingId : null,
	    title: title || '(제목 없음)',
	    date,
	    startTime: allDay ? null : start,
	    endTime: allDay ? null : end,
	    allDay: allDay ? 1 : 0,
	    color,
	    memo,
	    type
	};

    saveEvent(ev)
        .then(d => {
            if (!d || d.success === false) {
                throw new Error((d && d.msg) || 'save failed');
            }
            closeModal();
            showToast(state.editingId ? '일정이 수정되었습니다.' : '일정이 저장되었습니다.', 'success');
            loadEvents();
        })
        .catch(() => showToast('서버 저장에 실패했습니다.', 'error'));
}

function doDeleteEvent(id) {
    deleteEvent(id)
        .then(d => {
            if (!d || d.success === false) {
                throw new Error((d && d.msg) || 'delete failed');
            }
            renderAll();
            showToast('일정이 삭제되었습니다.', 'success');
            loadEvents();
        })
        .catch(() => showToast('삭제 중 오류가 발생했습니다.', 'error'));
}

function setView(v) {
    state.view = v;
    document.querySelectorAll('.cp-view-tab').forEach(el=>{
        el.classList.toggle('active', el.dataset.view===v);
    });
    if (v==='week') {
        state.year  = state.weekStart.getFullYear();
        state.month = state.weekStart.getMonth();
    } else if (v==='day') {
        state.year  = state.dayDate.getFullYear();
        state.month = state.dayDate.getMonth();
    }
    document.getElementById('monthView').classList.toggle('hidden', v!=='month');
    document.getElementById('weekView').classList.toggle('hidden',  v!=='week');
    document.getElementById('dayView').classList.toggle('hidden',   v!=='day');
    loadEvents();
    loadMemos(state.year+'-'+pad(state.month+1));
}

function navigate(dir) {
    if (state.view==='month') {
        state.month += dir;
        if (state.month>11) { state.month=0; state.year++; }
        if (state.month<0)  { state.month=11; state.year--; }
    } else if (state.view==='week') {
        state.weekStart = addDays(state.weekStart, dir*7);
        state.year  = state.weekStart.getFullYear();
        state.month = state.weekStart.getMonth();
    } else {
        state.dayDate = addDays(state.dayDate, dir);
        state.year    = state.dayDate.getFullYear();
        state.month   = state.dayDate.getMonth();
    }
    loadEvents();
    loadMemos(state.year+'-'+pad(state.month+1));
}

function goToday() {
    const t = new Date();
    state.year      = t.getFullYear();
    state.month     = t.getMonth();
    state.weekStart = getWeekStart(t);
    state.dayDate   = new Date(t); state.dayDate.setHours(0,0,0,0);
    loadEvents();
    loadMemos(state.year+'-'+pad(state.month+1));
}

function renderAll() {
    renderLabel();
    renderMini();
    renderUpcoming();
    if (state.view==='month') renderMonth();
    if (state.view==='week')  renderWeek();
    if (state.view==='day')   renderDay();
}

let toastTimer = null;
function showToast(msg, type) {
    const el  = document.getElementById('cpToast');
    const txt = document.getElementById('cpToastMsg');
    if (!el||!txt) return;
    txt.textContent = msg;
    el.className = 'cp-toast show '+(type||'success');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(()=>el.classList.remove('show'), 2800);
}

/**
 * applyTheme — admin_main.js의 applyTheme과 동일한 방식.
 * data-theme 속성 적용, localStorage 저장, 서버 저장(/admin/theme/save).
 * calendar.js에서는 이 함수만 사용하며, 사이드바 테마바 UI는 제거됨.
 * (테마 변경은 어드민 헤더 설정에서 수행)
 */
function applyTheme(theme) {
    if (theme === 'purple') {
        document.documentElement.removeAttribute('data-theme');
    } else {
        document.documentElement.setAttribute('data-theme', theme);
    }
    state.selectedColor = getThemeDefaultColor();
}

function saveThemeToServer(theme) {
    try {
        const userIdx = window.ADMIN_USER_IDX || 'default';
        localStorage.setItem('baton-admin-theme-' + userIdx, theme);
        localStorage.setItem('baton-admin-theme', theme);
    } catch(e) {}
    fetch(BASE + '/admin/theme/save', {
        method: 'POST',
        credentials: 'same-origin',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'theme=' + encodeURIComponent(theme)
    }).catch(() => {});
}

/** 헤더 테마 드롭다운(.header-theme-dot)이 있을 경우 이벤트 연결 */
function initHeaderTheme() {
    const dots = document.querySelectorAll('.header-theme-dot[data-theme]');
    if (!dots.length) return;
    const current = document.documentElement.getAttribute('data-theme') || 'purple';
    dots.forEach(el => {
        el.classList.toggle('active', el.dataset.theme === current);
        el.addEventListener('click', () => {
            const theme = el.dataset.theme;
            applyTheme(theme);
            saveThemeToServer(theme);
            dots.forEach(d => d.classList.remove('active'));
            el.classList.add('active');
            /* 헤더 프리뷰 색상 동기화 */
            if (typeof window.syncHeaderThemePreview === 'function') {
                window.syncHeaderThemePreview();
            }
            /* 모달 색상 스트립도 현재 선택 색상에 맞춰 갱신 */
            updateModalAccent(state.selectedColor);
            showToast('테마가 변경되었습니다.', 'success');
        });
    });
}

document.addEventListener('mousemove', e => {
    if (!resizingEv) return;
    const dy      = e.clientY - resizeStartY;
    const deltaMins = Math.round((dy / ROW_H) * 60 / 15) * 15;
    const newEnd  = Math.max(resizeOrigEnd + 15, Math.min(resizeOrigEnd + deltaMins, 24*60));
    resizingEv.endTime = minToTime(newEnd);
    if (resizeBlock) {
        const startMin = timeToMin(resizingEv.startTime||'09:00');
        const duration = Math.max(newEnd - startMin, 15);
        const heightPx = Math.max((duration/60)*ROW_H, 22);
        resizeBlock.style.height = heightPx+'px';
        const timeEl = resizeBlock.querySelector('.cp-block-time');
        if (timeEl) timeEl.textContent = (resizingEv.startTime||'')+' – '+resizingEv.endTime;
        else if (heightPx > 36) {
            const t = document.createElement('div');
            t.className = 'cp-block-time';
            t.textContent = (resizingEv.startTime||'')+' – '+resizingEv.endTime;
            resizeBlock.insertBefore(t, resizeBlock.querySelector('.cp-block-resize'));
        }
    }
});

document.addEventListener('mouseup', () => {
    if (!resizingEv) return;
    const ev = resizingEv;
    resizingEv   = null;
    resizeBlock  = null;
    document.body.style.cursor = '';
    document.body.style.userSelect = '';
    saveEvent(ev);
    renderAll();
    showToast('일정 시간이 변경되었습니다.', 'success');
});

document.addEventListener('DOMContentLoaded', ()=>{
    const mainPrev = document.getElementById('mainPrev');
    if(mainPrev) mainPrev.addEventListener('click', ()=>navigate(-1));
    const mainNext = document.getElementById('mainNext');
    if(mainNext) mainNext.addEventListener('click', ()=>navigate(1));
    const miniPrev = document.getElementById('miniPrev');
    if(miniPrev) miniPrev.addEventListener('click', ()=>navigate(-1));
    const miniNext = document.getElementById('miniNext');
    if(miniNext) miniNext.addEventListener('click', ()=>navigate(1));
    const btnToday = document.getElementById('btnToday');
    if(btnToday) btnToday.addEventListener('click', goToday);
    document.querySelectorAll('.cp-view-tab').forEach(tab=>{
        tab.addEventListener('click', ()=>setView(tab.dataset.view));
    });
    const btnAdd = document.getElementById('btnAdd');
    if(btnAdd) btnAdd.addEventListener('click', ()=>{
        openEditorNew(null, dateKey(new Date()), null, null);
    });
    const evCancelBtn = document.getElementById('evCancelBtn');
    if(evCancelBtn) evCancelBtn.addEventListener('click', closeModal);
    const closeModalBtn = document.getElementById('closeModalBtn');
    if(closeModalBtn) closeModalBtn.addEventListener('click', closeModal);
    const evSaveBtn = document.getElementById('evSaveBtn');
    if(evSaveBtn) evSaveBtn.addEventListener('click', doSaveEvent);
    const evDeleteBtn = document.getElementById('evDeleteBtn');
    if(evDeleteBtn) evDeleteBtn.addEventListener('click', ()=>{
        if (state.editingId) { closeModal(); doDeleteEvent(state.editingId); }
    });
    const modalOverlay = document.getElementById('modalOverlay');
    if(modalOverlay) modalOverlay.addEventListener('click', e=>{
        if (e.target===document.getElementById('modalOverlay')) closeModal();
    });
    const evAllDay = document.getElementById('evAllDay');
    if(evAllDay) evAllDay.addEventListener('change', e=>{
        toggleTimeFields(e.target.checked);
    });
    document.addEventListener('keydown', e=>{
        if (e.key==='Escape') {
            closeModal();
            closePopover();
            closeContextMenu();
        }
        if (e.key==='ArrowLeft'  && !isInputFocused()) navigate(-1);
        if (e.key==='ArrowRight' && !isInputFocused()) navigate(1);
        if ((e.key==='m'||e.key==='M') && !isInputFocused()) setView('month');
        if ((e.key==='w'||e.key==='W') && !isInputFocused()) setView('week');
        if ((e.key==='d'||e.key==='D') && !isInputFocused()) setView('day');
        if ((e.key==='t'||e.key==='T') && !isInputFocused()) goToday();
    });
    document.addEventListener('contextmenu', e=>{
        if (e.target.closest('.cp-ctx-menu') ||
            e.target.closest('.cp-block') ||
            e.target.closest('.cp-month-event') ||
            e.target.closest('.cp-day-col') ||
            e.target.closest('.cp-day-col-single') ||
            e.target.closest('.cp-month-cell')) return;
        closeContextMenu();
    });
    initHeaderTheme();
    setView('week');
});

function isInputFocused() {
    const tag = document.activeElement?.tagName;
    return tag==='INPUT'||tag==='TEXTAREA'||tag==='SELECT';
}

})();