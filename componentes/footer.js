(function () {
    function loadFooter() {
        var container = document.getElementById('footer-container');
        if (!container) return;

        fetch('componentes/footer.html')
            .then(function (r) { return r.text(); })
            .then(function (html) {
                container.innerHTML = html;
            })
            .catch(function () {
                container.innerHTML = '<!-- footer fallback -->';
            });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', loadFooter);
    } else {
        loadFooter();
    }
})();