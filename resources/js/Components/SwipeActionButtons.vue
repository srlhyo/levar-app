<template>
    <div class="flex w-full max-w-md flex-col gap-4 sm:max-w-lg">
        <div class="flex w-full items-stretch justify-between gap-3">
            <button
                v-for="action in resolvedActions"
                :key="action.name"
                type="button"
                :aria-label="action.label"
                :class="[
                    'btn-pill group flex-1 text-center text-[11px] font-semibold uppercase tracking-[0.3em] transition focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-40 sm:min-h-[4.25rem]',
                    action.classes,
                ]"
                :disabled="disabled"
                @click="() => emitDecision(action.name, action.options)"
                @touchstart="() => handleTouch(action.name)"
            >
                <div class="btn-pill__content">
                    <TileIcon3D :tone="action.tone" class="btn-pill__icon">
                        <component :is="action.icon" class="btn-pill__glyph" />
                    </TileIcon3D>
                    <span class="btn-pill__label">{{ action.label }}</span>
                </div>
                <span
                    class="btn-pill__tooltip pointer-events-none absolute -top-9 left-1/2 hidden -translate-x-1/2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white opacity-0 transition delay-[150ms] group-hover:opacity-100 group-focus-within:opacity-100 sm:block"
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
import TileIcon3D from '@/Components/home/TileIcon3D.vue';

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
        tone: 'amber',
        classes: 'btn-pill--no',
    },
    {
        name: 'pending',
        label: 'Decidir depois',
        icon: Clock,
        tone: 'slate',
        classes: 'btn-pill--pending',
    },
    {
        name: 'yes',
        label: 'Levar',
        icon: Heart,
        tone: 'emerald',
        classes: 'btn-pill--yes',
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
.btn-pill {
    position: relative;
    border-radius: 1.5rem;
    overflow: hidden;
    border: 1px solid rgba(148, 163, 184, 0.35);
    padding: 0.8rem 1rem;
    background: rgba(255, 255, 255, 0.92);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.85),
        0 22px 45px rgba(15, 23, 42, 0.12);
}
.btn-pill::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(135deg, rgba(99, 102, 241, 0.12), rgba(14, 165, 233, 0.1));
    opacity: 0;
    transition: opacity 0.25s ease;
}
.btn-pill:hover::before {
    opacity: 0.8;
}
.btn-pill:active {
    transform: scale(0.97);
}
.btn-pill__content {
    position: relative;
    z-index: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.4rem;
    color: #0f172a;
}
.btn-pill__icon {
    --tile-icon-size: 2.5rem;
}
.btn-pill__glyph {
    width: 1.15rem;
    height: 1.15rem;
}
.btn-pill__label {
    letter-spacing: 0.35em;
}
.btn-pill--no {
    background: linear-gradient(145deg, rgba(248, 250, 252, 0.95), rgba(254, 242, 242, 0.92));
    border-color: rgba(248, 113, 113, 0.4);
}
.btn-pill--pending {
    background: linear-gradient(145deg, rgba(241, 245, 249, 0.95), rgba(226, 232, 240, 0.9));
}
.btn-pill--yes {
    background: linear-gradient(145deg, rgba(222, 255, 244, 0.95), rgba(187, 247, 208, 0.92));
    border-color: rgba(16, 185, 129, 0.4);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.9),
        0 25px 45px rgba(16, 185, 129, 0.25);
}
</style>
