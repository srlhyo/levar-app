<template>
    <Head title="Catalogar" />
    <AppLayout>
        <template #title>Catalogar</template>
        <template #subtitle>Tire fotos, estime peso e registre detalhes para cada item da mudança.</template>

        <section class="catalog-intro">
            <div class="catalog-intro__head">
                <TileIcon3D tone="emerald" class="catalog-intro__icon">
                    <Package class="h-5 w-5" />
                </TileIcon3D>
                <div>
                    <p class="catalog-eyebrow">Organização inicial</p>
                    <h2 class="catalog-intro__title">Organize os itens desde o primeiro clique</h2>
                    <p class="catalog-intro__subtitle">
                        Fotografe e registre detalhes em um ambiente calmo antes de enviar cada carta para o deck do Decidir.
                    </p>
                </div>
            </div>
            <div v-if="bagSummary.totalBags" class="catalog-intro__summary">
                <div class="catalog-intro__metric">
                    <span class="catalog-intro__metric-label">Malas configuradas</span>
                    <span class="catalog-intro__metric-value">{{ bagSummary.totalBags }}</span>
                </div>
                <div class="catalog-intro__metric">
                    <span class="catalog-intro__metric-label">Capacidade total</span>
                    <span class="catalog-intro__metric-value">{{ formatKgLabel(bagSummary.totalCapacityKg) }}</span>
                </div>
                <div class="catalog-intro__metric">
                    <span class="catalog-intro__metric-label">Peso reservado</span>
                    <span class="catalog-intro__metric-value">{{ formatKgLabel(bagSummary.reservedKg) }}</span>
                </div>
                <div class="catalog-intro__metric">
                    <span class="catalog-intro__metric-label">Volume reservado</span>
                    <span class="catalog-intro__metric-value">{{ formatLitersLabel(bagSummary.reservedVolumeLiters) }}</span>
                </div>
            </div>
            <p v-else class="catalog-intro__hint">
                Configure as malas abaixo para acompanhar peso e volume disponíveis enquanto adiciona novos itens.
            </p>
        </section>

        <section class="catalog-panel catalog-panel--config space-y-6">
            <div class="catalog-section__head">
                <TileIcon3D tone="teal" class="catalog-section__icon">
                    <Package class="h-5 w-5" />
                </TileIcon3D>
                <div>
                    <p class="catalog-eyebrow catalog-eyebrow--muted">Planejamento</p>
                    <h2 class="catalog-section__title">Configuração das malas</h2>
                    <p class="catalog-section__subtitle">
                        Defina quantas malas serão usadas, suas capacidades e o peso reservado para emergências.
                    </p>
                </div>
            </div>

            <div v-if="loadingConfig" class="catalog-panel__loading">
                <Loader2 class="h-4 w-4 animate-spin" /> Carregando malas...
            </div>

            <form v-else class="space-y-6" @submit.prevent="handleSaveConfig">
                <div class="grid gap-4 sm:grid-cols-2">
                    <label class="space-y-2">
                        <span class="catalog-field__label">Peso reservado (kg)</span>
                        <input
                            v-model="reservedKg"
                            type="number"
                            step="0.1"
                            min="0"
                            class="catalog-input"
                        />
                        <span class="catalog-field__help">Peso separado para imprevistos ou itens espontâneos.</span>
                    </label>
                    <label class="space-y-2">
                        <span class="catalog-field__label">Volume reservado (L)</span>
                        <input
                            v-model="reservedVolume"
                            type="number"
                            step="0.1"
                            min="0"
                            class="catalog-input"
                        />
                        <span class="catalog-field__help">Espaço reservado em litros (1 L = 1000 cm³).</span>
                    </label>
                </div>

                <div class="space-y-4">
                    <div class="flex items-center justify-between">
                        <span class="catalog-field__label">Malas cadastradas</span>
                        <button
                            type="button"
                            class="catalog-cta catalog-cta--emerald"
                            @click="addBag"
                        >
                            <Plus class="h-3.5 w-3.5" /> Adicionar mala
                        </button>
                    </div>

                    <div
                        v-for="(bag, index) in bags"
                        :key="bag.id ?? index"
                        class="catalog-bag-card"
                    >
                        <div class="flex flex-wrap items-center justify-between gap-3 border-b border-emerald-100 pb-3">
                            <div>
                                <p class="catalog-panel__label">Mala {{ index + 1 }}</p>
                                <p class="catalog-field__help">Capacidade planejada: {{ formatKgLabel(parseLocaleNumber(bag.capacity) ?? 0) }}</p>
                            </div>
                            <div class="flex flex-wrap gap-2">
                                <button
                                    type="button"
                                    class="catalog-chip catalog-chip--ghost"
                                    @click="duplicateBag(index)"
                                >
                                    Duplicar
                                </button>
                                <button
                                    type="button"
                                    class="catalog-chip catalog-chip--danger"
                                    :disabled="bags.length <= 1"
                                    @click="removeBag(index)"
                                >
                                    Remover
                                </button>
                            </div>
                        </div>
                        <div class="mt-3 grid gap-3 sm:grid-cols-2">
                            <label class="space-y-1">
                                <span class="catalog-field__label catalog-field__label--sm">Nome</span>
                                <input
                                    v-model="bag.name"
                                    required
                                    placeholder="Ex: Mala A"
                                    class="catalog-input"
                                    type="text"
                                />
                            </label>
                            <label class="space-y-1">
                                <span class="catalog-field__label catalog-field__label--sm">Código</span>
                                <input
                                    v-model="bag.code"
                                    placeholder="Opcional"
                                    class="catalog-input"
                                    type="text"
                                />
                            </label>
                            <label class="space-y-1">
                                <span class="catalog-field__label catalog-field__label--sm">Capacidade (kg)</span>
                                <input
                                    v-model="bag.capacity"
                                    type="number"
                                    step="0.1"
                                    min="0"
                                    placeholder="Ex: 23"
                                    class="catalog-input"
                                />
                            </label>
                            <label class="space-y-1">
                                <span class="catalog-field__label catalog-field__label--sm">Dimensões</span>
                                <input
                                    v-model="bag.dimensions"
                                    placeholder="Ex: 78 × 50 × 30 cm"
                                    class="catalog-input"
                                    type="text"
                                />
                                <span class="block text-[11px] text-slate-400">Use este campo apenas para referência visual.</span>
                            </label>
                        </div>
                    </div>
                </div>

                <div class="flex justify-end">
                    <button
                        type="submit"
                        class="catalog-submit catalog-submit--secondary"
                        :disabled="savingConfig"
                    >
                        <Loader2 v-if="savingConfig" class="h-4 w-4 animate-spin" />
                        <span>{{ savingConfig ? 'Salvando...' : 'Salvar configuração' }}</span>
                    </button>
                </div>
            </form>
        </section>

        <section class="catalog-panel catalog-panel--capture space-y-6">
            <div class="catalog-section__head catalog-section__head--split">
                <div class="catalog-section__intro">
                    <TileIcon3D tone="sky" class="catalog-section__icon">
                        <Camera class="h-5 w-5" />
                    </TileIcon3D>
                    <div>
                        <p class="catalog-eyebrow catalog-eyebrow--muted">Cadastro rápido</p>
                        <h2 class="catalog-section__title">Adicionar um novo item</h2>
                        <p class="catalog-section__subtitle">
                            Preencha as informações abaixo para manter o catálogo organizado e pronto para o Decidir.
                        </p>
                    </div>
                </div>
                <button
                    type="button"
                    class="catalog-accordion__trigger"
                    @click="showCatalogHelp = !showCatalogHelp"
                    :aria-expanded="showCatalogHelp ? 'true' : 'false'"
                >
                    <TileIcon3D tone="aqua" class="catalog-accordion__icon">
                        <Package class="h-4 w-4" />
                    </TileIcon3D>
                    <div class="text-left">
                        <p class="catalog-accordion__label">Guia rápido</p>
                        <p class="catalog-accordion__hint">Toque para ver as dicas essenciais</p>
                    </div>
                    <span class="catalog-accordion__chevron" :class="{ 'rotate-180': showCatalogHelp }">⌵</span>
                </button>
            </div>

            <transition name="fade">
                <div v-if="showCatalogHelp" class="catalog-accordion__body">
                    <p class="catalog-accordion__body-title">Dicas rápidas</p>
                    <ul class="catalog-accordion__list">
                        <li>Foto, nome e descrição viram a carta do Decidir — quanto mais contexto, melhor.</li>
                        <li>Pese ou estime em kg e informe o volume em litros (ou calcule pelas dimensões).</li>
                        <li>Use a descrição para lembrar acessórios, fragilidade ou onde o item está guardado.</li>
                    </ul>
                </div>
            </transition>
            <div class="catalog-capture-grid">
                <form class="space-y-6" @submit.prevent="handleSubmit">
                <div class="catalog-photo-field space-y-3">
                    <label class="catalog-field__label">Foto</label>

                    <div v-if="photo" class="catalog-photo-preview">
                        <img :src="photo" alt="Preview" class="h-56 w-full object-cover" />
                        <div class="catalog-photo-preview__actions">
                            <button
                                type="button"
                                class="catalog-chip catalog-chip--ghost"
                                @click="handleRemovePreview"
                            >
                                Remover
                            </button>
                            <button
                                type="button"
                                class="catalog-chip catalog-chip--primary"
                                @click="triggerFilePicker"
                            >
                                Adicionar outra
                            </button>
                        </div>
                    </div>

                    <button
                        v-else
                        type="button"
                        class="catalog-upload-dropzone"
                        @click="triggerFilePicker"
                    >
                        <div class="catalog-upload-dropzone__content">
                            <Camera class="h-8 w-8 text-sky-500" />
                            <span class="catalog-upload-dropzone__title">Adicionar foto do item</span>
                            <span class="catalog-upload-dropzone__hint">
                                Capture várias fotos em sequência; elas entram na fila ao lado.
                            </span>
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

                    <div
                        v-if="photoQueue.length"
                        class="catalog-photo-queue"
                    >
                        <div class="catalog-photo-queue__head">
                            <span class="catalog-photo-queue__title">Fila de fotos ({{ photoQueue.length }})</span>
                            <button
                                type="button"
                                class="catalog-link catalog-link--danger"
                                @click="clearPhotoQueue"
                            >
                                Limpar fila
                            </button>
                        </div>
                        <div class="catalog-photo-queue__list">
                            <div
                                v-for="entry in photoQueue"
                                :key="entry.id"
                                class="catalog-photo-queue__item"
                                :class="entry.id === currentPhotoId ? 'catalog-photo-queue__item--active' : ''"
                            >
                                <span
                                    v-if="entry.id === currentPhotoId"
                                    class="catalog-photo-queue__badge"
                                >
                                    Em uso
                                </span>
                                <img :src="entry.preview" alt="Fila" class="h-16 w-full rounded-xl object-cover" />
                                <div class="catalog-photo-queue__actions">
                                    <button type="button" class="catalog-link" @click="setCurrentPhoto(entry.id)">Usar</button>
                                    <button type="button" class="catalog-link catalog-link--danger" @click="removeQueueEntry(entry.id)">Excluir</button>
                                </div>
                            </div>
                        </div>
                        <div v-if="photo" class="catalog-photo-queue__detail">
                            <p class="catalog-photo-queue__detail-title">Foto selecionada</p>
                            <img :src="photo" alt="Selecionada" class="h-32 w-full rounded-xl object-cover" />
                        </div>
                    </div>
                </div>

                <div class="grid gap-4 sm:grid-cols-2">
                    <label class="space-y-2">
                        <span class="catalog-field__label">Nome do item *</span>
                        <input
                            v-model="name"
                            required
                            placeholder="Ex: Livros de cozinha"
                            class="catalog-input"
                            type="text"
                        />
                    </label>

                    <label class="space-y-2">
                        <span class="catalog-field__label">Peso estimado (kg)</span>
                        <input
                            v-model="weight"
                            step="0.1"
                            placeholder="0.0"
                            class="catalog-input"
                            type="number"
                        />
                    </label>
                </div>

                <label class="space-y-2">
                    <span class="catalog-field__label">Descrição / notas</span>
                    <textarea
                        v-model="description"
                        rows="3"
                        placeholder="Inclua detalhes, estado ou observações importantes"
                        class="catalog-textarea"
                    ></textarea>
                    <span class="catalog-field__help">Essas notas aparecem nas cartas do Decidir e ajudam a lembrar detalhes.</span>
                </label>

                <div class="catalog-utility-card space-y-2">
                    <div class="flex flex-wrap items-center justify-between gap-2">
                        <p class="catalog-panel__label">Modelos rápidos</p>
                        <button
                            type="button"
                            class="catalog-chip catalog-chip--ghost"
                            @click="saveTemplateFromCurrent"
                        >
                            Salvar modelo atual
                        </button>
                    </div>
                    <div class="flex flex-wrap gap-2">
                        <button
                            v-for="template in templates"
                            :key="template.id"
                            type="button"
                            class="catalog-template"
                            @click="applyTemplate(template)"
                        >
                            {{ template.name }}
                            <span
                                class="catalog-template__remove"
                                @click.stop="removeTemplate(template.id)"
                            >×</span>
                        </button>
                        <p v-if="!templates.length" class="catalog-field__help">Nenhum modelo salvo ainda.</p>
                    </div>
                </div>

                <label class="space-y-2">
                    <span class="catalog-field__label">Volume estimado (litros)</span>
                    <input
                        v-model="volumeLiters"
                        @input="onVolumeInput"
                        min="0"
                        step="0.01"
                        placeholder="Ex.: 12,5"
                        class="catalog-input"
                        type="number"
                    />
                    <p class="catalog-field__help">
                        Informe o volume aproximado em litros. As dimensões abaixo são opcionais e servem apenas para sugerir um valor.
                    </p>
                    <button
                        v-if="calculatedVolumeLitersDisplay"
                        type="button"
                        class="catalog-chip catalog-chip--primary"
                        @click="applyCalculatedVolume"
                    >
                        Usar {{ calculatedVolumeLitersDisplay }} L calculados
                    </button>
                </label>

                <div class="space-y-2">
                    <div class="flex items-center justify-between">
                        <span class="catalog-field__label">Dimensões (cm) — opcional</span>
                        <button
                            type="button"
                            class="catalog-link"
                            @click="showDimensionHelper = !showDimensionHelper"
                        >
                            {{ showDimensionHelper ? 'Esconder' : 'Calcular automaticamente' }}
                        </button>
                    </div>
                    <transition name="fade">
                        <div v-if="showDimensionHelper" class="grid grid-cols-3 gap-3">
                                <input
                                    v-model="length"
                                    min="0"
                                    placeholder="Compr."
                                    class="catalog-input"
                                type="number"
                            />
                                <input
                                    v-model="width"
                                    min="0"
                                    placeholder="Larg."
                                    class="catalog-input"
                                type="number"
                            />
                                <input
                                    v-model="height"
                                    min="0"
                                    placeholder="Alt."
                                    class="catalog-input"
                                type="number"
                            />
                        </div>
                    </transition>
                    <p class="catalog-field__help">Preencha em centímetros se quiser sugerir automaticamente o volume. Ex.: 55 × 40 × 23</p>
                    <p v-if="calculatedVolumeCm3" class="catalog-field__help">
                        Volume calculado:
                        <span class="font-semibold text-slate-700">{{ calculatedVolumeLitersDisplay }} L</span>
                        ({{ calculatedVolumeCm3Display }} cm³)
                    </p>
                </div>

                <div class="grid gap-4 sm:grid-cols-2">
                    <div class="space-y-2">
                        <span class="catalog-field__label">Categoria</span>
                        <div class="flex flex-wrap gap-2">
                            <button
                                v-for="option in categoryOptions"
                                :key="option"
                                type="button"
                                class="catalog-category"
                                :class="{ 'catalog-category--active': category === option }"
                                @click="selectCategory(option)"
                            >
                                {{ option }}
                            </button>
                        </div>
                        <input
                            v-model="category"
                            type="text"
                            placeholder="Ou digite uma categoria personalizada"
                            class="catalog-input"
                        />
                    </div>

                    <label class="space-y-2">
                        <span class="catalog-field__label">Fragilidade</span>
                        <div class="catalog-fragile-toggle">
                            <span class="catalog-field__label catalog-field__label--sm">Item frágil?</span>
                            <button
                                type="button"
                                class="catalog-switch"
                                :class="{ 'catalog-switch--on': fragile }"
                                @click="toggleFragile"
                            >
                                <span
                                    class="catalog-switch__thumb"
                                    :class="{ 'catalog-switch__thumb--on': fragile }"
                                />
                            </button>
                        </div>
                    </label>
                </div>

                    <div class="flex justify-end">
                        <button
                            type="submit"
                            class="catalog-submit"
                            :disabled="submittingItem"
                        >
                            <Loader2 v-if="submittingItem" class="h-4 w-4 animate-spin" />
                            <Plus v-else class="h-4 w-4" />
                            <span>{{ submittingItem ? 'Adicionando...' : 'Adicionar item' }}</span>
                        </button>
                    </div>
                </form>
                <div class="catalog-preview">
                    <div class="catalog-preview__head">
                        <p class="catalog-preview__title">Prévia da carta</p>
                        <p class="catalog-field__help">Veja como esse item aparecerá no Decidir antes de salvar.</p>
                    </div>
                    <div class="catalog-preview__card">
                        <div
                            class="catalog-preview__photo"
                            :style="previewCard.photo ? { backgroundImage: `url(${previewCard.photo})`, backgroundSize: 'cover', backgroundPosition: 'center' } : {}"
                        >
                            <div
                                v-if="!previewCard.photo"
                                class="catalog-preview__photo-empty"
                            >
                                <Camera class="h-8 w-8 text-white/70" />
                            </div>
                            <span
                                v-if="previewCard.fragile"
                                class="catalog-preview__badge"
                            >
                                ⚠️ Frágil
                            </span>
                        </div>
                        <div class="catalog-preview__body">
                            <p class="catalog-preview__name">
                                {{ previewCard.title || 'Item sem nome ainda' }}
                            </p>
                            <p class="catalog-preview__notes">
                                {{ previewCard.notes || 'Use o campo de descrição para contar a história do item.' }}
                            </p>
                            <div class="catalog-preview__tags">
                                <span class="catalog-preview__pill">
                                    ⚖️ {{ previewCard.weightLabel }}
                                </span>
                                <span class="catalog-preview__pill">
                                    🧊 {{ previewCard.volumeLabel }}
                                </span>
                            </div>
                            <p class="catalog-preview__meta">
                                🏷️ {{ previewCard.category || 'Sem categoria' }}
                            </p>
                        </div>
                    </div>
                    <p class="catalog-field__help">Dica: fotos bem iluminadas e títulos específicos deixam o baralho muito mais agradável.</p>
                </div>
            </div>
        </section>
    </AppLayout>
