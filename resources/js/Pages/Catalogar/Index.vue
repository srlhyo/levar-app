<template>
    <Head title="Catalogar" />
    <AppLayout>
        <template #title>Catalogar</template>
        <template #subtitle>Tire fotos, estime peso e registre detalhes para cada item da mudança.</template>

        <Card tone="green" class="space-y-6">
            <div class="flex items-start gap-3">
                <IconPill tone="green">
                    <Package class="h-6 w-6" />
                </IconPill>
                <div class="space-y-1">
                    <h2 class="text-lg font-semibold text-slate-800 sm:text-xl">Configuração das malas</h2>
                    <p class="text-sm text-slate-600 sm:text-base">
                        Defina quantas malas serão usadas, suas capacidades e o peso reservado para emergências.
                    </p>
                </div>
            </div>

            <div v-if="loadingConfig" class="flex items-center gap-2 rounded-2xl bg-white/60 px-4 py-3 text-sm text-slate-600">
                <Loader2 class="h-4 w-4 animate-spin" /> Carregando malas...
            </div>

            <form v-else class="space-y-6" @submit.prevent="handleSaveConfig">
                <div class="grid gap-4 sm:grid-cols-2">
                    <label class="space-y-2">
                        <span class="text-sm font-medium text-slate-700">Peso reservado (kg)</span>
                        <input
                            v-model="reservedKg"
                            type="number"
                            step="0.1"
                            min="0"
                            class="w-full rounded-2xl border border-emerald-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                        />
                        <span class="text-xs text-slate-500">Peso separado para imprevistos ou itens espontâneos.</span>
                    </label>
                    <label class="space-y-2">
                        <span class="text-sm font-medium text-slate-700">Volume reservado (L)</span>
                        <input
                            v-model="reservedVolume"
                            type="number"
                            step="0.1"
                            min="0"
                            class="w-full rounded-2xl border border-emerald-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                        />
                        <span class="text-xs text-slate-500">Espaço reservado em litros (1 L = 1000 cm³).</span>
                    </label>
                </div>

                <div class="space-y-4">
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-medium text-slate-700">Malas cadastradas</span>
                        <button
                            type="button"
                            class="inline-flex items-center gap-2 rounded-full bg-emerald-500 px-3 py-1.5 text-xs font-semibold text-white shadow hover:bg-emerald-400"
                            @click="addBag"
                        >
                            <Plus class="h-3.5 w-3.5" /> Adicionar mala
                        </button>
                    </div>

                    <div
                        v-for="(bag, index) in bags"
                        :key="bag.id ?? index"
                        class="rounded-2xl border border-emerald-200/70 bg-white/70 px-4 py-4 shadow-inner shadow-emerald-100"
                    >
                        <div class="flex items-start justify-between gap-3">
                            <div class="grid flex-1 gap-3 sm:grid-cols-2">
                                <label class="space-y-1">
                                    <span class="text-xs font-semibold uppercase tracking-wide text-slate-500">Nome</span>
                                    <input
                                        v-model="bag.name"
                                        required
                                        placeholder="Ex: Mala A"
                                        class="w-full rounded-2xl border border-emerald-200 bg-white px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                                        type="text"
                                    />
                                </label>
                                <label class="space-y-1">
                                    <span class="text-xs font-semibold uppercase tracking-wide text-slate-500">Código</span>
                                    <input
                                        v-model="bag.code"
                                        placeholder="Opcional"
                                        class="w-full rounded-2xl border border-emerald-200 bg-white px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                                        type="text"
                                    />
                                </label>
                                <label class="space-y-1">
                                    <span class="text-xs font-semibold uppercase tracking-wide text-slate-500">Capacidade (kg)</span>
                                    <input
                                        v-model="bag.capacity"
                                        type="number"
                                        step="0.1"
                                        min="0"
                                        placeholder="Ex: 23"
                                        class="w-full rounded-2xl border border-emerald-200 bg-white px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                                    />
                                </label>
                                <label class="space-y-1">
                                    <span class="text-xs font-semibold uppercase tracking-wide text-slate-500">Dimensões</span>
                                    <input
                                        v-model="bag.dimensions"
                                        placeholder="Ex: 78 × 50 × 30 cm"
                                        class="w-full rounded-2xl border border-emerald-200 bg-white px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                                        type="text"
                                    />
                                </label>
                            </div>
                            <button
                                v-if="bags.length > 1"
                                type="button"
                                class="mt-1 inline-flex h-10 w-10 items-center justify-center rounded-full bg-white text-rose-500 shadow ring-1 ring-rose-200 transition hover:bg-rose-50"
                                @click="removeBag(index)"
                            >
                                <Trash2 class="h-4 w-4" />
                            </button>
                        </div>
                    </div>
                </div>

                <div class="flex justify-end">
                    <button
                        type="submit"
                        class="inline-flex items-center gap-2 rounded-2xl bg-emerald-500 px-5 py-2.5 text-sm font-semibold text-white shadow hover:bg-emerald-400 disabled:cursor-not-allowed disabled:opacity-70"
                        :disabled="savingConfig"
                    >
                        <Loader2 v-if="savingConfig" class="h-4 w-4 animate-spin" />
                        <span>{{ savingConfig ? 'Salvando...' : 'Salvar configuração' }}</span>
                    </button>
                </div>
            </form>
        </Card>

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
                    <span class="text-sm font-medium text-slate-700">Descrição / notas</span>
                    <textarea
                        v-model="description"
                        rows="3"
                        placeholder="Inclua detalhes, estado ou observações importantes"
                        class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                    ></textarea>
                    <span class="text-xs text-slate-500">Essas notas aparecem nas cartas do Decidir e ajudam a lembrar detalhes.</span>
                </label>

                <label class="space-y-2">
                    <span class="text-sm font-medium text-slate-700">Volume estimado (litros)</span>
                    <input
                        v-model="volumeLiters"
                        @input="onVolumeInput"
                        min="0"
                        step="0.01"
                        placeholder="Ex.: 12,5"
                        class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                        type="number"
                    />
                    <p class="text-xs text-slate-500">
                        Informe o volume aproximado em litros. As dimensões abaixo são opcionais e servem apenas para sugerir um valor.
                    </p>
                    <button
                        v-if="calculatedVolumeLitersDisplay"
                        type="button"
                        class="inline-flex items-center gap-1 rounded-full bg-slate-900 px-3 py-1.5 text-xs font-semibold text-white shadow hover:bg-slate-800"
                        @click="applyCalculatedVolume"
                    >
                        Usar {{ calculatedVolumeLitersDisplay }} L calculados
                    </button>
                </label>

                <div class="space-y-2">
                    <span class="text-sm font-medium text-slate-700">Dimensões (cm) — opcional</span>
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
                    <p class="text-xs text-slate-500">Preencha em centímetros se quiser sugerir automaticamente o volume. Ex.: 55 × 40 × 23</p>
                    <p v-if="calculatedVolumeCm3" class="text-xs text-slate-500">
                        Volume calculado:
                        <span class="font-semibold text-slate-700">{{ calculatedVolumeLitersDisplay }} L</span>
                        ({{ calculatedVolumeCm3Display }} cm³)
                    </p>
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
import axios from 'axios';
import { Head, usePage } from '@inertiajs/vue3';
import { computed, onMounted, ref, watch, watchEffect } from 'vue';
import { Camera, Loader2, Package, Plus, Trash2 } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';
import { toast } from '@/utils/toast';
import { useDecisionStore } from '@/stores/decision';

