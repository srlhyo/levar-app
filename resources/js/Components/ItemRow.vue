<template>
    <div
        class="flex flex-col gap-3 rounded-3xl bg-white/80 p-4 ring-1 ring-black/5 backdrop-blur-sm sm:flex-row sm:items-center sm:gap-6"
    >
        <label v-if="selectable" class="flex items-start">
            <input
                :checked="selected"
                type="checkbox"
                class="mt-1 h-5 w-5 rounded border-slate-300 text-emerald-500 focus:ring-emerald-400"
                @change="onToggle"
            />
        </label>

        <div class="flex flex-1 items-start gap-4">
            <div class="grid h-14 w-14 flex-shrink-0 place-items-center rounded-2xl bg-slate-200/80 text-slate-500 sm:h-16 sm:w-16">
                <Package class="h-6 w-6" />
            </div>
            <div class="space-y-1">
                <p class="text-base font-semibold text-slate-900 sm:text-lg">{{ item.title ?? item.name }}</p>
                <p v-if="item.notes" class="text-sm text-slate-600">{{ item.notes }}</p>
                <div class="flex flex-wrap items-center gap-2 text-xs font-semibold text-slate-600">
                    <span v-if="item.weight" class="rounded-full bg-slate-900 px-3 py-1 text-white">
                        {{ Number(item.weight).toFixed(1) }} kg
                    </span>
                    <span v-if="item.bag" class="rounded-full bg-white px-3 py-1 text-slate-700 ring-1 ring-black/5">
                        Mala {{ item.bag }}
                    </span>
                    <span v-if="item.packed" class="rounded-full bg-emerald-500/90 px-3 py-1 text-white">
                        Pronto
                    </span>
                </div>
            </div>
        </div>

        <div class="flex items-center gap-2 self-stretch sm:self-center">
            <div v-if="showRequeue" class="relative group">
                <button
                    type="button"
                    :aria-describedby="tooltipIds.requeue"
                    aria-label="Reinserir no deck"
                    class="inline-flex h-11 w-11 items-center justify-center rounded-2xl bg-white/80 text-slate-700 ring-1 ring-black/5 shadow-sm transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
                    @click="emit('requeue', item.id)"
                    @touchstart="() => handleHint('requeue')"
                >
                    <CornerUpLeft class="h-5 w-5" />
                </button>
                <span
                    :id="tooltipIds.requeue"
                    class="pointer-events-none absolute -top-9 left-1/2 hidden -translate-x-1/2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white opacity-0 transition group-hover:opacity-100 group-focus-within:opacity-100 sm:block"
                >
                    Reinserir no deck
                </span>
                <transition name="fade">
                    <span
                        v-if="hintVisible.requeue"
                        class="pointer-events-none absolute -top-10 left-1/2 -translate-x-1/2 rounded-full bg-slate-900/90 px-3 py-1 text-xs font-semibold text-white sm:hidden"
                    >
                        Reinserir no deck
                    </span>
                </transition>
            </div>

            <div v-if="showDelete" class="relative group">
                <button
                    type="button"
                    :aria-describedby="tooltipIds.delete"
                    aria-label="Enviar para a Reciclagem"
                    class="inline-flex h-11 w-11 items-center justify-center rounded-2xl bg-white/80 text-rose-600 ring-1 ring-rose-200 shadow-sm transition hover:bg-rose-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-rose-300"
                    @click="emit('delete', item.id)"
                    @touchstart="() => handleHint('delete')"
                >
                    <Trash2 class="h-5 w-5" />
                </button>
                <span
                    :id="tooltipIds.delete"
                    class="pointer-events-none absolute -top-9 left-1/2 hidden -translate-x-1/2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white opacity-0 transition group-hover:opacity-100 group-focus-within:opacity-100 sm:block"
                >
                    Enviar para a Reciclagem
                </span>
                <transition name="fade">
                    <span
                        v-if="hintVisible.delete"
                        class="pointer-events-none absolute -top-10 left-1/2 -translate-x-1/2 rounded-full bg-slate-900/90 px-3 py-1 text-xs font-semibold text-white sm:hidden"
                    >
                        Enviar para a Reciclagem
                    </span>
                </transition>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { CornerUpLeft, Package, Trash2 } from 'lucide-vue-next';

const props = defineProps({
    item: {
        type: Object,
        required: true,
    },
    selectable: {
        type: Boolean,
        default: true,
    },
    selected: {
        type: Boolean,
        default: false,
    },
    showRequeue: {
        type: Boolean,
        default: true,
    },
    showDelete: {
        type: Boolean,
        default: true,
    },
});

const emit = defineEmits(['toggle-select', 'requeue', 'delete']);

const isTouchDevice = ref(false);
const hintVisible = reactive({ requeue: false, delete: false });
const hintSeen = reactive({ requeue: false, delete: false });

const tooltipIds = computed(() => ({
    requeue: `tooltip-requeue-${props.item.id}`,
    delete: `tooltip-delete-${props.item.id}`,
}));

const onToggle = (event) => {
    emit('toggle-select', { id: props.item.id, value: event.target.checked });
};

const handleHint = (key) => {
    if (!isTouchDevice.value || hintSeen[key] || hintVisible[key]) return;
    hintVisible[key] = true;
    hintSeen[key] = true;
    window.setTimeout(() => {
        hintVisible[key] = false;
    }, 1200);
};

onMounted(() => {
    if (typeof window !== 'undefined') {
        isTouchDevice.value = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
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
