window.TimeAgo = {
    format: function(dateString) {
        if (!dateString) return "";
        let dateVal = dateString.toString().replace(/-/g, '/').replace('T', ' ').split('.')[0];
        const date = new Date(dateVal);
        const now = new Date();
        if (isNaN(date.getTime())) return dateString;

        const diff = Math.floor((now - date) / 1000);
        if (diff < 60) return "방금 전";
        if (diff < 3600) return Math.floor(diff / 60) + "분 전";
        if (diff < 86400) return Math.floor(diff / 3600) + "시간 전";
        if (diff < 2592000) return Math.floor(diff / 86400) + "일 전";

        return dateVal.split(' ')[0];
    },
    render: function() {
        document.querySelectorAll('.time-ago').forEach(el => {
            const rawDate = el.getAttribute('data-time');
            if (rawDate) el.innerText = this.format(rawDate);
        });
    }
};

document.addEventListener('DOMContentLoaded', () => window.TimeAgo.render());
document.addEventListener('click', () => {
    setTimeout(() => window.TimeAgo.render(), 50);
});