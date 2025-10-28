import { defineStore } from 'pinia';

const STORAGE_KEY = 'decidir-state-v2';
const DEV = import.meta.env?.DEV;
const log = (...args) => {
    if (DEV) {
        console.info('[decision]', ...args);
    }
};

const randomId = () =>
    typeof globalThis !== 'undefined' && globalThis.crypto && globalThis.crypto.randomUUID
        ? globalThis.crypto.randomUUID()
        : Math.random().toString(36).slice(2, 10);

const normalizeBag = (bag) => {
    if (!bag) return null;
    if (typeof bag === 'string' && bag.toLowerCase().includes('mala')) {
        const parts = bag.trim().split(' ');
        return parts[parts.length - 1]?.trim().toUpperCase() ?? null;
    }
    if (typeof bag === 'string') {
        return bag.trim().toUpperCase();
    }
    return null;
};

const normalizeDecision = (decision) => {
    if (decision === 'yes' || decision === 'no' || decision === 'pending') return decision;
    return null;
};

const normalizeItem = (item) => ({
    id: item.id ?? randomId(),
    title: item.title ?? item.name ?? 'Item sem título',
    name: item.title ?? item.name ?? 'Item sem título',
    notes: item.notes ?? '',
    weight: typeof item.weight === 'number' ? item.weight : null,
    photo: item.photo ?? null,
    bag: normalizeBag(item.bag),
    packed: Boolean(item.packed),
    decision: normalizeDecision(item.decision),
    deleted: Boolean(item.deleted),
    deletedAt: item.deletedAt ?? null,
    requeuedAt: item.requeuedAt ?? null,
});

const buildQueue = (items, queue = []) => {
    const validIds = new Set(items.filter((item) => !item.deleted).map((item) => item.id));
    const baseQueue = Array.isArray(queue) ? queue.filter((id) => validIds.has(id)) : [];
    const missing = items
        .filter((item) => !item.deleted && item.decision === null && !baseQueue.includes(item.id))
        .map((item) => item.id);
    return [...baseQueue, ...missing];
};

const defaultItems = () => [
    normalizeItem({
        id: 'living-room-lamp',
        title: 'Abajur sala vintage',
        notes: 'Ocupa pouco espaço e ilumina bem',
        weight: 1.3,
        bag: 'A',
        packed: true,
    }),
    normalizeItem({
        id: 'coat-blue',
        title: 'Casaco azul inverno',
        notes: 'Favorito da Lauren • Cabe na mala A',
        weight: 1.9,
        bag: 'A',
    }),
    normalizeItem({
        id: 'coffee-mugs',
        title: 'Conjunto de canecas viagem',
        notes: '4 peças • Pode quebrar se despachar',
        weight: 0.8,
    }),
    normalizeItem({
        id: 'photo-album',
        title: 'Álbum de fotos família',
        notes: 'Volume 2015-2020',
        weight: 0.6,
    }),
    normalizeItem({
        id: 'kitchen-kit',
        title: 'Kit cozinha compacto',
        notes: 'Frigideira + facas essenciais',
        weight: 1.5,
        bag: 'B',
    }),
];

const loadState = () => {
    if (typeof window === 'undefined') return null;
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;
    try {
        return JSON.parse(raw);
    } catch (error) {
        console.warn('Failed to parse decidir state', error);
        return null;
    }
};

const persistState = (state) => {
    if (typeof window === 'undefined') return;
    window.localStorage.setItem(
        STORAGE_KEY,
        JSON.stringify({
            items: state.items,
            queue: state.queue,
            recycleBin: state.recycleBin,
        }),
    );
};