const fileInput = ref(null);
const photo = ref('');
const name = ref('');
const description = ref('');
const weight = ref('');
const volumeLiters = ref('');
const length = ref('');
const width = ref('');
const height = ref('');
const category = ref('');
const fragile = ref(false);
const photoFile = ref(null);
const volumeTouched = ref(false);
const applyingCalculatedVolume = ref(false);

const parseLocaleNumber = (value) => {
    if (value === null || value === undefined) {
        return null;
    }

    if (typeof value === 'number') {
        return Number.isFinite(value) ? value : null;
    }

    if (typeof value !== 'string') {
        return null;
    }

    const trimmed = value.trim();

    if (!trimmed) {
        return null;
    }

    let normalized = trimmed.replace(/\s+/g, '');

    if (normalized.includes(',') && normalized.includes('.')) {
        normalized = normalized.replace(/\./g, '').replace(/,/g, '.');
    } else if (normalized.includes(',')) {
        normalized = normalized.replace(/,/g, '.');
    }

    const parsed = Number(normalized);

    return Number.isFinite(parsed) ? parsed : null;
};

const parsePositiveNumber = (value) => {
    const parsed = parseLocaleNumber(value);

    if (parsed === null || Number.isNaN(parsed) || parsed <= 0) {
        return null;
    }

    return parsed;
};

