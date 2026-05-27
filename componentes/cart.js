(function () {
    window.cart = [];

    window.formatCOP = function (price) {
        return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0 }).format(price);
    };

    window.saveCart = function () {
        localStorage.setItem('elPaisaCart', JSON.stringify(window.cart));
        updateCartUI();
    };

    window.loadCart = function () {
        var saved = localStorage.getItem('elPaisaCart');
        if (saved) window.cart = JSON.parse(saved);
        updateCartUI();
    };

    window.addToCart = function (product) {
        var existing = window.cart.find(function (item) { return item.id === product.id; });
        if (existing) existing.quantity += 1;
        else window.cart.push(Object.assign({}, product, { quantity: 1 }));
        saveCart();
        showToast(product.name + ' a\u00f1adido al carrito');
    };

    window.updateCartUI = function () {
        if (typeof window.updateCartCount === 'function') {
            window.updateCartCount();
        }

        var container = document.getElementById('cartItemsList');
        if (!container) return;

        var total = 0;
        if (window.cart.length === 0) {
            container.innerHTML = '<div class="text-center p-4">\uD83D\uDED2 Carrito vac\u00edo</div>';
            var totalEl = document.getElementById('cartTotalAmount');
            if (totalEl) totalEl.innerText = formatCOP(0);
            return;
        }

        var html = '';
        window.cart.forEach(function (item) {
            var itemTotal = item.price * item.quantity;
            total += itemTotal;
            html += '<div class="cart-item" data-id="' + item.id + '">' +
                '<div class="cart-item-img" style="background-image: url(\'' + item.image + '\'); background-size:cover;"></div>' +
                '<div class="cart-item-details">' +
                '<div class="cart-item-title">' + item.name + '</div>' +
                '<div class="cart-item-price">' + formatCOP(item.price) + '</div>' +
                '<div class="cart-qty">' +
                '<button class="decr-qty" data-id="' + item.id + '">-</button>' +
                '<span>' + item.quantity + '</span>' +
                '<button class="incr-qty" data-id="' + item.id + '">+</button>' +
                '<button class="remove-item" data-id="' + item.id + '" style="margin-left:auto; background:none; border:none; color:#dc3545;"><i class="fas fa-trash-alt"></i></button>' +
                '</div></div></div>';
        });
        container.innerHTML = html;
        var totalEl = document.getElementById('cartTotalAmount');
        if (totalEl) totalEl.innerHTML = formatCOP(total);

        container.querySelectorAll('.decr-qty').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var id = parseInt(btn.dataset.id);
                var idx = window.cart.findIndex(function (i) { return i.id === id; });
                if (window.cart[idx].quantity > 1) window.cart[idx].quantity--;
                else window.cart.splice(idx, 1);
                saveCart();
            });
        });
        container.querySelectorAll('.incr-qty').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var id = parseInt(btn.dataset.id);
                var item = window.cart.find(function (i) { return i.id === id; });
                if (item) item.quantity++;
                saveCart();
            });
        });
        container.querySelectorAll('.remove-item').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var id = parseInt(btn.dataset.id);
                window.cart = window.cart.filter(function (i) { return i.id !== id; });
                saveCart();
            });
        });
    };

    window.showToast = function (msg) {
        var toast = document.getElementById('toastMsg');
        if (!toast) return;
        toast.innerText = msg;
        toast.classList.add('show');
        setTimeout(function () { toast.classList.remove('show'); }, 2000);
    };

    function loadCartHTML() {
        var container = document.getElementById('cart-container');
        if (!container) return;

        fetch('componentes/cart.html')
            .then(function (r) { return r.text(); })
            .then(function (html) {
                container.innerHTML = html;
                initCartEvents();
                document.dispatchEvent(new Event('cartLoaded'));
            })
            .catch(function () {
                container.innerHTML = '<!-- cart fallback -->';
                document.dispatchEvent(new Event('cartLoaded'));
            });
    }

    function initCartEvents() {
        loadCart();

        var closeBtn = document.getElementById('closeCartBtn');
        if (closeBtn) {
            closeBtn.addEventListener('click', function () {
                var sidebar = document.getElementById('cartSidebar');
                if (sidebar) sidebar.classList.remove('open');
            });
        }

        var checkoutBtn = document.getElementById('checkoutBtn');
        if (checkoutBtn) {
            checkoutBtn.addEventListener('click', function () {
                if (window.cart.length === 0) {
                    showToast('El carrito est\u00e1 vac\u00edo');
                    return;
                }
                window.location.href = 'pago.html';
            });
        }
    }

    document.addEventListener('headerLoaded', function () {
        loadCartHTML();
    });
})();