export const useDecisionStore = defineStore('decision', {
    state: () => ({
        items: [],
        queue: [],
        recycleBin: [],
        initialized: false,
    }),
    getters: {
        itemsMap(state) {
            return state.items.reduce((map, item) => {
                map[item.id] = item;
                return map;
            }, {});
        },
        totalCount(state) {
            return state.items.filter((item) => !item.deleted).length;
        },
        processedCount(state) {
            return state.items.filter((item) => !item.deleted && item.decision !== null).length;
        },
        pendingCount(state) {
            return state.items.filter((item) => !item.deleted && item.decision === 'pending').length;
        },
        yesCount(state) {
            return state.items.filter((item) => !item.deleted && item.decision === 'yes').length;
        },
        noCount(state) {
            return state.items.filter((item) => !item.deleted && item.decision === 'no').length;
        },
        undecidedCount(state) {
            return state.items.filter((item) => !item.deleted && item.decision === null).length;
        },
        currentId(state) {
            if (!state.queue.length) return null;
            const nextId = state.queue.find((id) => {
                const item = state.items.find((candidate) => candidate.id === id);
                return item && !item.deleted;
            });
            return nextId ?? null;
        },
        currentItem() {
            const id = this.currentId;
            return id ? this.itemsMap[id] ?? null : null;
        },
        takeList(state) {
            return state.items.filter((item) => !item.deleted && item.decision === 'yes');
        },
        pendingList(state) {
            return state.items.filter((item) => !item.deleted && item.decision === 'pending');
        },
        leaveList(state) {
            return state.items.filter((item) => !item.deleted && item.decision === 'no');
        },
        progressPercent() {
            return this.totalCount ? Math.round((this.processedCount / this.totalCount) * 100) : 0;
        },
    },
    actions: {
        hydrate(rawState = {}) {
            this.items = (rawState.items ?? []).map(normalizeItem);
            this.queue = buildQueue(this.items, rawState.queue);
            this.recycleBin = Array.isArray(rawState.recycleBin) ? [...rawState.recycleBin] : [];
            log('hydrate', { items: this.items.length, queue: this.queue.length, recycle: this.recycleBin.length });
        },
        resetState() {
            this.items = [];
            this.queue = [];
            this.recycleBin = [];
            this.initialized = false;
        },
        initialize() {
            if (this.initialized) return;
            const saved = loadState();
            if (saved?.items?.length) {
                this.hydrate(saved);
            } else if (this.items.length) {
                this.queue = buildQueue(this.items, this.queue);
                this.recycleBin = Array.isArray(this.recycleBin) ? this.recycleBin : [];
                this.persist();
            } else {
                this.items = defaultItems();
                this.queue = buildQueue(this.items);
                this.recycleBin = [];
                persistState(this.$state);
            }
            this.initialized = true;
            log('after initialize', {
                items: this.items.length,
                queue: this.queue.length,
                recycle: this.recycleBin.length,
            });
        },
        persist() {
            persistState(this.$state);
            log('persist', { items: this.items.length, queue: this.queue.length });
        },
        nextItemId() {
            if (this.queue.length) {
                while (this.queue.length) {
                    const id = this.queue.shift();
                    const item = this.itemsMap[id];
                    if (item && !item.deleted) {
                        return id;
                    }
                }
            }
            const fallback = this.items.find((item) => !item.deleted && item.decision === null);
            return fallback ? fallback.id : null;
        },
        applyDecision(decision) {
            const id = this.nextItemId();
            if (!id) {
                this.persist();
                return null;
            }
            const item = this.itemsMap[id];
            if (!item || item.deleted) {
                this.persist();
                return null;
            }

            item.decision = decision;
            item.requeuedAt = null;
            this.queue = this.queue.filter((queueId) => queueId !== id);

            this.persist();
            return item;
        },
        requeueItems(ids) {
            const unique = Array.from(new Set(ids));
            if (!unique.length) return;

            const filteredQueue = this.queue.filter((queueId) => !unique.includes(queueId));
            const leading = [];
            unique.forEach((id) => {
                const item = this.itemsMap[id];
                if (item && !item.deleted) {
                    item.requeuedAt = new Date().toISOString();
                    leading.push(id);
                }
            });

            this.queue = [...new Set([...leading, ...filteredQueue])];

            this.persist();
        },
        movePendingToLeave(ids) {
            const unique = Array.from(new Set(ids));
            if (!unique.length) return;
            unique.forEach((id) => {
                const item = this.itemsMap[id];
                if (item && !item.deleted) {
                    item.decision = 'no';
                    item.requeuedAt = null;
                }
            });
            this.queue = this.queue.filter((queueId) => !unique.includes(queueId));
            this.persist();
        },
        async loadMockData() {
            if (!import.meta.env?.DEV) return;
            const saved = loadState();
            if (saved?.items?.length) return;
            const { mockItems } = await import('../mocks/itemsMock.js');
            this.items = mockItems.map(normalizeItem);
            this.queue = buildQueue(this.items);
            this.recycleBin = [];
            this.persist();
            log('after seed', { items: this.items.length, queue: this.queue.length });
        },
        softDeleteItems(ids) {
            const unique = Array.from(new Set(ids));
            if (!unique.length) return;
            const now = new Date().toISOString();
            unique.forEach((id) => {
                const item = this.itemsMap[id];
                if (item && !item.deleted) {
                    item.deleted = true;
                    item.deletedAt = now;
                    item.requeuedAt = null;
                    this.queue = this.queue.filter((queueId) => queueId !== id);
                    if (!this.recycleBin.find((entry) => entry.id === id)) {
                        this.recycleBin.unshift({ id, deletedAt: now });
                    }
                }
            });
            this.persist();
        },
        restoreItems(ids) {
            const unique = Array.from(new Set(ids));
            if (!unique.length) return;
            unique.forEach((id) => {
                const item = this.itemsMap[id];
                if (item) {
                    item.deleted = false;
                    item.deletedAt = null;
                }
            });
            this.recycleBin = this.recycleBin.filter((entry) => !unique.includes(entry.id));
            this.persist();
        },
        async forceSeed() {
            if (!DEV) return;
            if (typeof window !== 'undefined') {
                window.localStorage.removeItem(STORAGE_KEY);
            }
            this.resetState();
            await this.loadMockData();
            this.initialize();
            log('forceSeed complete', { items: this.items.length, queue: this.queue.length });
        },
        resetAll() {
            if (!DEV) return;
            if (typeof window !== 'undefined') {
                window.localStorage.removeItem(STORAGE_KEY);
            }
            this.resetState();
            log('resetAll complete');
        },
    },
});