</template>

<script setup>
import axios from 'axios';
import { Head, usePage } from '@inertiajs/vue3';
import { computed, onMounted, ref, watch, watchEffect } from 'vue';
import { Camera, Loader2, Package, Plus } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import TileIcon3D from '@/Components/home/TileIcon3D.vue';
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
const showCatalogHelp = ref(false);
const submittingItem = ref(false);
const showDimensionHelper = ref(false);
const categoryOptions = ['Documentos', 'Roupas', 'Eletrônicos', 'Souvenires', 'Outros'];
const photoQueue = ref([]);
const currentPhotoId = ref(null);
const TEMPLATE_KEY = 'catalog_templates';
const templates = ref(loadTemplates());

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

const formatKgLabel = (value) => `${Number(value ?? 0).toFixed(1)} kg`;
const formatLitersLabel = (value) => `${Number(value ?? 0).toFixed(1)} L`;

function loadTemplates() {
    try {
        const stored = localStorage.getItem(TEMPLATE_KEY);
        if (stored) {
            return JSON.parse(stored);
        }
    } catch (error) {
        console.warn('Não foi possível carregar templates salvos', error);
    }

    return [
        {
            id: 'template-default-livros',
            name: 'Livros leves',
            weight_kg: 0.9,
            volume_liters: 4,
            category: 'Documentos',
            fragile: false,
        },
        {
            id: 'template-default-eletr',
            name: 'Eletrônicos delicados',
            weight_kg: 1.2,
            volume_liters: 3,
            category: 'Eletrônicos',
            fragile: true,
        },
    ];
}

