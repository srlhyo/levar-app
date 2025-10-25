<template>
    <div class="space-y-1">
        <h2 class="text-xl font-semibold text-slate-800 sm:text-2xl">
            <slot name="title">
                {{ title }}
            </slot>
        </h2>
        <p v-if="subtitle || $slots.subtitle" class="text-sm leading-relaxed text-slate-600 sm:text-base">
            <slot name="subtitle">
                {{ subtitle }}
            </slot>
        </p>
    </div>
</template>

<script setup>
defineProps({
    title: {
        type: String,
        default: '',
    },
    subtitle: {
        type: String,
        default: '',
    },
});
</script>
