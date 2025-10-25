<template>
    <div class="w-full max-w-sm rounded-3xl bg-white/80 p-4 shadow-lg/20 shadow-slate-200 ring-1 ring-black/5 backdrop-blur-sm space-y-3">
        <div class="flex items-start gap-3">
            <div class="flex-1 space-y-1">
                <p class="text-sm font-semibold text-slate-900 leading-snug">
                    {{ message }}
                </p>
                <p class="text-xs text-slate-500">
                    Desfaz em {{ secondsLabel }}
                </p>
            </div>
            <button
                type="button"
                class="text-sm font-semibold text-emerald-600 hover:text-emerald-500 transition"
                @click="emit('undo')"
            >
                Desfazer
            </button>
        </div>
        <div class="h-1.5 rounded-full bg-slate-200 overflow-hidden">
            <div
                class="h-full origin-left bg-emerald-400"
                :style="{
                    transform: progressTransform,
                    transition: `transform ${duration}ms linear`,
                }"
            />
        </div>
    </div>
</template>

<script setup>
import { computed, nextTick, onMounted, ref, watch } from 'vue';

const props = defineProps({
    message: {
        type: String,
        required: true,
    },
    duration: {
        type: Number,
        default: 4000,
    },
});

const emit = defineEmits(['undo']);

const progressTransform = ref('scaleX(1)');

const secondsLabel = computed(() => `${(props.duration / 1000).toFixed(1)}s`);

const startProgress = () => {
    progressTransform.value = 'scaleX(1)';
    nextTick(() => {
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                progressTransform.value = 'scaleX(0)';
            });
        });
    });
};

onMounted(startProgress);

watch(
    () => props.duration,
    () => {
        startProgress();
    },
);
</script>