const persistTemplates = () => {
    try {
        localStorage.setItem(TEMPLATE_KEY, JSON.stringify(templates.value));
    } catch (error) {
        console.warn('Não foi possível salvar templates', error);
    }
};

const reservedKg = ref(0);
const reservedVolume = ref('');
const bags = ref([]);
const loadingConfig = ref(false);
const savingConfig = ref(false);
const bagSummary = computed(() => {
    const totalBags = bags.value.length;
    const totalCapacityKg = bags.value.reduce((sum, bag) => {
        const parsed = parseLocaleNumber(bag.capacity);
        return sum + (parsed ?? 0);
    }, 0);
    const reservedKgValue = parseLocaleNumber(reservedKg.value) ?? 0;
    const reservedVolumeLiters = parseLocaleNumber(reservedVolume.value) ?? 0;

    return {
        totalBags,
        totalCapacityKg,
        reservedKg: reservedKgValue,
        reservedVolumeLiters,
        remainingKg: Math.max(totalCapacityKg - reservedKgValue, 0),
    };
});

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

const enqueuePhoto = (file) => {
    if (!file) return;
    const id = `${Date.now()}-${Math.random().toString(16).slice(2)}`;
    const reader = new FileReader();
    reader.onloadend = () => {
        const entry = {
            id,
            preview: reader.result?.toString() ?? '',
            file,
            name: file.name,
        };
        photoQueue.value.push(entry);
        setCurrentPhoto(entry.id);
    };
    reader.readAsDataURL(file);
};

