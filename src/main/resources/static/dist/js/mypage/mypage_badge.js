function openBadgeModal() {
    const modal = document.getElementById('badgeAllModal');
    if(modal) {
        modal.style.display = 'flex';
    }
}

function closeBadgeModal() {
    const modal = document.getElementById('badgeAllModal');
    if(modal) {
        modal.style.display = 'none';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('badgeAllModal');

    if(modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeBadgeModal();
            }
        });
    }
});