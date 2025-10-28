<template>
    <div class="space-y-4">
        <div class="sticky top-2 z-10">
            <div
                class="flex gap-2 rounded-3xl bg-white/80 p-1 shadow-sm ring-1 ring-black/5 backdrop-blur-sm"
                role="tablist"
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
                    class="flex-1 rounded-2xl px-3 py-2 text-sm font-semibold transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-400"
                    :class="tabClass(tab.key)"
                    @click="select(tab.key)"
                    @keydown.enter.prevent="select(tab.key)"
                    @keydown.space.prevent="select(tab.key)"
                >
                    <span class="flex items-center justify-center gap-2">
                        <span>{{ tab.label }}</span>
                        <span
                            v-if="tab.badge !== undefined"
                            class="inline-flex min-h-[1.5rem] min-w-[1.5rem] items-center justify-center rounded-full px-2 text-xs font-semibold"
                            :class="current === tab.key ? 'bg-emerald-500/15 text-emerald-600' : 'bg-slate-900/10 text-slate-700'"
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
});

const emit = defineEmits(['update:modelValue']);

const current = computed(() => {
    if (props.modelValue) return props.modelValue;
    return props.items?.[0]?.key ?? '';
});

const tabClass = (key) => {
    const active = current.value === key;
    return active ? 'bg-white text-slate-900 shadow-sm ring-1 ring-emerald-100' : 'text-slate-600 hover:bg-white/70';
};

const select = (key) => {
    if (!key || key === current.value) return;
    emit('update:modelValue', key);
};
</script>