const reservedKg = ref(0);
const reservedVolume = ref('');
const bags = ref([]);
const loadingConfig = ref(false);
const savingConfig = ref(false);

const decisionStore = useDecisionStore();
const page = usePage();
const move = computed(() => page.props.move ?? null);

watchEffect(() => {
    decisionStore.setMove(move.value);
});

const blankBag = () => ({
    id: null,
    name: '',
    code: '',
    capacity: '',
    dimensions: '',
});

const normalizeBagPayload = (bag, index) => ({
    id: bag.id ?? null,
    name: bag.name?.trim() ?? '',
    code: bag.code?.trim() || null,
    capacity_kg: (() => {
        const parsed = parseLocaleNumber(bag.capacity);
        return parsed !== null && parsed >= 0 ? parsed : 0;
    })(),
    dimensions: bag.dimensions?.trim() || null,
    sort_order: index,
});

const hydrateConfig = (data) => {
    reservedKg.value = typeof data.reserved_kg === 'number' ? data.reserved_kg : 0;
    const volumeLiters = (() => {
        if (typeof data.reserved_volume_liters === 'number') return data.reserved_volume_liters;
        if (typeof data.reserved_volume_cm3 === 'number') return data.reserved_volume_cm3 / 1000;
        return 0;
    })();
    reservedVolume.value = volumeLiters ? String(volumeLiters) : '';
    decisionStore.reservedVolumeCm3 = volumeLiters ? volumeLiters * 1000 : 0;
    if (Array.isArray(data.bags) && data.bags.length) {
        bags.value = data.bags.map((bag) => ({
            id: bag.id ?? null,
            name: bag.name ?? '',
            code: bag.code ?? '',
            capacity: bag.capacity_kg != null ? String(bag.capacity_kg) : '',
            dimensions: bag.dimensions ?? '',
        }));
    } else {
        bags.value = [blankBag()];
    }
};

const fetchMoveConfig = async () => {
    if (!decisionStore.moveId) return;
    loadingConfig.value = true;
    try {
        const { data } = await axios.get(`/api/moves/${decisionStore.moveId}/config`);
        hydrateConfig(data);
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível carregar as malas.');
        bags.value = bags.value.length ? bags.value : [blankBag()];
    } finally {
        loadingConfig.value = false;
    }
};

onMounted(() => {
    if (decisionStore.moveId) {
        fetchMoveConfig();
    }
});

watch(
    () => decisionStore.moveId,
    (newId, oldId) => {
        if (newId && newId !== oldId) {
            fetchMoveConfig();
        }
    },
);

const addBag = () => {
    bags.value.push(blankBag());
};

const removeBag = (index) => {
    if (bags.value.length <= 1) return;
    bags.value.splice(index, 1);
};

const handleSaveConfig = async () => {
    if (!decisionStore.moveId) return;
    savingConfig.value = true;
    try {
        if (!bags.value.length) {
            toast.error('Cadastre ao menos uma mala.');
            return;
        }

        const sanitizedBags = bags.value.map((bag, index) => normalizeBagPayload(bag, index));

        if (sanitizedBags.some((bag) => !bag.name)) {
            toast.error('Toda mala precisa de um nome.');
            return;
        }

        const reservedKgValue = parseLocaleNumber(reservedKg.value);
        const reservedVolumeValue = parseLocaleNumber(reservedVolume.value);

        const payload = {
            reserved_kg: reservedKgValue !== null && reservedKgValue >= 0 ? Number(reservedKgValue) : 0,
            reserved_volume_liters:
                reservedVolumeValue !== null && reservedVolumeValue >= 0 ? Number(reservedVolumeValue) : 0,
            bags: sanitizedBags,
        };

        await axios.put(`/api/moves/${decisionStore.moveId}/config`, payload);

        toast.success('Configurações salvas com sucesso ✅');

        decisionStore.reservedKg = payload.reserved_kg;
        decisionStore.reservedVolumeCm3 = payload.reserved_volume_liters
            ? payload.reserved_volume_liters * 1000
            : 0;

        await Promise.allSettled([
            decisionStore.fetchResumo(),
            decisionStore.fetchPack(),
            decisionStore.fetchDeck(),
        ]);
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível salvar as configurações.');
    } finally {
        savingConfig.value = false;
    }
};

