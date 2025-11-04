self.addEventListener('install', (event) => {
    self.skipWaiting();
});

self.addEventListener('activate', (event) => {
    event.waitUntil(self.clients.claim());
});

self.addEventListener('push', (event) => {
    const data = event.data ? event.data.json() : {};
    const title = data.title || 'Levar';
    const options = {
        body: data.body || 'Você tem uma nova atualização.',
        icon: data.icon || '/icons/icon-192.png',
        badge: data.badge || '/icons/icon-192.png',
        data: data.url ? { url: data.url } : {},
    };

    event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', (event) => {
    event.notification.close();
    const url = event.notification.data?.url || '/';
    event.waitUntil(
        self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientsArr) => {
            const hadWindow = clientsArr.some((client) => {
                if (client.url === url) {
                    client.focus();
                    return true;
                }
                return false;
            });

            if (!hadWindow && self.clients.openWindow) {
                return self.clients.openWindow(url);
            }
        }),
    );
});
