<template>
    <teleport to="body">
        <TransitionGroup
            appear
            tag="div"
            enter-active-class="transition duration-200 ease-out"
            enter-from-class="opacity-0 translate-y-2"
            enter-to-class="opacity-100 translate-y-0"
            leave-active-class="transition duration-150 ease-in"
            leave-from-class="opacity-100 translate-y-0"
            leave-to-class="opacity-0 -translate-y-2"
            class="fixed inset-x-0 top-4 z-50 flex flex-col items-center gap-2 px-4 pointer-events-none"
        >
            <div
                v-for="toast in toasts"
                :key="toast.id"
                class="pointer-events-auto w-full max-w-sm rounded-xl px-4 py-3 shadow-smooth-md border"
                :class="variantClass(toast.variant)"
                role="status"
                @click="dismiss(toast.id)"
            >
                <p v-if="toast.title" class="text-sm font-semibold">{{ toast.title }}</p>
                <p class="text-sm">{{ toast.message }}</p>
            </div>
        </TransitionGroup>
    </teleport>
</template>

<script setup>
import { useToastStore } from '@/utils/toast';

const { toasts, dismiss } = useToastStore();

const variantClass = (variant) => {
    switch (variant) {
        case 'success':
            return 'bg-decide text-white border-transparent';
        case 'error':
            return 'bg-destructive text-white border-transparent';
        default:
            return 'bg-foreground text-background border-transparent';
    }
};
</script>
