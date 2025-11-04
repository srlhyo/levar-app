import axios from 'axios';

window.axios = axios;

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
window.axios.defaults.headers.common['Accept'] = 'application/json';
window.axios.defaults.withCredentials = true;

const token = document.head?.querySelector('meta[name="csrf-token"]');

if (token) {
    window.axios.defaults.headers.common['X-CSRF-TOKEN'] = token.getAttribute('content');
}

if (typeof window !== 'undefined') {
    window.axios.get('/sanctum/csrf-cookie').catch(() => {
        // Ignore — subsequent requests will surface actual issues if this fails.
    });
}
