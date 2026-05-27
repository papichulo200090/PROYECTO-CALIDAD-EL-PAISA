(function () {
    function loadInfoContacto() {
        var container = document.getElementById('info-contacto-container');
        if (!container) return;

        fetch('componentes/info-contacto.html')
            .then(function (r) { return r.text(); })
            .then(function (html) { container.innerHTML = html; })
            .catch(function () { container.innerHTML = '<!-- info contacto fallback -->'; });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', loadInfoContacto);
    } else {
        loadInfoContacto();
    }
})();