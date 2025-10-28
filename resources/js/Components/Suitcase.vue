<template>
    <div
        class="flex flex-col items-center gap-3 rounded-2xl border border-slate-100 bg-white/80 p-4 text-center shadow-sm transition hover:-translate-y-0.5 hover:shadow-md sm:p-5"
    >
        <div
            role="img"
            :aria-label="`${name}, ${dims}, ${current.toFixed(1)} de ${max} quilos, status ${status}`"
            class="relative mx-auto w-28 h-40 sm:w-32 sm:h-44"
        >
            <div class="absolute -top-3 left-1/2 h-2 w-8 -translate-x-1/2 rounded-full bg-slate-400" />
            <div class="absolute -top-1 left-1/2 h-4 w-[2px] -translate-x-1/2 bg-slate-300" />

            <div
                class="absolute inset-0 rounded-[14px] border shadow-inner transition"
                :class="[shellClass, pulseClass]"
            >
                <div class="absolute top-6 left-2 right-2 h-[2px] rounded bg-white/60" />
                <div class="absolute top-[30%] left-3 right-3 h-[1.5px] rounded bg-white/50" />
                <div class="absolute top-[55%] left-3 right-3 h-[1.5px] rounded bg-white/50" />
                <div class="absolute top-[75%] left-3 right-3 h-[1.5px] rounded bg-white/60" />
                <div class="absolute bottom-3 left-3 right-3 h-[6px] rounded-full bg-white/60" />

                <div class="absolute top-2 left-2 h-2 w-2 rounded-full bg-white/70" />
                <div class="absolute top-2 right-2 h-2 w-2 rounded-full bg-white/70" />
                <div class="absolute bottom-2 left-2 h-2 w-2 rounded-full bg-white/70" />
                <div class="absolute bottom-2 right-2 h-2 w-2 rounded-full bg-white/70" />

                <div
                    class="absolute bottom-[10px] left-[6px] right-[6px] rounded-b-[10px] bg-slate-500/15 transition-all duration-700 ease-in-out"
                    :style="{ height: `${Math.min(Math.max(ratio, 0), 1.2) * 60}%` }"
                />

                <div class="absolute -bottom-2 left-6 right-6 mx-auto flex w-16 justify-between sm:left-8 sm:right-8 sm:w-20">
                    <span class="h-3.5 w-3.5 rounded-full bg-slate-400 ring-2 ring-yellow-100" />
                    <span class="h-3.5 w-3.5 rounded-full bg-slate-400 ring-2 ring-yellow-100" />
                </div>

                <Lock
                    v-if="status === 'Fechado'"
                    class="absolute right-2 top-2 h-4 w-4 text-red-500"
                />
            </div>
        </div>

        <div class="space-y-1">
            <p class="text-sm font-semibold text-slate-800">
                {{ name }} — {{ dims }}
            </p>
            <p class="text-xs text-slate-500">
                {{ current.toFixed(1) }} kg / {{ max }} kg
            </p>
            <p class="text-sm font-semibold" :class="statusLabelClass">
                {{ status }}
            </p>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { Lock } from 'lucide-vue-next';

const props = defineProps({
    name: {
        type: String,
        required: true,
    },
    dims: {
        type: String,
        required: true,
    },
    current: {
        type: Number,
        required: true,
    },
    max: {
        type: Number,
        required: true,
    },
    status: {
        type: String,
        required: true,
        validator: (value) => ['Normal', 'Lotado', 'Fechado'].includes(value),
    },
    ratio: {
        type: Number,
        default: 0,
    },
});

const shellClass = computed(() => {
    switch (props.status) {
        case 'Lotado':
            return 'from-yellow-50 to-yellow-100 border-yellow-300';
        case 'Fechado':
            return 'from-red-50 to-red-100 border-red-300';
        default:
            return 'from-slate-50 to-slate-100 border-slate-200';
    }
});

const statusLabelClass = computed(() => {
    switch (props.status) {
        case 'Lotado':
            return 'text-yellow-600';
        case 'Fechado':
            return 'text-red-600';
        default:
            return 'text-slate-600';
    }
});

const pulseClass = computed(() => (props.status === 'Lotado' || props.status === 'Fechado' ? 'animate-[pulse_1.4s_ease-in-out_1]' : ''));
</script>
