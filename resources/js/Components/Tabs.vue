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
                                class="tab-icon-base"
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
        iconActive: 'tabs-icon tabs-icon--emerald-active',
        iconInactive: 'tabs-icon tabs-icon--emerald',
        badgeActive: 'tabs-badge tabs-badge--emerald-active',
        badgeInactive: 'tabs-badge tabs-badge--emerald',
        buttonRing: 'ring-emerald-50 border-emerald-100',
    },
    amber: {
        iconActive: 'tabs-icon tabs-icon--amber-active',
        iconInactive: 'tabs-icon tabs-icon--amber',
        badgeActive: 'tabs-badge tabs-badge--amber-active',
        badgeInactive: 'tabs-badge tabs-badge--amber',
        buttonRing: 'ring-amber-50 border-amber-100',
    },
    rose: {
        iconActive: 'tabs-icon tabs-icon--rose-active',
        iconInactive: 'tabs-icon tabs-icon--rose',
        badgeActive: 'tabs-badge tabs-badge--rose-active',
        badgeInactive: 'tabs-badge tabs-badge--rose',
        buttonRing: 'ring-rose-50 border-rose-100',
    },
    default: {
        iconActive: 'tabs-icon tabs-icon--slate-active',
        iconInactive: 'tabs-icon tabs-icon--slate',
        badgeActive: 'tabs-badge tabs-badge--slate-active',
        badgeInactive: 'tabs-badge tabs-badge--slate',
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

<style scoped>
.tabs-badge {
    min-width: 2rem;
    min-height: 1.8rem;
    border-radius: 999px;
    padding: 0 0.75rem;
    font-size: 0.75rem;
    font-weight: 600;
    border: 1px solid transparent;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.5);
}
.tabs-badge--emerald {
    background: rgba(16, 185, 129, 0.08);
    color: #059669;
    border-color: rgba(16, 185, 129, 0.25);
}
.tabs-badge--emerald-active {
    background: linear-gradient(135deg, #10b981, #34d399);
    color: white;
    border-color: rgba(13, 148, 136, 0.6);
}
.tabs-badge--amber {
    background: rgba(251, 191, 36, 0.08);
    color: #b45309;
    border-color: rgba(251, 191, 36, 0.3);
}
.tabs-badge--amber-active {
    background: linear-gradient(135deg, #fde047, #fb923c);
    color: #7c2d12;
    border-color: rgba(251, 191, 36, 0.45);
}
.tabs-badge--rose {
    background: rgba(251, 113, 133, 0.08);
    color: #be185d;
    border-color: rgba(251, 113, 133, 0.3);
}
.tabs-badge--rose-active {
    background: linear-gradient(135deg, #f43f5e, #fb7185);
    color: white;
    border-color: rgba(244, 63, 94, 0.45);
}
.tabs-badge--slate {
    background: rgba(148, 163, 184, 0.12);
    color: #475569;
    border-color: rgba(148, 163, 184, 0.35);
}
.tabs-badge--slate-active {
    background: linear-gradient(135deg, #94a3b8, #818cf8);
    color: white;
    border-color: rgba(99, 102, 241, 0.4);
}
.tab-icon-base {
    display: grid;
    place-items: center;
    width: 2.5rem;
    height: 2.5rem;
    border-radius: 1.2rem;
    font-weight: 600;
    font-size: 0.9rem;
    border: 1px solid transparent;
    transition: transform 0.15s ease;
}
.tabs-icon {
    box-shadow:
        inset 0 1px 4px rgba(255, 255, 255, 0.45),
        0 10px 18px rgba(15, 23, 42, 0.12);
}
.tabs-icon--emerald {
    background: linear-gradient(135deg, rgba(209, 250, 229, 0.9), rgba(16, 185, 129, 0.2));
    color: #059669;
    border-color: rgba(16, 185, 129, 0.2);
}
.tabs-icon--emerald-active {
    background: linear-gradient(135deg, #0ea5e9, #10b981, #34d399);
    color: white;
    border-color: rgba(16, 185, 129, 0.35);
}
.tabs-icon--amber {
    background: linear-gradient(135deg, rgba(254, 240, 138, 0.95), rgba(251, 191, 36, 0.2));
    color: #b45309;
    border-color: rgba(251, 191, 36, 0.3);
}
.tabs-icon--amber-active {
    background: linear-gradient(135deg, #fde047, #fbbf24, #fb923c);
    color: #7c2d12;
    border-color: rgba(251, 191, 36, 0.4);
}
.tabs-icon--rose {
    background: linear-gradient(135deg, rgba(254, 226, 226, 0.9), rgba(251, 113, 133, 0.25));
    color: #be185d;
    border-color: rgba(251, 113, 133, 0.3);
}
.tabs-icon--rose-active {
    background: linear-gradient(135deg, #f43f5e, #ec4899, #fb7185);
    color: white;
    border-color: rgba(244, 63, 94, 0.4);
}
.tabs-icon--slate {
    background: linear-gradient(135deg, rgba(226, 232, 240, 0.9), rgba(148, 163, 184, 0.25));
    color: #475569;
    border-color: rgba(148, 163, 184, 0.35);
}
.tabs-icon--slate-active {
    background: linear-gradient(135deg, #94a3b8, #818cf8, #67e8f9);
    color: white;
    border-color: rgba(99, 102, 241, 0.35);
}
</style>