const handlePhotoCapture = (event) => {
    const file = event.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onloadend = () => {
        photo.value = reader.result?.toString() ?? '';
    };
    reader.readAsDataURL(file);
    photoFile.value = file;
};

const triggerFilePicker = () => {
    fileInput.value?.click();
};

const onVolumeInput = () => {
    if (!applyingCalculatedVolume.value) {
        volumeTouched.value = true;
    }
};

const applyCalculatedVolume = () => {
    if (!calculatedVolumeLiters.value || calculatedVolumeLiters.value <= 0) return;
    applyingCalculatedVolume.value = true;
    volumeLiters.value = calculatedVolumeLiters.value.toFixed(2);
    applyingCalculatedVolume.value = false;
    volumeTouched.value = true;
};

const resetForm = () => {
    photo.value = '';
    name.value = '';
    description.value = '';
    weight.value = '';
    volumeLiters.value = '';
    volumeTouched.value = false;
    length.value = '';
    width.value = '';
    height.value = '';
    category.value = '';
    fragile.value = false;
    photoFile.value = null;
};

const toggleFragile = () => {
    fragile.value = !fragile.value;
};

const calculatedVolumeCm3 = computed(() => {
    const values = [length.value, width.value, height.value].map((value) => parsePositiveNumber(value));
    if (values.some((value) => value === null)) {
        return null;
    }
    return values.reduce((acc, value) => acc * value, 1);
});

const calculatedVolumeLiters = computed(() => {
    if (!calculatedVolumeCm3.value) return null;
    return calculatedVolumeCm3.value / 1000;
});

const calculatedVolumeLitersDisplay = computed(() => {
    if (!calculatedVolumeLiters.value) return '';
    return calculatedVolumeLiters.value.toFixed(2);
});

const calculatedVolumeCm3Display = computed(() => {
    if (!calculatedVolumeCm3.value) return '';
    return new Intl.NumberFormat('pt-BR').format(Math.round(calculatedVolumeCm3.value));
});

watch(calculatedVolumeLiters, (newValue) => {
    if (!newValue || Number.isNaN(newValue) || newValue <= 0) {
        if (!volumeTouched.value) {
            volumeLiters.value = '';
        }
        return;
    }
    if (volumeTouched.value) return;
    applyingCalculatedVolume.value = true;
    volumeLiters.value = newValue.toFixed(2);
    applyingCalculatedVolume.value = false;
});

const handleSubmit = async () => {
    if (!name.value.trim()) {
        toast.error('Por favor, dê um nome ao item');
        return;
    }

    const weightKg = parsePositiveNumber(weight.value);

    if (!weightKg) {
        toast.error('Informe o peso estimado do item');
        return;
    }

    const manualVolumeLiters = parsePositiveNumber(volumeLiters.value);
    let volumeCm3 = manualVolumeLiters ? manualVolumeLiters * 1000 : null;

    if (!volumeCm3 && calculatedVolumeCm3.value) {
        volumeCm3 = calculatedVolumeCm3.value;
    }

    if (!volumeCm3 || volumeCm3 <= 0) {
        toast.error('Informe o volume aproximado em litros ou calcule a partir das dimensões.');
        return;
    }

    try {
        const volumeCm3Rounded = Math.round(volumeCm3 * 100) / 100;
        const notesValue = description.value?.trim() ? description.value.trim() : null;

        const payload = {
            title: name.value.trim(),
            notes: notesValue,
            weight_kg: Number(weightKg.toFixed(3)),
            volume_cm3: volumeCm3Rounded,
            category: category.value || null,
            fragile: fragile.value,
        };

        const item = await decisionStore.createItem(payload);

        if (photoFile.value) {
            try {
                await decisionStore.uploadMedia(item.id, photoFile.value);
            } catch (error) {
                console.error(error);
                toast.error('Item salvo, mas ocorreu um erro ao enviar a foto.');
            }
        }

        toast.success(`${payload.title} adicionado!`);
        resetForm();
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível salvar o item agora.');
    }
};
</script>
