<template>
    <div
        :class="[
            baseClass,
            toneClass,
            sizeClass,
            disabled ? 'opacity-40 pointer-events-none' : '',
        ]"
    >
        <slot />
    </div>
</template>

<script setup>
import { computed } from 'vue';

const toneClasses = {
    neutral: 'text-slate-600',
    blue: 'text-sky-600',
    green: 'text-emerald-600',
    yellow: 'text-amber-600',
    slate: 'text-slate-600',
    white: 'text-white',
};

const sizeClasses = {
    md: 'h-14 w-14 md:h-16 md:w-16',
    lg: 'h-16 w-16 md:h-[4.5rem] md:w-[4.5rem]',
};

const props = defineProps({
    tone: {
        type: String,
        default: 'neutral',
    },
    size: {
        type: String,
        default: 'md',
        validator: (value) => ['md', 'lg'].includes(value),
    },
    disabled: {
        type: Boolean,
        default: false,
    },
});

const toneClass = computed(() => toneClasses[props.tone] ?? toneClasses.neutral);
const sizeClass = computed(() => sizeClasses[props.size] ?? sizeClasses.md);
const disabled = computed(() => props.disabled);

const baseClass = 'grid place-items-center rounded-2xl bg-white/70 ring-1 ring-black/5 text-lg';
</script>
