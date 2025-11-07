import axios from 'axios';
import { router } from '@inertiajs/vue3';

window.axios = axios;

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
window.axios.defaults.headers.common['Accept'] = 'application/json';
window.axios.defaults.withCredentials = true;
window.axios.defaults.xsrfCookieName = 'XSRF-TOKEN';
window.axios.defaults.xsrfHeaderName = 'X-XSRF-TOKEN';

const tokenElement = typeof document !== 'undefined' ? document.head?.querySelector('meta[name="csrf-token"]') : null;

const readXsrfCookie = () => {
    if (typeof document === 'undefined') return '';
    const match = document.cookie.match(/(?:^|;\s*)XSRF-TOKEN=([^;]+)/);
    return match ? decodeURIComponent(match[1]) : '';
};

const resolvePageToken = () => router?.page?.props?.csrf_token ?? window?.Inertia?.page?.props?.csrf_token ?? '';

const resolvePlainCsrfToken = () => (
    resolvePageToken() ||
    tokenElement?.getAttribute('content') ||
    ''
);

window.__resolveCsrfToken = resolvePlainCsrfToken;

const syncAxiosCsrfHeader = () => {
    const plain = resolvePlainCsrfToken();
    const xsrfCookie = readXsrfCookie();

    if (plain) {
        window.axios.defaults.headers.common['X-CSRF-TOKEN'] = plain;
        if (tokenElement) {
            tokenElement.setAttribute('content', plain);
        }
    }

    if (xsrfCookie) {
        window.axios.defaults.headers.common['X-XSRF-TOKEN'] = xsrfCookie;
    }
};

syncAxiosCsrfHeader();

window.axios.interceptors.request.use((config) => {
    const plain = resolvePlainCsrfToken();
    const xsrfCookie = readXsrfCookie();

    if (plain) {
        config.headers['X-CSRF-TOKEN'] = plain;
    }

    if (xsrfCookie) {
        config.headers['X-XSRF-TOKEN'] = xsrfCookie;
    }

    return config;
});

if (typeof document !== 'undefined') {
    document.addEventListener('inertia:success', syncAxiosCsrfHeader);
}
