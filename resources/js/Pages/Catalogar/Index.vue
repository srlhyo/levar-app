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

            <div
                v-if="bagSummary.totalBags"
                class="grid gap-2 rounded-2xl bg-white/70 p-3 text-xs text-slate-600 ring-1 ring-emerald-50 sm:grid-cols-4 sm:text-sm"
            >
                <div>
                    <p class="text-[11px] font-semibold uppercase tracking-wide text-emerald-500">Malas</p>
                    <p class="text-base font-semibold text-slate-900">{{ bagSummary.totalBags }}</p>
                </div>
                <div>
                    <p class="text-[11px] font-semibold uppercase tracking-wide text-emerald-500">Capacidade total</p>
                    <p class="text-base font-semibold text-slate-900">{{ formatKgLabel(bagSummary.totalCapacityKg) }}</p>
                </div>
                <div>
                    <p class="text-[11px] font-semibold uppercase tracking-wide text-emerald-500">Peso reservado</p>
                    <p class="text-base font-semibold text-slate-900">{{ formatKgLabel(bagSummary.reservedKg) }}</p>
                </div>
                <div>
                    <p class="text-[11px] font-semibold uppercase tracking-wide text-emerald-500">Volume reservado</p>
                    <p class="text-base font-semibold text-slate-900">{{ formatLitersLabel(bagSummary.reservedVolumeLiters) }}</p>
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
                        <div class="flex flex-wrap items-center justify-between gap-3 border-b border-emerald-100 pb-3">
                            <div>
                                <p class="text-sm font-semibold text-slate-800">Mala {{ index + 1 }}</p>
                                <p class="text-xs text-slate-500">Capacidade planejada: {{ formatKgLabel(parseLocaleNumber(bag.capacity) ?? 0) }}</p>
                            </div>
                            <div class="flex flex-wrap gap-2">
                                <button
                                    type="button"
                                    class="inline-flex items-center rounded-full border border-emerald-200 px-3 py-1 text-xs font-semibold text-emerald-700 transition hover:bg-emerald-50"
                                    @click="duplicateBag(index)"
                                >
                                    Duplicar
                                </button>
                                <button
                                    type="button"
                                    class="inline-flex items-center rounded-full border border-rose-200 px-3 py-1 text-xs font-semibold text-rose-600 transition hover:bg-rose-50 disabled:opacity-40"
                                    :disabled="bags.length <= 1"
                                    @click="removeBag(index)"
                                >
                                    Remover
                                </button>
                            </div>
                        </div>
                        <div class="mt-3 grid gap-3 sm:grid-cols-2">
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
                                <span class="block text-[11px] text-slate-400">Use este campo apenas para referência visual.</span>
                            </label>
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
            <div class="flex flex-wrap items-start justify-between gap-3">
                <div class="flex items-start gap-3">
                    <IconPill tone="blue">
                        <Camera class="h-6 w-6" />
                    </IconPill>
                    <div class="space-y-1">
                        <h2 class="text-lg font-semibold text-slate-800 sm:text-xl">Adicionar um novo item</h2>
                        <p class="text-sm text-slate-600 sm:text-base">Preencha as informações abaixo para manter o catálogo organizado.</p>
                    </div>
                </div>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-white/80 px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-sky-300"
                    @click="showCatalogHelp = !showCatalogHelp"
                    :aria-expanded="showCatalogHelp ? 'true' : 'false'"
                >
                    <span class="inline-flex h-5 w-5 items-center justify-center rounded-full bg-sky-500/15 text-[11px] font-semibold text-sky-600">?</span>
                    Como funciona
                </button>
            </div>

            <transition name="fade">
                <div
                    v-if="showCatalogHelp"
                    class="space-y-2 rounded-2xl bg-white/80 px-4 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:text-sm"
                >
                    <p class="font-semibold text-slate-800">Dicas rápidas</p>
                    <ul class="list-disc space-y-1 pl-5">
                        <li>Foto, nome e descrição viram a carta do Decidir — quanto mais contexto, melhor.</li>
                        <li>Pese ou estime em kg e informe o volume em litros (ou calcule pelas dimensões).</li>
                        <li>Use a descrição para lembrar acessórios, fragilidade ou onde o item está guardado.</li>
                    </ul>
                </div>
            </transition>
            <div class="grid gap-6 lg:grid-cols-[minmax(0,2fr)_minmax(280px,1fr)]">
                <form class="space-y-6" @submit.prevent="handleSubmit">
                <div class="space-y-3">
                    <label class="text-sm font-medium text-slate-700">Foto</label>

                    <div v-if="photo" class="relative overflow-hidden rounded-2xl shadow-inner shadow-slate-200">
                        <img :src="photo" alt="Preview" class="h-56 w-full object-cover" />
                        <div class="absolute inset-x-0 top-3 flex justify-end gap-2 pr-3">
                            <button
                                type="button"
                                class="rounded-full bg-white/95 px-3 py-1 text-xs font-semibold text-slate-700 shadow"
                                @click="handleRemovePreview"
                            >
                                Remover
                            </button>
                            <button
                                type="button"
                                class="rounded-full bg-white/95 px-3 py-1 text-xs font-semibold text-sky-600 shadow"
                                @click="triggerFilePicker"
                            >
                                Adicionar outra
                            </button>
                        </div>
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
                            <span class="text-xs text-slate-500">Capture várias fotos em sequência; elas entram na fila ao lado.</span>
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
                        class="space-y-2 rounded-2xl border border-sky-100 bg-white/70 p-3 text-xs text-slate-600"
                    >
                        <div class="flex items-center justify-between">
                            <span class="text-sm font-semibold text-slate-800">Fila de fotos ({{ photoQueue.length }})</span>
                            <button
                                type="button"
                                class="text-[11px] font-semibold text-rose-500 hover:underline"
                                @click="clearPhotoQueue"
                            >
                                Limpar fila
                            </button>
                        </div>
                        <div class="flex gap-3 overflow-x-auto pb-1">
                            <div
                                v-for="entry in photoQueue"
                                :key="entry.id"
                                class="relative flex w-24 flex-col items-center gap-2 rounded-2xl border px-2 py-2"
                                :class="entry.id === currentPhotoId ? 'border-sky-400 bg-sky-50 shadow' : 'border-slate-200 bg-white'"
                            >
                                <span
                                    v-if="entry.id === currentPhotoId"
                                    class="absolute left-2 top-2 rounded-full bg-sky-500/10 px-2 py-0.5 text-[10px] font-semibold text-sky-600"
                                >
                                    Em uso
                                </span>
                                <img :src="entry.preview" alt="Fila" class="h-16 w-full rounded-xl object-cover" />
                                <div class="flex w-full justify-between gap-1 text-[11px]">
                                    <button type="button" class="text-sky-600" @click="setCurrentPhoto(entry.id)">Usar</button>
                                    <button type="button" class="text-rose-500" @click="removeQueueEntry(entry.id)">Excluir</button>
                                </div>
                            </div>
                        </div>
                        <div v-if="photo" class="rounded-2xl border border-sky-50 bg-sky-50/30 p-3 text-[11px] text-slate-500">
                            <p class="mb-2 text-xs font-semibold text-slate-700">Foto selecionada</p>
                            <img :src="photo" alt="Selecionada" class="h-32 w-full rounded-xl object-cover" />
                        </div>
                    </div>
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

                <div class="space-y-2 rounded-2xl border border-sky-100 bg-white/70 px-4 py-3">
                    <div class="flex flex-wrap items-center justify-between gap-2">
                        <p class="text-sm font-semibold text-slate-800">Modelos rápidos</p>
                        <button
                            type="button"
                            class="rounded-full border border-slate-200 px-3 py-1 text-xs font-semibold text-slate-600 hover:bg-white"
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
                            class="group inline-flex items-center gap-2 rounded-full border px-3 py-1 text-xs font-semibold transition"
                            :class="'border-sky-200 bg-white text-slate-700 hover:bg-sky-50'"
                            @click="applyTemplate(template)"
                        >
                            {{ template.name }}
                            <span
                                class="text-[10px] text-slate-400 transition group-hover:text-slate-600"
                                @click.stop="removeTemplate(template.id)"
                            >×</span>
                        </button>
                        <p v-if="!templates.length" class="text-xs text-slate-500">Nenhum modelo salvo ainda.</p>
                    </div>
                </div>

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
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-medium text-slate-700">Dimensões (cm) — opcional</span>
                        <button
                            type="button"
                            class="text-xs font-semibold text-sky-600 underline-offset-2 hover:underline"
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
                    </transition>
                    <p class="text-xs text-slate-500">Preencha em centímetros se quiser sugerir automaticamente o volume. Ex.: 55 × 40 × 23</p>
                    <p v-if="calculatedVolumeCm3" class="text-xs text-slate-500">
                        Volume calculado:
                        <span class="font-semibold text-slate-700">{{ calculatedVolumeLitersDisplay }} L</span>
                        ({{ calculatedVolumeCm3Display }} cm³)
                    </p>
                </div>

                <div class="grid gap-4 sm:grid-cols-2">
                    <div class="space-y-2">
                        <span class="text-sm font-medium text-slate-700">Categoria</span>
                        <div class="flex flex-wrap gap-2">
                            <button
                                v-for="option in categoryOptions"
                                :key="option"
                                type="button"
                                class="rounded-full border px-3 py-1 text-xs font-semibold transition"
                                :class="category === option ? 'border-sky-400 bg-sky-500/10 text-sky-700' : 'border-slate-200 bg-white text-slate-600 hover:bg-slate-50'"
                                @click="selectCategory(option)"
                            >
                                {{ option }}
                            </button>
                        </div>
                        <input
                            v-model="category"
                            type="text"
                            placeholder="Ou digite uma categoria personalizada"
                            class="w-full rounded-2xl border border-sky-200 bg-white/80 px-3 py-2 text-sm text-slate-800 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                        />
                    </div>

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
                            class="inline-flex items-center gap-2 rounded-2xl bg-sky-500 px-5 py-2.5 text-sm font-semibold text-white shadow hover:bg-sky-400 disabled:cursor-not-allowed disabled:opacity-70"
                            :disabled="submittingItem"
                        >
                        <Loader2 v-if="submittingItem" class="h-4 w-4 animate-spin" />
                        <Plus v-else class="h-4 w-4" />
                        <span>{{ submittingItem ? 'Adicionando...' : 'Adicionar item' }}</span>
                    </button>
                    </div>
                </form>
                <div
                    class="space-y-3 rounded-3xl border border-sky-100 bg-white/80 px-4 py-5 text-sm text-slate-700 shadow-inner shadow-slate-100"
                >
                    <p class="text-base font-semibold text-slate-900">Prévia da carta</p>
                    <p class="text-xs text-slate-500">Veja como esse item aparecerá no Decidir antes de salvar.</p>
                    <div
                        class="relative overflow-hidden rounded-[28px] border border-slate-100 bg-gradient-to-br from-sky-100 to-sky-50 p-4 shadow"
                    >
                        <div
                            class="mb-4 h-40 w-full rounded-2xl bg-slate-200/70"
                            :style="previewCard.photo ? { backgroundImage: `url(${previewCard.photo})`, backgroundSize: 'cover', backgroundPosition: 'center' } : {}"
                        >
                            <div
                                v-if="previewCard.photo"
                                class="h-full w-full rounded-2xl"
                            ></div>
                            <div
                                v-else
                                class="flex h-full w-full items-center justify-center text-slate-400"
                            >
                                <Camera class="h-10 w-10" />
                            </div>
                            <span
                                v-if="previewCard.fragile"
                                class="absolute left-4 top-4 inline-flex items-center gap-1 rounded-full bg-amber-500/90 px-3 py-0.5 text-[11px] font-semibold text-white shadow"
                            >
                                ⚠️ Frágil
                            </span>
                        </div>
                        <p class="text-lg font-semibold text-slate-900">
                            {{ previewCard.title || 'Item sem nome ainda' }}
                        </p>
                        <p class="text-sm text-slate-600">
                            {{ previewCard.notes || 'Use o campo de descrição para contar a história do item.' }}
                        </p>
                        <div class="mt-4 grid gap-2 text-xs text-slate-500">
                            <div class="flex items-center gap-2">
                                <span class="rounded-full bg-white/70 px-2 py-0.5 font-semibold text-slate-700">
                                    ⚖️ {{ previewCard.weightLabel }}
                                </span>
                                <span class="rounded-full bg-white/70 px-2 py-0.5 font-semibold text-slate-700">
                                    🧊 {{ previewCard.volumeLabel }}
                                </span>
                            </div>
                            <p class="capitalize">
                                🏷️ {{ previewCard.category || 'Sem categoria' }}
                            </p>
                        </div>
                    </div>
                    <p class="text-xs text-slate-500">
                        Dica: fotos bem iluminadas e títulos específicos deixam o baralho muito mais agradável.
                    </p>
                </div>
            </div>
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
