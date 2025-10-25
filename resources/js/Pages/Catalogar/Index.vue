<template>
    <Head title="Catalogar" />
    <AppLayout>
        <template #title>Catalogar</template>
        <template #subtitle>Tire fotos, estime peso e registre detalhes para cada item da mudança.</template>

        <Card tone="blue" class="space-y-6">
            <div class="flex items-start gap-3">
                <IconPill tone="blue">
                    <Camera class="h-6 w-6" />
                </IconPill>
                <div class="space-y-1">
                    <h2 class="text-lg font-semibold text-slate-800 sm:text-xl">Adicionar um novo item</h2>
                    <p class="text-sm text-slate-600 sm:text-base">Preencha as informações abaixo para manter o catálogo organizado.</p>
                </div>
            </div>

            <form class="space-y-6" @submit.prevent="handleSubmit">
                <div class="space-y-3">
                    <label class="text-sm font-medium text-slate-700">Foto</label>

                    <div v-if="photo" class="relative overflow-hidden rounded-2xl shadow-inner shadow-slate-200">
                        <img :src="photo" alt="Preview" class="h-56 w-full object-cover" />
                        <button
                            type="button"
                            class="absolute right-3 top-3 rounded-full bg-white/95 px-3 py-1 text-xs font-semibold text-slate-700 shadow"
                            @click="photo = ''"
                        >
                            Trocar
                        </button>
                    </div>

                    <button
                        v-else
                        type="button"
                        class="w-full rounded-2xl border-2 border-dashed border-sky-300/60 py-10 text-slate-500 transition hover:border-sky-400/80 hover:text-slate-600"
                        @click="triggerFilePicker"
                    >
                        <div class="flex flex-col items-center gap-3">
                            <Camera class="h-10 w-10 text-sky-500" />
                            <span class="text-sm font-medium">Adicionar foto do item</span>
                        </div>
                    </button>

                    <input
                        ref="fileInput"
                        type="file"
                        accept="image/*"
                        capture="environment"
                        class="hidden"
                        @change="handlePhotoCapture"
                    />
                </div>

                <div class="grid gap-4 sm:grid-cols-2">
                    <label class="space-y-2">
                        <span class="text-sm font-medium text-slate-700">Nome do item *</span>
                        <input
                            v-model="name"
                            required
                            placeholder="Ex: Livros de cozinha"
                            class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            type="text"
                        />
                    </label>

                    <label class="space-y-2">
                        <span class="text-sm font-medium text-slate-700">Peso estimado (kg)</span>
                        <input
                            v-model="weight"
                            step="0.1"
                            placeholder="0.0"
                            class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            type="number"
                        />
                    </label>
                </div>

                <label class="space-y-2">
                    <span class="text-sm font-medium text-slate-700">Notas</span>
                    <textarea
                        v-model="notes"
                        rows="4"
                        placeholder="Observações importantes..."
                        class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200 resize-none"
                    />
                </label>

                <div class="flex justify-end">
                    <button
                        type="submit"
                        class="inline-flex items-center gap-2 rounded-2xl bg-sky-500 px-5 py-2.5 text-sm font-semibold text-white shadow hover:bg-sky-400"
                    >
                        <Plus class="h-4 w-4" />
                        Adicionar item
                    </button>
                </div>
            </form>
        </Card>
    </AppLayout>
</template>

<script setup>
import { Head } from '@inertiajs/vue3';
import { ref } from 'vue';
import { Camera, Plus } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';
import { storage } from '@/utils/storage';
import { toast } from '@/utils/toast';

const fileInput = ref(null);
const photo = ref('');
const name = ref('');
const notes = ref('');
const weight = ref('');

const handlePhotoCapture = (event) => {
    const file = event.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onloadend = () => {
        photo.value = reader.result?.toString() ?? '';
    };
    reader.readAsDataURL(file);
};

const triggerFilePicker = () => {
    fileInput.value?.click();
};

const resetForm = () => {
    photo.value = '';
    name.value = '';
    notes.value = '';
    weight.value = '';
};

const handleSubmit = () => {
    if (!name.value.trim()) {
        toast.error('Por favor, dê um nome ao item');
        return;
    }

    const newItem = {
        id: Date.now().toString(),
        name: name.value.trim(),
        photo: photo.value || undefined,
        notes: notes.value.trim() || undefined,
        weight: weight.value ? parseFloat(weight.value) : 0,
        decision: 'pending',
        packed: false,
        luggage: null,
        createdAt: new Date().toISOString(),
    };

    storage.addItem(newItem);
    toast.success(`${newItem.name} adicionado!`);
    resetForm();
};
</script>
