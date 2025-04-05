document.addEventListener('turbo:load', function() {
    const sidebar = document.getElementById('sidebar');
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const mainContent = document.getElementById('main-content');
    const sidebarOverlay = document.getElementById('sidebar-overlay');

    // Function to check window width and update sidebar state
    function checkWindowSize() {
        if (window.innerWidth < 992) {
            sidebar.classList.remove('sidebar-collapsed');
            mainContent.classList.remove('content-expanded');
        }
    }

    // Initial check on page load
    checkWindowSize();

    // Toggle sidebar on button click
    sidebarToggle.addEventListener('click', function() {
        if (window.innerWidth >= 992) {
            // For desktop: collapse/expand sidebar
            sidebar.classList.toggle('sidebar-collapsed');
            mainContent.classList.toggle('content-expanded');
        } else {
            // For mobile: show/hide sidebar with overlay
            sidebar.classList.toggle('sidebar-mobile-active');
            sidebarOverlay.classList.toggle('active');
        }
    });

    // Hide sidebar when clicking overlay (mobile only)
    sidebarOverlay.addEventListener('click', function() {
        sidebar.classList.remove('sidebar-mobile-active');
        sidebarOverlay.classList.remove('active');
    });

    // Update on window resize
    window.addEventListener('resize', function() {
        if (window.innerWidth >= 992) {
            sidebarOverlay.classList.remove('active');
            sidebar.classList.remove('sidebar-mobile-active');
        } else {
            sidebar.classList.remove('sidebar-collapsed');
            mainContent.classList.remove('content-expanded');
        }
    });
});