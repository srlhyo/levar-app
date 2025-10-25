<template>
    <teleport to="body">
        <Transition
            enter-active-class="transition duration-200 ease-out"
            enter-from-class="translate-y-3 opacity-0"
            enter-to-class="translate-y-0 opacity-100"
            leave-active-class="transition duration-150 ease-in"
            leave-from-class="translate-y-0 opacity-100"
            leave-to-class="translate-y-3 opacity-0"
        >
            <div
                v-if="open"
                class="fixed bottom-2 left-1/2 z-50 max-w-[80vw] -translate-x-1/2 text-slate-800 sm:bottom-4 sm:right-4 sm:left-auto sm:translate-x-0 sm:max-w-sm"
                role="status"
                aria-live="polite"
            >
                <div class="flex items-start gap-3 rounded-2xl bg-white/95 px-4 py-3 ring-1 ring-black/5 shadow-xl backdrop-blur-md">
                    <div class="grid h-10 w-10 place-items-center rounded-full bg-emerald-100 text-emerald-600">
                        <Sparkles class="h-5 w-5" />
                    </div>
                    <div class="flex-1">
                        <p class="text-sm font-semibold leading-snug">
                            {{ message }}
                        </p>
                    </div>
                </div>
            </div>
        </Transition>
    </teleport>
</template>

<script setup>
import { onBeforeUnmount, watch, ref } from 'vue';
import { Sparkles } from 'lucide-vue-next';

const props = defineProps({
    modelValue: {
        type: Boolean,
        default: false,
    },
    message: {
        type: String,
        default: 'Modo completo ativado ✨',
    },
    duration: {
        type: Number,
        default: 2500,
    },
});

const emit = defineEmits(['update:modelValue']);

const open = ref(props.modelValue);
let timer = null;

const close = () => {
    open.value = false;
    emit('update:modelValue', false);
};

const queueClose = () => {
    if (!open.value) return;
    if (timer) {
        window.clearTimeout(timer);
    }
    timer = window.setTimeout(() => {
        close();
    }, props.duration);
};

watch(
    () => props.modelValue,
    (value) => {
        open.value = value;
        if (value) {
            queueClose();
        } else if (timer) {
            window.clearTimeout(timer);
            timer = null;
        }
    },
    { immediate: true },
);

onBeforeUnmount(() => {
    if (timer) {
        window.clearTimeout(timer);
        timer = null;
    }
});
</script>
