<template>
    <div class="min-h-screen bg-background text-foreground">
        <slot />
        <ToastHub />
    </div>
</template>

<script setup>
import ToastHub from '@/Components/ToastHub.vue';
</script>
