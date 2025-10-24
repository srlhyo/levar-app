<template>
    <div class="text-white p-6 shadow-smooth-md" :class="[gradientClass]">
        <div class="flex items-center gap-4 mb-2">
            <button
                v-if="showBack"
                type="button"
                class="rounded-full h-10 w-10 inline-flex items-center justify-center hover:bg-white/20 transition"
                @click="$emit('back')"
            >
                <ArrowLeft class="h-6 w-6" />
            </button>
            <h1 class="text-2xl font-bold">{{ title }}</h1>
        </div>
        <p v-if="subtitle" class="text-white/90 text-sm">
            {{ subtitle }}
        </p>
        <slot />
    </div>
</template>

<script setup>
import { ArrowLeft } from 'lucide-vue-next';

defineProps({
    title: { type: String, required: true },
    subtitle: { type: String, default: '' },
    gradientClass: { type: String, required: true },
    showBack: { type: Boolean, default: true },
});

defineEmits(['back']);
</script>
