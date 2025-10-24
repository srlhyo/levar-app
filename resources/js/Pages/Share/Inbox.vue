<template>
    <Head title="Inbox de Compartilhamento" />
    <div class="min-h-screen bg-background flex flex-col items-center justify-center p-6 text-center">
        <p class="text-6xl mb-4">📬</p>
        <h1 class="text-2xl font-bold mb-2">Inbox</h1>
        <p class="text-muted-foreground max-w-md">
            Este espaço receberá itens compartilhados com você. A integração com uploads e convites será adicionada
            futuramente.
        </p>
        <button
            type="button"
            class="mt-6 inline-flex items-center gap-2 rounded-xl border border-border px-4 py-2 text-sm font-medium text-muted-foreground hover:text-foreground hover:border-foreground transition"
            @click="router.visit('/')"
        >
            Voltar ao início
        </button>
    </div>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';

defineOptions({ layout: AppLayout });
</script>
