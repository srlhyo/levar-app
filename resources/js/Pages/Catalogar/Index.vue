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

                <div class="space-y-2">
                    <span class="text-sm font-medium text-slate-700">Dimensões (cm)</span>
                    <div class="grid grid-cols-3 gap-3">
                        <input
                            v-model="length"
                            min="0"
                            placeholder="Compr."
                            class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            type="number"
                        />
                        <input
                            v-model="width"
                            min="0"
                            placeholder="Larg."
                            class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            type="number"
                        />
                        <input
                            v-model="height"
                            min="0"
                            placeholder="Alt."
                            class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            type="number"
                        />
                    </div>
                    <p class="text-xs text-slate-500">Preencha em centímetros (opcional). Ex.: 55 × 40 × 23</p>
                </div>

                <div class="grid gap-4 sm:grid-cols-2">
                    <label class="space-y-2">
                        <span class="text-sm font-medium text-slate-700">Categoria</span>
                        <select
                            v-model="category"
                            class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                        >
                            <option value="">Selecionar...</option>
                            <option value="cozinha">Cozinha</option>
                            <option value="sala">Sala</option>
                            <option value="quarto">Quarto</option>
                            <option value="escritorio">Escritório</option>
                            <option value="banheiro">Banheiro</option>
                            <option value="outros">Outros</option>
                        </select>
                    </label>

                    <label class="space-y-2">
                        <span class="text-sm font-medium text-slate-700">Fragilidade</span>
                        <div class="flex h-[42px] items-center justify-between rounded-2xl border border-sky-200 bg-white/80 px-3 shadow-inner shadow-slate-200">
                            <span class="text-sm text-slate-700">Item frágil?</span>
                            <button
                                type="button"
                                class="relative inline-flex h-6 w-11 items-center rounded-full transition"
                                :class="fragile ? 'bg-amber-400' : 'bg-slate-300'"
                                @click="toggleFragile"
                            >
                                <span
                                    class="inline-block h-5 w-5 transform rounded-full bg-white shadow transition"
                                    :class="fragile ? 'translate-x-5' : 'translate-x-1'"
                                />
                            </button>
                        </div>
                    </label>
                </div>

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
const weight = ref('');
const length = ref('');
const width = ref('');
const height = ref('');
const category = ref('');
const fragile = ref(false);

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
    weight.value = '';
    length.value = '';
    width.value = '';
    height.value = '';
    category.value = '';
    fragile.value = false;
};

const toggleFragile = () => {
    fragile.value = !fragile.value;
};

const handleSubmit = () => {
    if (!name.value.trim()) {
        toast.error('Por favor, dê um nome ao item');
        return;
    }

    const dimensionValues = [length.value, width.value, height.value]
        .map((value) => (value ? Number(value).toString() : ''))
        .filter(Boolean);
    const dimensionString =
        dimensionValues.length === 3 ? `${dimensionValues[0]} × ${dimensionValues[1]} × ${dimensionValues[2]} cm` : undefined;

    const newItem = {
        id: Date.now().toString(),
        name: name.value.trim(),
        photo: photo.value || undefined,
        weight: weight.value ? parseFloat(weight.value) : 0,
        dimensions: dimensionString,
        category: category.value || undefined,
        fragile: fragile.value,
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
