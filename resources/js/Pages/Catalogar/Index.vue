<template>
    <Head title="Catalogar" />
    <div class="min-h-screen bg-catalog-secondary">
        <PageHeader
            title="Catalogar"
            subtitle="Tire fotos e adicione informações dos seus itens"
            gradient-class="bg-gradient-catalog"
            @back="router.visit('/')"
        />

        <div class="p-6">
            <form class="space-y-6" @submit.prevent="handleSubmit">
                <div class="bg-card rounded-xl p-6 shadow-smooth-sm space-y-4">
                    <div>
                        <label class="text-sm font-semibold text-catalog">Foto</label>
                        <div class="mt-2">
                            <div v-if="photo" class="relative">
                                <img :src="photo" alt="Preview" class="w-full h-48 object-cover rounded-lg" />
                                <button
                                    type="button"
                                    class="absolute top-2 right-2 bg-catalog text-white px-3 py-1 rounded-md text-sm shadow-smooth-sm"
                                    @click="photo = ''"
                                >
                                    Alterar
                                </button>
                            </div>
                            <button
                                v-else
                                type="button"
                                class="w-full h-48 border-2 border-dashed border-catalog/30 rounded-lg flex flex-col items-center justify-center gap-2 hover:border-catalog/50 transition-colors"
                                @click="triggerFilePicker"
                            >
                                <Camera class="h-12 w-12 text-catalog" />
                                <span class="text-sm text-catalog">Tirar/Escolher Foto</span>
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
                    </div>

                    <div>
                        <label class="text-sm font-semibold text-catalog" for="name">Nome do Item *</label>
                        <input
                            id="name"
                            v-model="name"
                            required
                            placeholder="Ex: Livros de cozinha"
                            class="mt-2 w-full rounded-lg border border-catalog/30 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-catalog"
                            type="text"
                        />
                    </div>

                    <div>
                        <label class="text-sm font-semibold text-catalog" for="weight">Peso (kg)</label>
                        <input
                            id="weight"
                            v-model="weight"
                            step="0.1"
                            placeholder="0.0"
                            class="mt-2 w-full rounded-lg border border-catalog/30 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-catalog"
                            type="number"
                        />
                    </div>

                    <div>
                        <label class="text-sm font-semibold text-catalog" for="notes">Notas</label>
                        <textarea
                            id="notes"
                            v-model="notes"
                            rows="3"
                            placeholder="Observações sobre o item..."
                            class="mt-2 w-full rounded-lg border border-catalog/30 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-catalog resize-none"
                        />
                    </div>
                </div>

                <button
                    type="submit"
                    class="w-full bg-catalog hover:bg-catalog/90 text-white rounded-xl px-4 py-3 flex items-center justify-center gap-2 text-lg shadow-smooth-md"
                >
                    <Plus class="h-5 w-5" />
                    Adicionar Item
                </button>
            </form>
        </div>
    </div>
</template>

<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import { Camera, Plus } from 'lucide-vue-next';
import { storage } from '@/utils/storage';
import { toast } from '@/utils/toast';
import PageHeader from '@/Components/PageHeader.vue';
import AppLayout from '@/Layouts/AppLayout.vue';

defineOptions({ layout: AppLayout });

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

    photo.value = '';
    name.value = '';
    notes.value = '';
    weight.value = '';
};
</script>
