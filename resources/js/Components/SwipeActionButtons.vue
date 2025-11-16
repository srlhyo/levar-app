<template>
    <div class="flex w-full max-w-md flex-col gap-4 sm:max-w-lg">
        <div class="flex w-full items-stretch justify-between gap-3">
            <button
                v-for="action in resolvedActions"
                :key="action.name"
                type="button"
                :aria-label="action.label"
                :class="[
                    'relative group flex-1 rounded-full border px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide shadow transition focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-40 sm:min-h-[4.25rem] flex flex-col items-center gap-1',
                    action.classes,
                ]"
                :disabled="disabled"
                @click="() => emitDecision(action.name, action.options)"
                @touchstart="() => handleTouch(action.name)"
            >
                <component :is="action.icon" class="h-6 w-6" />
                <span>{{ action.label }}</span>
                <span
                    class="pointer-events-none absolute -top-9 left-1/2 hidden -translate-x-1/2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white opacity-0 transition delay-[150ms] group-hover:opacity-100 group-focus-within:opacity-100 sm:block"
                >
                    {{ action.label }}
                </span>
                <transition name="fade">
                    <span
                        v-if="touchHint[action.name]"
                        class="pointer-events-none absolute -top-10 left-1/2 -translate-x-1/2 rounded-full bg-slate-900/90 px-3 py-1 text-xs font-semibold text-white sm:hidden"
                    >
                        {{ action.label }}
                    </span>
                </transition>
            </button>
        </div>

    </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { Clock, Heart, X } from 'lucide-vue-next';

const props = defineProps({
    disabled: {
        type: Boolean,
        default: false,
    },
    actions: {
        type: Array,
        default: () => [],
    },
});

const emit = defineEmits(['decide']);

const defaultActions = [
    {
        name: 'no',
        label: 'Não levar',
        icon: X,
        classes: 'border-rose-200 bg-white text-rose-600 hover:bg-rose-50 focus-visible:ring-rose-300',
    },
    {
        name: 'pending',
        label: 'Decidir depois',
        icon: Clock,
        classes: 'border-slate-200 bg-white text-slate-700 hover:bg-slate-50 focus-visible:ring-slate-300',
    },
    {
        name: 'yes',
        label: 'Levar',
        icon: Heart,
        classes: 'border-emerald-400 bg-emerald-500 text-white hover:bg-emerald-400 focus-visible:ring-emerald-300',
    },
];

const resolvedActions = computed(() => (props.actions.length ? props.actions : defaultActions));

const touchHint = reactive({
    no: false,
    pending: false,
    yes: false,
});

const isTouchDevice = ref(false);
const hintsDismissed = ref(false);

const emitDecision = (name, options = {}) => {
    emit('decide', name, options ?? {});
};

const handleTouch = (name) => {
    if (!isTouchDevice.value || hintsDismissed.value || !(name in touchHint) || touchHint[name]) return;
    touchHint[name] = true;
    hintsDismissed.value = true;
    if (typeof window !== 'undefined') {
        window.localStorage.setItem('seen_decidir_hints', 'true');
    }
    window.setTimeout(() => {
        touchHint[name] = false;
    }, 1500);
};

onMounted(() => {
    if (typeof window !== 'undefined') {
        isTouchDevice.value = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
        hintsDismissed.value = window.localStorage.getItem('seen_decidir_hints') === 'true';
    }
});
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>