const setCurrentPhoto = (id) => {
    const entry = photoQueue.value.find((item) => item.id === id);
    if (!entry) {
        currentPhotoId.value = null;
        photo.value = '';
        photoFile.value = null;
        return;
    }
    currentPhotoId.value = entry.id;
    photo.value = entry.preview;
    photoFile.value = entry.file;
};

const removeQueueEntry = (id) => {
    const index = photoQueue.value.findIndex((item) => item.id === id);
    if (index === -1) return;
    photoQueue.value.splice(index, 1);
    if (currentPhotoId.value === id) {
        const next = photoQueue.value[index] ?? photoQueue.value[index - 1];
        setCurrentPhoto(next?.id ?? null);
    }
};

const clearPhotoQueue = () => {
    photoQueue.value = [];
    setCurrentPhoto(null);
};
const handleRemovePreview = () => {
    if (currentPhotoId.value) {
        removeQueueEntry(currentPhotoId.value);
    } else {
        photo.value = '';
        photoFile.value = null;
    }
};

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

const duplicateBag = (index) => {
    const source = bags.value[index];
    if (!source) return;
    const copy = {
        ...blankBag(),
        name: source.name ? `${source.name} (cópia)` : '',
        code: source.code ? `${source.code}-2` : '',
        capacity: source.capacity,
        dimensions: source.dimensions,
    };
    bags.value.splice(index + 1, 0, copy);
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
    enqueuePhoto(file);
    event.target.value = '';
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
    showDimensionHelper.value = false;
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

watch([length, width, height], (values) => {
    if (values.some((value) => value)) {
        showDimensionHelper.value = true;
    }
});

const selectCategory = (value) => {
    category.value = value;
};

const handleSubmit = async () => {
    if (submittingItem.value) return;
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

    submittingItem.value = true;
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
        if (currentPhotoId.value) {
            removeQueueEntry(currentPhotoId.value);
        }
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível salvar o item agora.');
    } finally {
        submittingItem.value = false;
    }
};

