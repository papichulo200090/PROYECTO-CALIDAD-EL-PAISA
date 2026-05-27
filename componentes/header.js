(function () {
    function loadHeader() {
        var container = document.getElementById('header-container');
        if (!container) return;

        fetch('componentes/header.html')
            .then(function (r) { return r.text(); })
            .then(function (html) {
                container.innerHTML = html;
                initHeader();
                document.dispatchEvent(new Event('headerLoaded'));
            })
            .catch(function () {
                container.innerHTML = '<!-- header fallback -->';
                document.dispatchEvent(new Event('headerLoaded'));
            });
    }

    function initHeader() {
        setActiveNav();
        initAuth();
        updateCartCount();

        var cartBtn = document.getElementById('cartNavBtn');
        var cartSidebar = document.getElementById('cartSidebar');
        if (cartBtn && cartSidebar) {
            cartBtn.addEventListener('click', function (e) {
                e.preventDefault();
                cartSidebar.classList.add('open');
            });
        }
    }

    function setActiveNav() {
        var page = location.pathname.split('/').pop().replace('.html', '') || 'index';
        document.querySelectorAll('#header-container .nav-item.nav-link').forEach(function (link) {
            var href = link.getAttribute('href');
            if (href && href.indexOf(page) !== -1 && href !== '#') {
                link.classList.add('active');
            }
        });
    }

    function initAuth() {
        loadUser();

        var loginLink = document.getElementById('loginNavLink');
        if (loginLink) {
            loginLink.addEventListener('click', function (e) {
                e.preventDefault();
                window.location.href = 'brawl.html';
            });
        }

        var welcomeSpan = document.querySelector('.user-welcome');
        if (welcomeSpan) {
            welcomeSpan.addEventListener('click', function () {
                if (!Session.isLoggedIn()) {
                    window.location.href = 'brawl.html';
                }
            });
        }

        var logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                Session.clear();
                window.location.href = 'index.html';
            });
        }
    }

    window.loadUser = function () {
        var user = Session.get();
        var userSpan = document.querySelector('#userWelcomeSpan span');
        var loginLink = document.getElementById('loginNavLink');
        var logoutBtn = document.getElementById('logoutBtn');
        if (!userSpan || !loginLink || !logoutBtn) return;
        if (user) {
            userSpan.innerText = 'Hola, ' + user.nombre.split(' ')[0];
            loginLink.style.display = 'none';
            logoutBtn.style.display = 'inline-block';
        } else {
            userSpan.innerText = 'Invitado';
            loginLink.style.display = '';
            logoutBtn.style.display = 'none';
        }
    };

    window.updateCartCount = function () {
        var el = document.getElementById('cartCountNav');
        if (el) el.textContent = Cart.count();
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', loadHeader);
    } else {
        loadHeader();
    }
})();