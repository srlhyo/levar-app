<template>
    <transition name="fade">
        <div v-if="show" class="flex flex-wrap items-center gap-3 text-xs text-slate-600 sm:text-sm">
            <select
                v-model="internalBagFilter"
                class="rounded-full border border-slate-200 bg-white/90 px-3 py-1.5 text-xs font-medium text-slate-600 shadow-inner shadow-slate-100 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:text-sm"
            >
                <option value="all">Todas as malas</option>
                <option v-for="bag in bagOptions" :key="bag.value" :value="bag.value">
                    {{ bag.label }}
                </option>
                <option value="unassigned">Sem mala</option>
            </select>
            <div class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/90 px-2 py-1 text-xs text-slate-600 shadow-inner shadow-slate-100">
                <span>Itens por página</span>
                <select
                    v-model.number="internalPageSize"
                    class="rounded border border-slate-200 bg-white px-2 py-1 text-xs focus:border-emerald-400 focus:outline-none focus:ring-1 focus:ring-emerald-300"
                >
                    <option v-for="option in pageOptions" :key="option" :value="option">
                        {{ option }}
                    </option>
                </select>
            </div>
            <button
                type="button"
                class="inline-flex items-center gap-1 rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-600 ring-1 ring-black/5 transition hover:bg-slate-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                @click="$emit('clear')"
            >
                Limpar filtros
            </button>
        </div>
    </transition>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
    show: {
        type: Boolean,
        default: false,
    },
    bagFilter: {
        type: String,
        default: 'all',
    },
    bagOptions: {
        type: Array,
        default: () => [],
    },
    pageSize: {
        type: Number,
        default: 25,
    },
    pageOptions: {
        type: Array,
        default: () => [10, 25, 50, 100],
    },
});

const emit = defineEmits(['update:bagFilter', 'update:pageSize', 'clear']);

const internalBagFilter = computed({
    get: () => props.bagFilter,
    set: (value) => emit('update:bagFilter', value),
});

const internalPageSize = computed({
    get: () => props.pageSize,
    set: (value) => emit('update:pageSize', value),
});
</script>
