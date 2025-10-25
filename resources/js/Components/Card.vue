<template>
    <component
        :is="tag"
        v-bind="$attrs"
        :class="[
            baseClass,
            toneClass,
            disabled ? 'opacity-40 pointer-events-none' : 'hover:shadow-lg',
        ]"
    >
        <slot />
    </component>
</template>

<script setup>
import { computed } from 'vue';

const toneClasses = {
    blue: 'tone-blue',
    green: 'tone-green',
    yellow: 'tone-yellow',
    slate: 'tone-slate',
};

const props = defineProps({
    tag: {
        type: String,
        default: 'div',
    },
    tone: {
        type: String,
        default: 'slate',
        validator: (value) => ['blue', 'green', 'yellow', 'slate'].includes(value),
    },
    disabled: {
        type: Boolean,
        default: false,
    },
});

const tag = computed(() => props.tag);
const toneClass = computed(() => toneClasses[props.tone] ?? toneClasses.slate);
const disabled = computed(() => props.disabled);

const baseClass =
    'rounded-3xl p-5 text-left shadow-lg/30 shadow-slate-200 ring-1 ring-black/5 transition backdrop-blur-sm text-slate-900 sm:p-6';
</script>
