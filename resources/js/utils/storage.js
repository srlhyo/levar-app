const STORAGE_KEY = 'moving-items';

const isBrowser = () => typeof window !== 'undefined' && typeof window.localStorage !== 'undefined';

const safeParse = (value) => {
    try {
        return JSON.parse(value);
    } catch (error) {
        console.warn('Failed to parse storage payload', error);
        return [];
    }
};

export const storage = {
    getItems() {
        if (!isBrowser()) return [];
        const raw = window.localStorage.getItem(STORAGE_KEY);
        return raw ? safeParse(raw) : [];
    },
    setItems(items) {
        if (!isBrowser()) return;
        window.localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
    },
    addItem(item) {
        const items = storage.getItems();
        items.push(item);
        storage.setItems(items);
    },
    updateItem(id, updates) {
        const items = storage.getItems();
        const index = items.findIndex((item) => item.id === id);
        if (index === -1) return;
        items[index] = { ...items[index], ...updates };
        storage.setItems(items);
    },
    deleteItem(id) {
        const next = storage.getItems().filter((item) => item.id !== id);
        storage.setItems(next);
    },
};