const applyTemplate = (template) => {
    if (!template) return;
    if (template.weight_kg) {
        weight.value = Number(template.weight_kg).toString();
    }
    if (template.volume_liters) {
        volumeLiters.value = Number(template.volume_liters).toString();
        volumeTouched.value = true;
    }
    category.value = template.category ?? '';
    fragile.value = Boolean(template.fragile);
    toast.info(`Modelo "${template.name}" aplicado`);
};

const saveTemplateFromCurrent = () => {
    if (!name.value.trim()) {
        toast.error('Dê um nome ao modelo usando o campo do item.');
        return;
    }
    const template = {
        id: `tpl-${Date.now()}`,
        name: name.value.trim(),
        weight_kg: parseLocaleNumber(weight.value) ?? undefined,
        volume_liters: parseLocaleNumber(volumeLiters.value) ?? undefined,
        category: category.value || null,
        fragile: fragile.value,
    };
    templates.value.push(template);
    persistTemplates();
    toast.success('Modelo salvo!');
};

const removeTemplate = (id) => {
    templates.value = templates.value.filter((template) => template.id !== id);
    persistTemplates();
};

const previewCard = computed(() => {
    const parsedWeight = parseLocaleNumber(weight.value);
    const weightLabel = formatKgLabel(parsedWeight ?? 0);
    const manualVolume = parseLocaleNumber(volumeLiters.value);
    const volumeLabel = manualVolume != null
        ? formatLitersLabel(manualVolume)
        : (calculatedVolumeLitersDisplay.value || '0.0') + ' L';

    return {
        title: name.value.trim(),
        notes: description.value.trim(),
        category: category.value.trim(),
        fragile: fragile.value,
        photo: photo.value,
        weightLabel,
        volumeLabel,
    };
});

watch(photoQueue, (queue) => {
    if (!queue.length) {
        setCurrentPhoto(null);
        return;
    }
    if (!currentPhotoId.value || !queue.some((entry) => entry.id === currentPhotoId.value)) {
        setCurrentPhoto(queue[0].id);
    }
}, { deep: true });

</script>

