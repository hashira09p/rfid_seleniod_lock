// Sidebar functionality
document.addEventListener('turbo:load', function() {
    initSidebar();
});

document.addEventListener('DOMContentLoaded', function() {
    initSidebar();
});

function initSidebar() {
    // DOM Elements
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('main-content');
    const sidebarOverlay = document.getElementById('sidebar-overlay');

    if (!sidebarToggle || !sidebar) return;

    // Sidebar toggle functionality
    function toggleSidebar() {
        sidebar.classList.toggle('sidebar-collapsed');

        if (window.innerWidth < 992) {
            if (sidebar.classList.contains('sidebar-collapsed')) {
                sidebarOverlay.style.display = 'none';
                document.body.style.overflow = 'auto';
            } else {
                sidebarOverlay.style.display = 'block';
                document.body.style.overflow = 'hidden';
            }
        }
    }

    // Remove existing event listeners if any (to prevent duplicates with turbo)
    sidebarToggle.removeEventListener('click', toggleSidebar);
    if (sidebarOverlay) {
        sidebarOverlay.removeEventListener('click', handleOverlayClick);
    }
    window.removeEventListener('resize', handleResize);

    // Add event listeners
    sidebarToggle.addEventListener('click', toggleSidebar);

    function handleOverlayClick() {
        if (!sidebar.classList.contains('sidebar-collapsed')) {
            toggleSidebar();
        }
    }

    if (sidebarOverlay) {
        sidebarOverlay.addEventListener('click', handleOverlayClick);
    }

    function handleResize() {
        if (window.innerWidth >= 992) {
            sidebar.classList.remove('sidebar-collapsed');
            if (sidebarOverlay) {
                sidebarOverlay.style.display = 'none';
            }
            document.body.style.overflow = 'auto';
        } else {
            if (!sidebar.classList.contains('sidebar-collapsed')) {
                sidebar.classList.add('sidebar-collapsed');
                if (sidebarOverlay) {
                    sidebarOverlay.style.display = 'none';
                }
            }
        }
    }

    window.addEventListener('resize', handleResize);

    // Initialize sidebar state
    handleResize();
}