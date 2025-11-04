import axios from 'axios';
import { defineStore } from 'pinia';

const defaultLists = () => ({
    take: [],
    pending: [],
    leave: [],
    undecided: [],
});

const defaultCounts = () => ({
    queued: 0,
    uploading: 0,
    done: 0,
    error: 0,
});

const parseNumericInput = (value) => {
    if (value === null || value === undefined) {
        return null;
    }

    if (typeof value === 'number') {
        return Number.isFinite(value) ? value : null;
    }

    if (typeof value !== 'string') {
        return null;
    }

    const trimmed = value.trim();

    if (!trimmed) {
        return null;
    }

    let normalized = trimmed.replace(/\s+/g, '');

    if (normalized.includes(',') && normalized.includes('.')) {
        normalized = normalized.replace(/\./g, '').replace(/,/g, '.');
    } else if (normalized.includes(',')) {
        normalized = normalized.replace(/,/g, '.');
    }

    const parsed = Number(normalized);

    return Number.isFinite(parsed) ? parsed : null;
};

export const useDecisionStore = defineStore('decision', {
    state: () => ({
        moveId: null,
        reservedKg: 0,
        reservedVolumeCm3: 0,
        deck: [],
        progress: {
            total: 0,
            processed: 0,
            pending: 0,
            undecided: 0,
            pending_deck: 0,
            pending_total: 0,
        },
        bags: [],
        resumo: {
            stats: null,
            bags: [],
            lists: defaultLists(),
            exportAllowed: false,
        },
        catalog: {
            items: [],
        },
        pack: {
            items: [],
            bags: [],
            totals: {
                total_capacity: 0,
                reserved_kg: 0,
            },
        },
        recycle: [],
        uploads: {
            queue: [],
            counts: defaultCounts(),
        },
        loading: {
            deck: false,
            resumo: false,
            pack: false,
            recycle: false,
            uploads: false,
        },
        error: null,
    }),
    getters: {
        hasMove(state) {
            return Boolean(state.moveId);
        },
        totalCount(state) {
            if (state.progress.total) return state.progress.total;
            return state.resumo.stats?.total ?? 0;
        },
        processedCount(state) {
            if (state.progress.processed) return state.progress.processed;
            const decided = state.resumo.stats?.decided ?? 0;
            const pending = state.resumo.stats?.pending ?? state.resumo.stats?.pending_total ?? 0;
            return decided + pending;
        },
        pendingCount(state) {
            if (typeof state.progress.pending === 'number') {
                return state.progress.pending;
            }

            return state.resumo.stats?.pending ?? 0;
        },
        pendingDeckCount(state) {
            if (typeof state.progress.pending_deck === 'number') {
                return state.progress.pending_deck;
            }
            return state.deck.length;
        },
        pendingTotal(state) {
            if (typeof state.progress.pending_total === 'number') {
                return state.progress.pending_total;
            }
            return state.resumo.stats?.pending_total ?? state.resumo.stats?.pending ?? 0;
        },
        progressPercent() {
            return this.totalCount ? Math.round((this.processedCount / this.totalCount) * 100) : 0;
        },
        currentItem(state) {
            return state.deck.length ? state.deck[0] : null;
        },
        takeList(state) {
            return state.resumo.lists.take ?? [];
        },
        pendingList(state) {
            return state.resumo.lists.pending ?? [];
        },
        undecidedList(state) {
            return state.resumo.lists.undecided ?? [];
        },
        leaveList(state) {
            return state.resumo.lists.leave ?? [];
        },
        yesCount() {
            return this.takeList.length;
        },
        noCount() {
            return this.leaveList.length;
        },
        undecidedCount() {
            if (typeof this.progress.undecided === 'number') {
                return this.progress.undecided;
            }

            if (Array.isArray(this.resumo.lists.undecided)) {
                return this.resumo.lists.undecided.length;
            }

            if (typeof this.resumo.stats?.undecided === 'number') {
                return this.resumo.stats.undecided;
            }

            return Math.max(this.totalCount - (this.yesCount + this.noCount + this.pendingCount + (this.resumo.stats?.pending ?? 0)), 0);
        },
        itemsMap(state) {
            const map = {};
            const addItems = (items) => {
                items.forEach((item) => {
                    map[item.id] = item;
                });
            };

            addItems(state.deck);
            addItems(state.resumo.lists.take ?? []);
            addItems(state.resumo.lists.pending ?? []);
            addItems(state.resumo.lists.leave ?? []);
            addItems(state.resumo.lists.undecided ?? []);
            addItems(state.pack.items ?? []);

            return map;
        },
        allPackableIds(state) {
            return state.pack.items.filter((item) => item.decision === 'yes').map((item) => item.id);
        },
        allPacked(state) {
            if (!state.pack.items.length) {
                return false;
            }

            return state.pack.items.every((item) => item.packed);
        },
    },
    actions: {
        setMove(move) {
            if (!move) {
                this.moveId = null;
                this.reservedKg = 0;
                this.reservedVolumeCm3 = 0;
                return;
            }

            const id = typeof move === 'object' ? move.id : move;
            this.moveId = id ? String(id) : null;

            if (move && typeof move === 'object' && typeof move.reserved_kg === 'number') {
                this.reservedKg = move.reserved_kg;
            }
            if (move && typeof move === 'object' && typeof move.reserved_volume_cm3 === 'number') {
                this.reservedVolumeCm3 = move.reserved_volume_cm3;
            }
        },
        assertMove() {
            if (!this.moveId) {
                throw new Error('Move not initialized in decision store.');
            }
        },
        clearError() {
            this.error = null;
        },
        async fetchDeck() {
            this.assertMove();
            this.loading.deck = true;
            this.clearError();

            try {
                const { data } = await axios.get(`/api/moves/${this.moveId}/decidir`);
                this.deck = Array.isArray(data.deck) ? data.deck : [];

                const totalItems = data.progress?.total ?? this.resumo.stats?.total ?? this.totalCount;
                const undecided = data.progress?.undecided ?? this.deck.length;
                const deckCount = data.progress?.pending_deck ?? this.deck.length;
                const pendingBacklog = data.progress?.pending_backlog ?? data.progress?.pending ?? 0;
                const pendingTotal = data.progress?.pending_total ?? pendingBacklog;
                const processed = data.progress?.processed ?? Math.max(totalItems - undecided, 0);

                this.progress = {
                    total: totalItems,
                    processed,
                    pending: pendingBacklog,
                    pending_deck: deckCount,
                    undecided,
                    pending_total: pendingTotal,
                };

                if (data.move?.bags) {
                    this.bags = data.move.bags;
                }
            } catch (error) {
                this.error = error;
                throw error;
            } finally {
                this.loading.deck = false;
            }
        },
        async applyDecision(decision, options = {}) {
            this.assertMove();
            const current = this.currentItem;
            if (!current) return null;

            const payload = { decision };
            if (options.bag) {
                payload.bag = options.bag;
            }

            await axios.post(`/api/items/${current.id}/decidir`, payload);
            await Promise.allSettled([
                this.fetchDeck(),
                this.fetchResumo(),
                this.fetchPack(),
            ]);

            return current;
        },
        async decideItems(ids, decision, options = {}) {
            this.assertMove();
            if (!ids?.length) return;

            const payload = { decision };

            if (options.clearBag) {
                payload.bag = '';
            } else if (options.bag) {
                payload.bag = options.bag;
            }

            await Promise.all(ids.map((id) => axios.post(`/api/items/${id}/decidir`, payload)));
            await Promise.allSettled([
                this.fetchDeck(),
                this.fetchResumo(),
                this.fetchPack(),
            ]);
        },
        async requeueItems(ids) {
            this.assertMove();
            if (!ids?.length) return;

            await axios.post('/api/items/requeue', { ids });
            await Promise.allSettled([
                this.fetchDeck(),
                this.fetchResumo(),
                this.fetchPack(),
            ]);
        },
        async movePendingToLeave(ids) {
            this.assertMove();
            if (!ids?.length) return;

            await axios.post(`/api/moves/${this.moveId}/resumo/pending-to-leave`, { ids });
            await Promise.allSettled([this.fetchResumo(), this.fetchDeck()]);
        },
        async fetchResumo() {
            this.assertMove();
            this.loading.resumo = true;
            this.clearError();

            try {
                const { data } = await axios.get(`/api/moves/${this.moveId}/resumo`);
                this.resumo.stats = data.stats ?? null;
                this.resumo.bags = Array.isArray(data.bags) ? data.bags : [];
                this.resumo.lists = data.lists ?? defaultLists();
                this.resumo.exportAllowed = Boolean(data.export_allowed);
                if (typeof data.stats?.reservedKg === 'number') {
                    this.reservedKg = data.stats.reservedKg;
                }
                const reservedVolume =
                    typeof data.stats?.volumes?.reserved_cm3 === 'number'
                        ? data.stats.volumes.reserved_cm3
                        : typeof data.stats?.dimensions?.reserved_cm3 === 'number'
                            ? data.stats.dimensions.reserved_cm3
                            : null;
                if (reservedVolume !== null) {
                    this.reservedVolumeCm3 = reservedVolume;
                }
            } catch (error) {
                this.error = error;
                throw error;
            } finally {
                this.loading.resumo = false;
            }
        },
        async fetchPack() {
            this.assertMove();
            this.loading.pack = true;
            this.clearError();

            try {
                const { data } = await axios.get(`/api/moves/${this.moveId}/pack`);
                this.pack.items = Array.isArray(data.items) ? data.items : [];
                this.pack.bags = Array.isArray(data.bags) ? data.bags : [];
                this.pack.totals = data.totals ?? {
                    total_capacity: 0,
                    reserved_kg: this.reservedKg,
                    reserved_volume_cm3: this.reservedVolumeCm3,
                };
                if (typeof data.totals?.reserved_volume_cm3 === 'number') {
                    this.reservedVolumeCm3 = data.totals.reserved_volume_cm3;
                }
            } catch (error) {
                this.error = error;
                throw error;
            } finally {
                this.loading.pack = false;
            }
        },
        async markPacked(ids, packed) {
            this.assertMove();
            if (!ids?.length) return;

            await axios.post('/api/items/pack', { ids, packed });
            await Promise.allSettled([this.fetchPack(), this.fetchResumo()]);
        },
        async assignBag(itemId, bagCode) {
            this.assertMove();
            await axios.post(`/api/items/${itemId}/bag`, { bag: bagCode });
            await Promise.allSettled([this.fetchPack(), this.fetchResumo()]);
        },
        async softDeleteItems(ids) {
            this.assertMove();
            if (!ids?.length) return;

            await axios.post('/api/items/recycle', { ids });
            await Promise.allSettled([this.fetchResumo(), this.fetchDeck(), this.fetchPack(), this.fetchRecycle()]);
        },
        async restoreItems(ids) {
            this.assertMove();
            if (!ids?.length) return;

            await axios.post('/api/items/restore', { ids });
            await Promise.allSettled([this.fetchResumo(), this.fetchDeck(), this.fetchPack(), this.fetchRecycle()]);
        },
        async destroyItem(id) {
            this.assertMove();
            await axios.delete(`/api/items/${id}`);
            await Promise.allSettled([this.fetchResumo(), this.fetchRecycle(), this.fetchDeck(), this.fetchPack()]);
        },
        async fetchRecycle() {
            this.assertMove();
            this.loading.recycle = true;
            this.clearError();

            try {
                const { data } = await axios.get(`/api/moves/${this.moveId}/recycle`);
                this.recycle = Array.isArray(data.items) ? data.items : [];
            } catch (error) {
                this.error = error;
                throw error;
            } finally {
                this.loading.recycle = false;
            }
        },
        async fetchUploads() {
            this.assertMove();
            this.loading.uploads = true;
            this.clearError();

            try {
                const { data } = await axios.get(`/api/moves/${this.moveId}/uploads/inbox`);
                this.uploads.queue = Array.isArray(data.queue) ? data.queue : [];
                this.uploads.counts = data.counts ?? defaultCounts();
            } catch (error) {
                this.error = error;
                throw error;
            } finally {
                this.loading.uploads = false;
            }
        },
        async fetchCatalog() {
            this.assertMove();
            this.loading.catalog = true;
            this.clearError();

            try {
                const { data } = await axios.get(`/api/moves/${this.moveId}/items`);
                this.catalog.items = Array.isArray(data.items) ? data.items : [];
            } catch (error) {
                this.error = error;
                throw error;
            } finally {
                this.loading.catalog = false;
            }
        },
        async createItem(formData) {
            this.assertMove();

            const weightKg = parseNumericInput(formData.weight_kg ?? formData.weight ?? null);
            const volumeCm3 = parseNumericInput(formData.volume_cm3 ?? formData.volume ?? null);

            const payload = {
                title: formData.title?.trim() ?? '',
                notes: formData.notes ?? null,
                weight_kg: weightKg,
                volume_cm3: volumeCm3,
                category: formData.category ?? null,
                fragile: Boolean(formData.fragile),
                decision: 'undecided',
            };

            const { data } = await axios.post(`/api/moves/${this.moveId}/items`, payload);

            await Promise.allSettled([
                this.fetchCatalog(),
                this.fetchDeck(),
                this.fetchResumo(),
                this.fetchPack(),
            ]);

            return data.item;
        },
        async uploadMedia(itemId, file) {
            this.assertMove();
            const form = new FormData();
            form.append('file', file);

            await axios.post(`/api/items/${itemId}/media`, form, {
                headers: { 'Content-Type': 'multipart/form-data' },
            });
            await Promise.allSettled([
                this.fetchCatalog(),
                this.fetchResumo(),
                this.fetchPack(),
                this.fetchUploads(),
            ]);
        },
    },
});
