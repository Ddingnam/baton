(function () {
    'use strict';

    function ensureContainer() {
        var c = document.getElementById('adminToastContainer');
        if (!c) {
            c = document.createElement('div');
            c.id = 'adminToastContainer';
            document.body.appendChild(c);
        }
        return c;
    }

    function showToast(message, type, duration) {
        type = type || 'info';
        duration = duration !== undefined ? duration : 3200;

        var icons = {
            success : 'ri-checkbox-circle-fill',
            error   : 'ri-close-circle-fill',
            warning : 'ri-error-warning-fill',
            info    : 'ri-information-fill'
        };

        var container = ensureContainer();
        var toast = document.createElement('div');
        toast.className = 'admin-toast admin-toast--' + type;
        toast.innerHTML =
            '<i class="' + icons[type] + ' admin-toast__icon"></i>' +
            '<span class="admin-toast__msg">' + message + '</span>' +
            '<button class="admin-toast__close" aria-label="닫기"><i class="ri-close-line"></i></button>';

        container.appendChild(toast);

        void toast.offsetWidth;
        toast.classList.add('admin-toast--show');

        var timer;
        function dismiss() {
            clearTimeout(timer);
            toast.classList.remove('admin-toast--show');
            toast.addEventListener('transitionend', function () {
                if (toast.parentNode) toast.parentNode.removeChild(toast);
            }, { once: true });
        }

        toast.querySelector('.admin-toast__close').addEventListener('click', dismiss);
        if (duration > 0) timer = setTimeout(dismiss, duration);

        return { dismiss: dismiss };
    }

    function ensureConfirmModal() {
        if (document.getElementById('adminConfirmOverlay')) return;

        var html =
            '<div class="admin-confirm-overlay" id="adminConfirmOverlay">' +
              '<div class="admin-confirm-box" id="adminConfirmBox">' +
                '<div class="admin-confirm-icon-wrap" id="adminConfirmIconWrap">' +
                  '<i id="adminConfirmIcon"></i>' +
                '</div>' +
                '<p class="admin-confirm-title" id="adminConfirmTitle"></p>' +
                '<p class="admin-confirm-desc"  id="adminConfirmDesc"></p>' +
                '<div class="admin-confirm-btns">' +
                  '<button class="btn-pill btn-light" id="adminConfirmCancel">취소</button>' +
                  '<button class="btn-pill"           id="adminConfirmOk">확인</button>' +
                '</div>' +
              '</div>' +
            '</div>';

        var wrap = document.createElement('div');
        wrap.innerHTML = html;
        document.body.appendChild(wrap.firstElementChild);
    }

    function showConfirm(opts) {
        ensureConfirmModal();

        var typeIcon = {
            danger  : { icon: 'ri-error-warning-fill',    cls: 'confirm-icon--danger'  },
            warning : { icon: 'ri-alert-fill',             cls: 'confirm-icon--warning' },
            info    : { icon: 'ri-question-fill',          cls: 'confirm-icon--info'    },
            success : { icon: 'ri-checkbox-circle-fill',   cls: 'confirm-icon--success' }
        };
        var t = typeIcon[opts.type || 'info'];

        var overlay  = document.getElementById('adminConfirmOverlay');
        var iconWrap = document.getElementById('adminConfirmIconWrap');
        var icon     = document.getElementById('adminConfirmIcon');
        var title    = document.getElementById('adminConfirmTitle');
        var desc     = document.getElementById('adminConfirmDesc');
        var okBtn    = document.getElementById('adminConfirmOk');
        var cancelBtn= document.getElementById('adminConfirmCancel');

        iconWrap.className = 'admin-confirm-icon-wrap ' + t.cls;
        icon.className     = t.icon;
        title.textContent  = opts.title || '';
        desc.innerHTML     = opts.desc  || '';
        desc.style.display = opts.desc  ? '' : 'none';
        okBtn.textContent  = opts.okText || '확인';

        okBtn.className = 'btn-pill';
        if (opts.type === 'danger')  okBtn.style.cssText = 'background:var(--color-red);color:white;padding:12px 28px;';
        else if (opts.type === 'warning') okBtn.style.cssText = 'background:#F59E0B;color:white;padding:12px 28px;';
        else okBtn.style.cssText = 'background:var(--grad-primary);color:white;padding:12px 28px;';

        function close() {
            overlay.classList.remove('admin-confirm--show');
        }
        function handleOk() {
            close();
            cleanup();
            if (typeof opts.onOk === 'function') opts.onOk();
        }
        function handleCancel() {
            close();
            cleanup();
            if (typeof opts.onCancel === 'function') opts.onCancel();
        }
        function handleBg(e) {
            if (e.target === overlay) handleCancel();
        }
        function cleanup() {
            okBtn.removeEventListener('click', handleOk);
            cancelBtn.removeEventListener('click', handleCancel);
            overlay.removeEventListener('click', handleBg);
        }

        okBtn.addEventListener('click', handleOk);
        cancelBtn.addEventListener('click', handleCancel);
        overlay.addEventListener('click', handleBg);

        void overlay.offsetWidth;
        overlay.classList.add('admin-confirm--show');
    }

    window.showToast   = showToast;
    window.showConfirm = showConfirm;

})();