<style scoped>
.catalog-intro {
    position: relative;
    margin-bottom: 1.75rem;
    border-radius: 1.9rem;
    padding: 1.75rem;
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.16), rgba(45, 212, 191, 0.12), rgba(59, 130, 246, 0.12));
    border: 1px solid rgba(45, 212, 191, 0.35);
    box-shadow: 0 30px 65px rgba(15, 118, 110, 0.15);
    overflow: hidden;
}
.catalog-intro::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: radial-gradient(circle at 10% 0%, rgba(209, 250, 229, 0.85), transparent 55%);
    pointer-events: none;
}
.catalog-intro__head {
    display: flex;
    gap: 1rem;
    align-items: center;
    position: relative;
    z-index: 1;
}
.catalog-intro__icon {
    --tile-icon-size: 3.4rem;
}
.catalog-eyebrow {
    font-size: 0.75rem;
    letter-spacing: 0.35em;
    font-weight: 600;
    text-transform: uppercase;
    color: #14b8a6;
}
.catalog-eyebrow--muted {
    color: #0f766e;
}
.catalog-intro__title {
    font-size: 1.7rem;
    font-weight: 600;
    color: #022c22;
}
.catalog-intro__subtitle {
    margin-top: 0.35rem;
    font-size: 0.95rem;
    color: #0f172a;
}
.catalog-intro__summary {
    position: relative;
    z-index: 1;
    margin-top: 1.5rem;
    display: grid;
    gap: 0.75rem;
    grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
}
.catalog-intro__metric {
    border-radius: 1.35rem;
    padding: 1rem;
    border: 1px solid rgba(45, 212, 191, 0.35);
    background: rgba(255, 255, 255, 0.9);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.7);
}
.catalog-intro__metric-label {
    font-size: 0.78rem;
    font-weight: 600;
    color: #047857;
    text-transform: uppercase;
    letter-spacing: 0.2em;
}
.catalog-intro__metric-value {
    display: block;
    margin-top: 0.35rem;
    font-size: 1.1rem;
    font-weight: 600;
    color: #022c22;
}
.catalog-intro__hint {
    margin-top: 1.25rem;
    font-size: 0.9rem;
    color: #0f172a;
    position: relative;
    z-index: 1;
}

