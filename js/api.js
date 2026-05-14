/**
 * API Helper - Calidad el Paisa
 * Funciones para conectar el frontend con el backend PHP
 */
const API_BASE = 'database/api/';

const API = {
    // Productos
    getProductos: () => fetch(API_BASE + 'productos.php').then(r => r.json()),
    buscarProductos: (term) => fetch(API_BASE + 'productos.php?search=' + encodeURIComponent(term)).then(r => r.json()),
    getProducto: (id) => fetch(API_BASE + 'productos.php?id=' + id).then(r => r.json()),

    // Autenticación
    login: (email, password) => fetch(API_BASE + 'auth.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=login&email=' + encodeURIComponent(email) + '&password=' + encodeURIComponent(password)
    }).then(r => r.json()),

    register: (nombre, email, password) => fetch(API_BASE + 'auth.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=register&nombre=' + encodeURIComponent(nombre) + '&email=' + encodeURIComponent(email) + '&password=' + encodeURIComponent(password)
    }).then(r => r.json()),

    recovery: (email) => fetch(API_BASE + 'auth.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=recovery&email=' + encodeURIComponent(email)
    }).then(r => r.json()),

    // Pedidos
    crearPedido: (data) => fetch(API_BASE + 'pedidos.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    }).then(r => r.json()),

    getPedidos: (userId) => fetch(API_BASE + 'pedidos.php?user_id=' + userId).then(r => r.json()),

    // Contacto
    enviarContacto: (data) => fetch(API_BASE + 'contacto.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams(data).toString()
    }).then(r => r.json()),

    // Newsletter
    suscribir: (email, nombre) => fetch(API_BASE + 'newsletter.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'email=' + encodeURIComponent(email) + '&nombre=' + encodeURIComponent(nombre || '')
    }).then(r => r.json())
};

// Manejo de sesión (híbrido: localStorage + API)
const Session = {
    get: () => {
        const u = localStorage.getItem('currentUser');
        return u ? JSON.parse(u) : null;
    },
    set: (user) => localStorage.setItem('currentUser', JSON.stringify(user)),
    clear: () => localStorage.removeItem('currentUser'),
    isLoggedIn: () => !!localStorage.getItem('currentUser')
};

// Carrito (localStorage, compartido entre páginas)
const Cart = {
    get: () => {
        const c = localStorage.getItem('elPaisaCart');
        return c ? JSON.parse(c) : [];
    },
    set: (cart) => localStorage.setItem('elPaisaCart', JSON.stringify(cart)),
    clear: () => localStorage.removeItem('elPaisaCart'),
    count: () => Cart.get().reduce((s, i) => s + i.quantity, 0)
};
