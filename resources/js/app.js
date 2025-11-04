import './bootstrap';
import '../css/app.css';

import { createApp, h } from 'vue';
import { createPinia } from 'pinia';
import { createInertiaApp } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { InertiaProgress } from '@inertiajs/progress';
import axios from 'axios';

InertiaProgress.init({
    color: '#38bdf8',
    showSpinner: false,
});

createInertiaApp({
    resolve: (name) =>
        resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({ el, App, props, plugin }) {
        const app = createApp({ render: () => h(App, props) });
        const pinia = createPinia();

        app.use(plugin);
        app.use(pinia);
        app.mount(el);

        initializePwa(props.initialPage.props);
        document.addEventListener('inertia:finish', () => {
            initializePwa(window.Inertia?.page?.props ?? {});
        });
    },
});

const initializePwa = (() => {
    let registrationPromise = null;

    const urlBase64ToUint8Array = (base64String) => {
        const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
        const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');

        const rawData = window.atob(base64);
        const outputArray = new Uint8Array(rawData.length);

        for (let i = 0; i < rawData.length; ++i) {
            outputArray[i] = rawData.charCodeAt(i);
        }
        return outputArray;
    };

    const ensureServiceWorker = async () => {
        if (!('serviceWorker' in navigator)) return null;

        if (!registrationPromise) {
            registrationPromise = navigator.serviceWorker.register('/service-worker.js').catch((error) => {
                console.error('Service worker registration failed', error);
                registrationPromise = null;
                return null;
            });
        }

        return registrationPromise;
    };

    const subscribeToPush = async (props) => {
        const vapidKey = props?.pwa?.vapidPublicKey;
        const isAuthenticated = Boolean(props?.auth?.user);

        if (!isAuthenticated || !vapidKey) return;

        if (!('Notification' in window) || Notification.permission === 'denied') {
            return;
        }

        const registration = await ensureServiceWorker();
        if (!registration) return;

        let subscription = await registration.pushManager.getSubscription();

        if (!subscription) {
            const permission = await Notification.requestPermission();
            if (permission !== 'granted') {
                return;
            }

            const applicationServerKey = urlBase64ToUint8Array(vapidKey);
            subscription = await registration.pushManager.subscribe({
                userVisibleOnly: true,
                applicationServerKey,
            });
        }

        try {
            const cacheKey = `push-synced:${subscription.endpoint}`;
            if (typeof window !== 'undefined' && window.localStorage?.getItem(cacheKey)) {
                return;
            }

            const payload = subscription.toJSON();
            payload.content_encoding = 'aes128gcm';
            await axios.post('/api/push-subscriptions', payload);

            if (typeof window !== 'undefined' && window.localStorage) {
                window.localStorage.setItem(cacheKey, '1');
            }
        } catch (error) {
            console.error('Failed to store push subscription', error);
        }
    };

    return async (props) => {
        try {
            await ensureServiceWorker();
            await subscribeToPush(props);
        } catch (error) {
            console.error('PWA initialization failed', error);
        }
    };
})();