.catalog-panel {
    position: relative;
    border-radius: 1.9rem;
    padding: 1.75rem;
    background: rgba(255, 255, 255, 0.96);
    border: 1px solid rgba(148, 163, 184, 0.25);
    box-shadow: 0 30px 60px rgba(15, 23, 42, 0.08);
    overflow: hidden;
}
.catalog-panel::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    pointer-events: none;
    background: radial-gradient(circle at 90% 0%, rgba(240, 255, 244, 0.8), transparent 60%);
}
.catalog-panel > * {
    position: relative;
    z-index: 1;
}
.catalog-panel--capture::before {
    background: radial-gradient(circle at 85% 0%, rgba(219, 234, 254, 0.9), transparent 60%);
}
.catalog-panel--config::before {
    background: radial-gradient(circle at 10% 0%, rgba(187, 247, 208, 0.85), transparent 55%);
}
.catalog-section__head {
    display: flex;
    gap: 1rem;
    align-items: flex-start;
}
.catalog-section__head--split {
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 1rem;
}
.catalog-section__intro {
    display: flex;
    gap: 1rem;
    align-items: center;
}
.catalog-section__icon {
    --tile-icon-size: 3.1rem;
    animation: catalogFloat 10s ease-in-out infinite;
}
.catalog-section__title {
    font-size: 1.4rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-section__subtitle {
    font-size: 0.95rem;
    color: #475569;
}
.catalog-panel__loading {
    display: inline-flex;
    gap: 0.5rem;
    align-items: center;
    border-radius: 1.25rem;
    background: rgba(240, 253, 244, 0.85);
    padding: 0.85rem 1.25rem;
    color: #0f766e;
    font-weight: 600;
}
.catalog-field__label {
    font-size: 0.9rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-field__label--sm {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.25em;
    color: #0f766e;
}
.catalog-field__help {
    font-size: 0.78rem;
    color: #64748b;
    display: block;
}
.catalog-panel__label {
    font-size: 0.95rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-input,
.catalog-textarea {
    width: 100%;
    border-radius: 1.25rem;
    border: 1px solid rgba(16, 185, 129, 0.25);
    background: rgba(255, 255, 255, 0.92);
    padding: 0.65rem 0.95rem;
    font-size: 0.95rem;
    color: #0f172a;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.7),
        0 12px 25px rgba(15, 23, 42, 0.05);
    transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
}
.catalog-input:focus,
.catalog-textarea:focus {
    outline: none;
    border-color: rgba(16, 185, 129, 0.5);
    box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
}
.catalog-textarea {
    min-height: 110px;
    resize: vertical;
}
.catalog-panel__section-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.catalog-cta {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    border-radius: 999px;
    padding: 0.5rem 1.2rem;
    font-size: 0.78rem;
    font-weight: 600;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.catalog-cta:active {
    transform: scale(0.97);
}
.catalog-cta--emerald {
    color: white;
    background: linear-gradient(135deg, rgba(5, 150, 105, 1), rgba(16, 185, 129, 0.95));
    box-shadow: 0 15px 30px rgba(16, 185, 129, 0.3);
}
.catalog-bag-card {
    border-radius: 1.5rem;
    border: 1px solid rgba(16, 185, 129, 0.25);
    background: rgba(255, 255, 255, 0.95);
    box-shadow: 0 25px 45px rgba(15, 23, 42, 0.08);
    padding: 1.2rem;
}
.catalog-utility-card {
    border-radius: 1.5rem;
    border: 1px solid rgba(148, 163, 184, 0.25);
    background: rgba(255, 255, 255, 0.92);
    padding: 1rem 1.2rem;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.7);
}
.catalog-bag-card__title {
    font-size: 1rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-bag-card__meta {
    font-size: 0.8rem;
    color: #475569;
}
.catalog-chip {
    display: inline-flex;
    align-items: center;
    border-radius: 999px;
    padding: 0.35rem 0.9rem;
    font-size: 0.75rem;
    font-weight: 600;
    border: 1px solid transparent;
    transition: background 0.2s ease, color 0.2s ease;
}
.catalog-chip--ghost {
    border-color: rgba(45, 212, 191, 0.4);
    color: #047857;
    background: rgba(240, 253, 250, 0.9);
}
.catalog-chip--danger {
    border-color: rgba(248, 113, 113, 0.4);
    color: #b91c1c;
    background: rgba(254, 242, 242, 0.9);
}
.catalog-chip--primary {
    border-color: rgba(59, 130, 246, 0.4);
    color: #1d4ed8;
    background: rgba(239, 246, 255, 0.95);
}
.catalog-template {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    border-radius: 999px;
    border: 1px solid rgba(125, 211, 252, 0.4);
    background: rgba(240, 253, 244, 0.85);
    color: #036666;
    font-size: 0.78rem;
    font-weight: 600;
    padding: 0.35rem 0.9rem;
    transition: background 0.2s ease, color 0.2s ease;
}
.catalog-template:hover {
    background: rgba(187, 247, 208, 0.9);
}
.catalog-template__remove {
    font-size: 0.75rem;
    color: #0f766e;
    cursor: pointer;
    transition: color 0.2s ease;
}
.catalog-template__remove:hover {
    color: #b91c1c;
}
.catalog-category {
    border-radius: 999px;
    border: 1px solid rgba(148, 163, 184, 0.35);
    padding: 0.35rem 0.9rem;
    font-size: 0.78rem;
    font-weight: 600;
    color: #475569;
    background: rgba(255, 255, 255, 0.95);
    transition: all 0.2s ease;
}
.catalog-category--active {
    color: #065f46;
    border-color: rgba(16, 185, 129, 0.45);
    background: rgba(209, 250, 229, 0.9);
    box-shadow: 0 12px 25px rgba(16, 185, 129, 0.2);
}
.catalog-fragile-toggle {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.65rem 1rem;
    border-radius: 1.25rem;
    border: 1px solid rgba(148, 163, 184, 0.3);
    background: rgba(248, 250, 252, 0.9);
}
.catalog-switch {
    position: relative;
    width: 48px;
    height: 24px;
    border-radius: 999px;
    background: rgba(148, 163, 184, 0.5);
    transition: background 0.2s ease;
}
.catalog-switch--on {
    background: linear-gradient(120deg, rgba(245, 158, 11, 0.9), rgba(250, 204, 21, 0.9));
}
.catalog-switch__thumb {
    position: absolute;
    top: 2px;
    left: 3px;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: white;
    box-shadow: 0 5px 10px rgba(15, 23, 42, 0.1);
    transition: transform 0.2s ease;
}
.catalog-switch__thumb--on {
    transform: translateX(22px);
}
.catalog-submit {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    border-radius: 1.6rem;
    padding: 0.65rem 1.6rem;
    font-size: 0.9rem;
    font-weight: 600;
    color: white;
    background: linear-gradient(120deg, rgba(15, 118, 110, 1), rgba(6, 182, 212, 0.95));
    box-shadow: 0 20px 35px rgba(6, 182, 212, 0.25);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.catalog-submit:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}
.catalog-submit:active {
    transform: scale(0.98);
}
.catalog-capture-grid {
    display: grid;
    gap: 1.5rem;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
}
.catalog-photo-field {
    position: relative;
}
.catalog-photo-preview {
    position: relative;
    overflow: hidden;
    border-radius: 1.5rem;
    border: 1px solid rgba(45, 212, 191, 0.4);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.6),
        0 18px 35px rgba(16, 185, 129, 0.18);
}
.catalog-photo-preview__actions {
    position: absolute;
    inset: 0.9rem;
    display: flex;
    justify-content: flex-end;
    gap: 0.5rem;
    align-items: flex-start;
    flex-wrap: wrap;
}
.catalog-upload-dropzone {
    width: 100%;
    border: 2px dashed rgba(16, 185, 129, 0.5);
    border-radius: 1.7rem;
    background: rgba(236, 253, 245, 0.8);
    padding: 2.5rem 1.5rem;
    color: #0f172a;
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}
.catalog-upload-dropzone:hover {
    border-color: rgba(45, 212, 191, 0.8);
    box-shadow: 0 20px 35px rgba(16, 185, 129, 0.25);
}
.catalog-upload-dropzone__content {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.35rem;
    text-align: center;
}
.catalog-upload-dropzone__title {
    font-size: 0.95rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-upload-dropzone__hint {
    font-size: 0.8rem;
    color: #475569;
}
.catalog-photo-queue {
    border-radius: 1.6rem;
    border: 1px solid rgba(125, 211, 252, 0.4);
    background: rgba(255, 255, 255, 0.9);
    padding: 1rem;
    font-size: 0.8rem;
    color: #475569;
}
.catalog-photo-queue__head {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.catalog-photo-queue__title {
    font-size: 0.9rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-link {
    font-size: 0.75rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-link--danger {
    color: #b91c1c;
}
.catalog-photo-queue__list {
    display: flex;
    gap: 0.75rem;
    overflow-x: auto;
    padding: 0.5rem 0;
}
.catalog-photo-queue__item {
    position: relative;
    width: 5.8rem;
    border-radius: 1.3rem;
    padding: 0.4rem;
    border: 1px solid rgba(148, 163, 184, 0.3);
    background: rgba(255, 255, 255, 0.95);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6);
}
.catalog-photo-queue__item--active {
    border-color: rgba(14, 165, 233, 0.6);
    box-shadow: 0 12px 25px rgba(14, 165, 233, 0.2);
}
.catalog-photo-queue__badge {
    position: absolute;
    left: 0.4rem;
    top: 0.4rem;
    border-radius: 999px;
    background: rgba(16, 185, 129, 0.15);
    padding: 0.15rem 0.5rem;
    font-size: 0.6rem;
    font-weight: 600;
    color: #047857;
}
.catalog-photo-queue__actions {
    display: flex;
    justify-content: space-between;
    gap: 0.25rem;
    margin-top: 0.35rem;
}
.catalog-photo-queue__detail {
    margin-top: 0.75rem;
    border-radius: 1.2rem;
    border: 1px solid rgba(16, 185, 129, 0.35);
    background: rgba(222, 247, 236, 0.7);
    padding: 0.75rem;
}
.catalog-photo-queue__detail-title {
    font-size: 0.75rem;
    font-weight: 600;
    color: #0f172a;
    margin-bottom: 0.4rem;
}
.catalog-preview {
    border-radius: 1.9rem;
    border: 1px solid rgba(148, 163, 184, 0.25);
    background: rgba(255, 255, 255, 0.92);
    padding: 1.4rem;
    box-shadow: 0 28px 55px rgba(15, 23, 42, 0.08);
}
.catalog-preview__head {
    margin-bottom: 0.75rem;
}
.catalog-preview__title {
    font-size: 1rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-preview__card {
    border-radius: 1.6rem;
    border: 1px solid rgba(148, 163, 184, 0.2);
    background: radial-gradient(circle at 20% -10%, rgba(167, 243, 208, 0.4), transparent 55%), rgba(255, 255, 255, 0.96);
    padding: 1rem;
    box-shadow: 0 30px 50px rgba(15, 118, 110, 0.12);
}
.catalog-preview__photo {
    border-radius: 1.2rem;
    height: 180px;
    background-size: cover;
    background-position: center;
    background-color: rgba(226, 232, 240, 0.8);
    position: relative;
    overflow: hidden;
    margin-bottom: 0.85rem;
}
.catalog-preview__photo-empty {
    display: flex;
    height: 100%;
    width: 100%;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.5), rgba(45, 212, 191, 0.35));
}
.catalog-preview__badge {
    position: absolute;
    left: 0.85rem;
    top: 0.85rem;
    border-radius: 999px;
    background: rgba(251, 146, 60, 0.85);
    color: white;
    padding: 0.2rem 0.65rem;
    font-size: 0.72rem;
    font-weight: 600;
    box-shadow: 0 10px 20px rgba(251, 146, 60, 0.2);
}
.catalog-preview__body {
    display: grid;
    gap: 0.4rem;
}
.catalog-preview__name {
    font-size: 1.1rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-preview__notes {
    font-size: 0.9rem;
    color: #475569;
}
.catalog-preview__tags {
    display: flex;
    gap: 0.4rem;
    flex-wrap: wrap;
}
.catalog-preview__pill {
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.85);
    border: 1px solid rgba(148, 163, 184, 0.35);
    padding: 0.3rem 0.75rem;
    font-size: 0.8rem;
    font-weight: 600;
    color: #0f172a;
}
.catalog-preview__meta {
    font-size: 0.85rem;
    color: #475569;
}
.catalog-submit--secondary {
    background: linear-gradient(120deg, rgba(45, 212, 191, 0.95), rgba(16, 185, 129, 0.95));
    box-shadow: 0 18px 30px rgba(16, 185, 129, 0.25);
}
.catalog-accordion__trigger {
    flex: 1;
    border-radius: 1.5rem;
    border: 1px solid rgba(59, 130, 246, 0.25);
    background: rgba(248, 250, 252, 0.95);
    padding: 0.75rem 1rem;
    display: flex;
    align-items: center;
    gap: 0.65rem;
    font-weight: 600;
    color: #0f172a;
    box-shadow: 0 18px 35px rgba(59, 130, 246, 0.15);
    transition: box-shadow 0.2s ease, transform 0.2s ease;
}
.catalog-accordion__trigger:active {
    transform: scale(0.98);
}
.catalog-accordion__icon {
    --tile-icon-size: 2.6rem;
}
.catalog-accordion__label {
    font-size: 0.85rem;
    font-weight: 700;
    color: #0f172a;
}
.catalog-accordion__hint {
    font-size: 0.75rem;
    color: #475569;
}
.catalog-accordion__chevron {
    margin-left: auto;
    font-size: 1rem;
    transition: transform 0.2s ease;
    color: #475569;
}
.catalog-accordion__body {
    border-radius: 1.4rem;
    border: 1px solid rgba(148, 163, 184, 0.3);
    background: rgba(255, 255, 255, 0.92);
    padding: 1rem 1.2rem;
    font-size: 0.85rem;
    color: #475569;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6);
}
.catalog-accordion__body-title {
    font-size: 0.9rem;
    font-weight: 700;
    color: #0f172a;
    margin-bottom: 0.4rem;
}
.catalog-accordion__list {
    list-style: disc;
    padding-left: 1.25rem;
    display: grid;
    gap: 0.35rem;
}
.catalog-capture-grid form {
    background: rgba(255, 255, 255, 0.9);
}
@keyframes catalogFloat {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-4px);
    }
}
</style>
