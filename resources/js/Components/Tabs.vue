<template>
    <div class="space-y-2">
        <p v-if="label" class="px-1 text-[11px] font-semibold uppercase tracking-wide text-slate-500">
            {{ label }}
        </p>
        <div class="sticky top-2 z-10">
            <div
                class="flex flex-col gap-2 rounded-3xl bg-white/80 p-2 shadow-sm ring-1 ring-black/5 backdrop-blur-sm sm:flex-row sm:gap-2"
                role="tablist"
                :aria-label="label || 'Abas'"
                aria-orientation="horizontal"
            >
                <button
                    v-for="tab in items"
                    :key="tab.key"
                    type="button"
                    role="tab"
                    :aria-selected="current === tab.key"
                    :aria-controls="`tab-panel-${tab.key}`"
                    :tabindex="current === tab.key ? 0 : -1"
                    class="flex-1 rounded-2xl px-3 py-2 text-left text-sm font-semibold transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-400"
                    :class="tabClass(tab.key)"
                    @click="select(tab.key)"
                    @keydown.enter.prevent="select(tab.key)"
                    @keydown.space.prevent="select(tab.key)"
                >
                    <span class="flex items-center justify-between gap-3">
                        <span class="flex items-center gap-3">
                            <span
                                v-if="tab.icon"
                                class="grid h-8 w-8 place-items-center rounded-full border text-sm font-semibold transition"
                                :class="iconClass(tab.key)"
                            >
                                {{ tab.icon }}
                            </span>
                            <span class="flex flex-col text-left">
                                <span>{{ tab.label }}</span>
                                <span v-if="tab.description" class="text-[11px] font-medium text-slate-500">
                                    {{ tab.description }}
                                </span>
                            </span>
                        </span>
                        <span
                            v-if="tab.badge !== undefined"
                            class="inline-flex min-h-[1.5rem] min-w-[1.5rem] items-center justify-center rounded-full px-2 text-xs font-semibold transition"
                            :class="badgeClass(tab.key)"
                        >
                            {{ tab.badge }}
                        </span>
                    </span>
                </button>
            </div>
        </div>

        <div :id="`tab-panel-${current}`" role="tabpanel">
            <slot />
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
    modelValue: {
        type: String,
        default: '',
    },
    items: {
        type: Array,
        default: () => [],
    },
    label: {
        type: String,
        default: 'Selecione uma lista',
    },
});

const emit = defineEmits(['update:modelValue']);

const current = computed(() => {
    if (props.modelValue) return props.modelValue;
    return props.items?.[0]?.key ?? '';
});

const accentStyles = {
    emerald: {
        iconActive: 'border-emerald-200 bg-emerald-50 text-emerald-700',
        iconInactive: 'border-emerald-100 bg-emerald-50 text-emerald-500',
        badgeActive: 'bg-emerald-500/15 text-emerald-600',
        badgeInactive: 'bg-emerald-50 text-emerald-600',
        buttonRing: 'ring-emerald-50 border-emerald-100',
    },
    amber: {
        iconActive: 'border-amber-200 bg-amber-50 text-amber-700',
        iconInactive: 'border-amber-100 bg-amber-50 text-amber-600',
        badgeActive: 'bg-amber-500/15 text-amber-600',
        badgeInactive: 'bg-amber-50 text-amber-600',
        buttonRing: 'ring-amber-50 border-amber-100',
    },
    rose: {
        iconActive: 'border-rose-200 bg-rose-50 text-rose-700',
        iconInactive: 'border-rose-100 bg-rose-50 text-rose-500',
        badgeActive: 'bg-rose-500/15 text-rose-600',
        badgeInactive: 'bg-rose-50 text-rose-600',
        buttonRing: 'ring-rose-50 border-rose-100',
    },
    default: {
        iconActive: 'border-slate-200 bg-slate-50 text-slate-700',
        iconInactive: 'border-slate-200 bg-slate-50 text-slate-500',
        badgeActive: 'bg-slate-900/10 text-slate-700',
        badgeInactive: 'bg-slate-100 text-slate-600',
        buttonRing: 'ring-slate-100 border-slate-200',
    },
};

const getAccent = (key) => {
    const accent = props.items?.find((tab) => tab.key === key)?.accent ?? 'default';
    return accentStyles[accent] ?? accentStyles.default;
};

const tabClass = (key) => {
    const active = current.value === key;
    if (active) {
        const accent = getAccent(key);
        return `border ${accent.buttonRing} bg-white text-slate-900 shadow-sm`;
    }
    return 'border border-transparent text-slate-600 hover:border-slate-200 hover:bg-white/70';
};

const iconClass = (key) => {
    const accent = getAccent(key);
    return current.value === key ? accent.iconActive : accent.iconInactive;
};

const badgeClass = (key) => {
    const accent = getAccent(key);
    return current.value === key ? accent.badgeActive : accent.badgeInactive;
};

const select = (key) => {
    if (!key || key === current.value) return;
    emit('update:modelValue', key);
};
</script>
