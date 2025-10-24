<template>
    <button
        :disabled="disabled"
        class="transition-all duration-300 rounded-2xl p-6 text-left shadow-smooth-md hover:shadow-smooth-lg hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 disabled:hover:shadow-smooth-md w-full"
        :class="[bgClass]"
        @click="$emit('click')"
    >
        <div class="flex items-center gap-4">
            <div class="p-4 rounded-xl shadow-smooth-sm" :class="gradientClass">
                <slot name="icon" />
            </div>
            <div class="flex-1">
                <h2 class="text-xl font-bold mb-1" :class="textClass">{{ title }}</h2>
                <p class="text-sm text-muted-foreground">{{ subtitle }}</p>
            </div>
        </div>
    </button>
</template>

<script setup>
defineProps({
    title: { type: String, required: true },
    subtitle: { type: String, required: true },
    bgClass: { type: String, required: true },
    gradientClass: { type: String, required: true },
    textClass: { type: String, required: true },
    disabled: { type: Boolean, default: false },
});

defineEmits(['click']);
</script>
