<template>
    <Head title="Embalar" />
    <AppLayout>
        <template #title>Embalar</template>
        <template #subtitle>Distribua os itens nas malas A e B e marque o que já está pronto.</template>

        <Card tone="slate" class="space-y-5">
            <div class="flex flex-wrap items-center justify-between gap-3">
                <div>
                    <p class="text-base font-semibold text-slate-900">Resumo das malas</p>
                    <p class="text-sm text-slate-600">
                        Embale cada mala com cuidado. Quando o peso ou volume chegar em 100%, ela trava automaticamente.
                    </p>
                </div>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-white/80 px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-black/5 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400"
                    @click="showLegend = !showLegend"
                    aria-expanded="showLegend ? 'true' : 'false'"
                >
                    <span class="inline-flex h-5 w-5 items-center justify-center rounded-full bg-slate-100 text-[11px] font-semibold text-slate-500">?</span>
                    Como funciona
                </button>
            </div>
            <transition name="fade">
                <div
                    v-if="showLegend"
                    class="space-y-2 rounded-2xl bg-white/80 px-4 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:text-sm"
                >
                    <p class="font-semibold text-slate-800">Como usar esta etapa</p>
                    <ul class="list-disc space-y-1.5 pl-5 text-sm leading-relaxed">
                        <li>Os cartões exibem peso, volume e categoria em forma de selos e possuem botões para enviar direto para as malas.</li>
                        <li>Ao marcar “Embalado”, o item entra na mala escolhida; “Sem mala” tira o item da mala e o deixa pendente.</li>
                        <li>Notas e checklist ficam abaixo: escolha uma mala, registre lembretes e salve para ver o histórico.</li>
                        <li>Quando uma mala estiver cheia/chegando ao limite, veja a “Sugestão de redistribuição” para mover um item pesado.</li>
                        <li>Use “Atualizações recentes” para entender rapidamente quem entrou/saiu de cada mala e “Gerar resumo” para compartilhar o que já foi embalado.</li>
                    </ul>
                </div>
            </transition>
            <div
                class="grid gap-3 rounded-2xl bg-white/80 px-4 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:grid-cols-3 sm:text-sm"
            >
                <div class="flex items-center gap-3">
                    <span class="grid h-8 w-8 place-items-center rounded-full bg-emerald-100 text-emerald-600">⚖️</span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Peso carregado
                        </p>
                        <p class="text-sm font-semibold text-slate-800">
                            {{ formatKg(packUsedWeightKg) }} / {{ formatKg(packTotalCapacityKg) }}
                        </p>
                        <p class="text-[11px] text-slate-500 sm:text-xs">
                            {{ formatKg(packRemainingWeightKg) }} livres • {{ formatKg(packReservedKg) }} reservado
                        </p>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="grid h-8 w-8 place-items-center rounded-full bg-sky-100 text-sky-600">🧊</span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Volume ocupado
                        </p>
                        <p class="text-sm font-semibold text-slate-800">
                            {{ formatLiters(packUsedVolumeCm3) }} / {{ formatLiters(packTotalVolumeCm3) }}
                        </p>
                        <p class="text-[11px] text-slate-500 sm:text-xs">
                            {{ formatLiters(packRemainingVolumeCm3) }} livres • {{ formatLiters(packReservedVolumeCm3) }} reservado
                        </p>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span
                        class="grid h-8 w-8 place-items-center rounded-full"
                        :class="lockedBagsCount ? 'bg-rose-100 text-rose-600' : 'bg-emerald-100 text-emerald-600'"
                    >
                        🧳
                    </span>
                    <div class="space-y-0.5">
                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 sm:text-[0.7rem]">
                            Status das malas
                        </p>
                        <p class="text-sm font-semibold" :class="lockedBagsCount ? 'text-rose-600' : 'text-slate-800'">
                            {{ lockedBagsCount }} bloqueada(s) • {{ totalBagsCount }} no total
                        </p>
                        <p class="text-[11px] text-slate-500 sm:text-xs">
                            {{ packedCount }} itens embalados de {{ packItems.length }}
                        </p>
                    </div>
                </div>
            </div>
            <WeightBar
                :bags="rawPackBags"
                :reserved-kg="packReservedKg"
                :total-capacity-kg="packTotalCapacityKg"
                :yes-weight-kg="packUsedWeightKg"
            />
            <VolumeBar
                :bags="rawPackBags"
                :reserved-cm3="packReservedVolumeCm3"
                :total-capacity-cm3="packTotalVolumeCm3"
                :used-cm3="packUsedVolumeCm3"
            />
            <div class="grid gap-4 md:grid-cols-2">
                <Suitcase
                    v-for="bag in suitcaseSummaries"
                    :key="bag.id"
                    :name="bag.name"
                    :dims="bag.dims"
                    :current="bag.current"
                    :max="bag.max"
                    :status="bag.status"
                    :ratio="bag.ratio"
                    :weight="bag.weight"
                    :volume="bag.volume"
                    :has-notes="Boolean((bag.notes ?? '').trim().length || (bag.checklist?.length ?? 0))"
                />
            </div>
        </Card>

        <Card
            v-if="statusBanner"
            :tone="statusBanner.tone ?? 'slate'"
            class="mt-4 flex items-start gap-3"
        >
            <span class="text-3xl" aria-hidden="true">{{ statusBanner.emoji }}</span>
            <div>
                <p class="text-base font-semibold text-slate-900">{{ statusBanner.title }}</p>
                <p class="text-sm text-slate-600">{{ statusBanner.message }}</p>
            </div>
        </Card>

        <Card
            v-if="rebalanceSuggestion"
            tone="slate"
            class="mt-4 space-y-3"
        >
            <div class="flex items-start gap-3">
                <span class="text-3xl" aria-hidden="true">🔄</span>
                <div>
                    <p class="text-base font-semibold text-slate-900">{{ rebalanceSuggestion.title }}</p>
                    <p class="text-sm text-slate-600">
                        {{ rebalanceSuggestion.description }}
                    </p>
                </div>
            </div>
            <button
                v-if="rebalanceSuggestion.mode === 'action'"
                type="button"
                class="inline-flex w-full items-center justify-center gap-2 rounded-full bg-amber-500 px-4 py-2 text-sm font-semibold text-slate-900 shadow transition hover:bg-amber-400 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-200 disabled:cursor-not-allowed disabled:opacity-60"
                :disabled="suggestionLoading"
                @click="applyRebalanceSuggestion"
            >
                <span v-if="suggestionLoading" class="h-2 w-2 animate-spin rounded-full border-2 border-white border-t-transparent" />
                Aplicar sugestão
            </button>
            <button
                v-else-if="rebalanceSuggestion.mode === 'manual'"
                type="button"
                class="inline-flex w-full items-center justify-center gap-2 rounded-full bg-white px-4 py-2 text-sm font-semibold text-slate-900 shadow ring-1 ring-slate-200 transition hover:bg-slate-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-200 disabled:cursor-not-allowed disabled:opacity-60"
                :disabled="suggestionLoading"
                @click="releaseRebalanceItem"
            >
                <span v-if="suggestionLoading" class="h-2 w-2 animate-spin rounded-full border-2 border-slate-700 border-t-transparent" />
                Liberar item da mala
            </button>
        </Card>
        <Card
            v-else
            tone="slate"
            class="mt-4 flex items-start gap-3 text-sm text-slate-600"
        >
            <span class="text-2xl" aria-hidden="true">✅</span>
            <div>
                <p class="text-base font-semibold text-slate-900">Tudo equilibrado</p>
                <p>As malas estão abaixo do limite. Assim que alguma ficar cheia, sugeriremos automaticamente o que mover.</p>
            </div>
        </Card>

        <div
            v-if="allPackedBanner && packItems.length"
            class="mt-4 flex items-start gap-3 rounded-2xl bg-green-50 p-4 text-green-800 shadow-sm ring-1 ring-green-200"
        >
            <span class="text-2xl">🎉</span>
            <div>
                <p class="text-base font-semibold">Tudo embalado!</p>
                <p class="text-sm">Você pode revisar no Resumo para ajustar as malas finalizadas.</p>
            </div>
        </div>

        <Card
            v-if="priorityTimeline.visible"
            tone="slate"
            class="mt-4 space-y-4"
        >
            <div class="flex flex-wrap items-start justify-between gap-3">
                <div>
                    <p class="text-base font-semibold text-slate-900">Linha do tempo das prioridades</p>
                    <p class="text-sm text-slate-600">Use as etiquetas abaixo dos cartões para marcar itens essenciais e ver rapidamente o que ainda está fora das malas.</p>
                </div>
            </div>
            <div class="grid gap-3 sm:grid-cols-3">
                <div
                    v-for="group in priorityTimeline.groups"
                    :key="group.key"
                    class="rounded-2xl border border-slate-100 bg-white/80 p-4 text-sm shadow-sm"
                >
                    <div class="flex items-center gap-2">
                        <span class="text-lg" aria-hidden="true">{{ group.emoji }}</span>
                        <p class="font-semibold text-slate-800">{{ group.label }}</p>
                    </div>
                    <p class="text-xs text-slate-500 mt-1">
                        {{ group.assigned }} de {{ group.total }} nas malas
                    </p>
                    <div class="mt-3 h-2 rounded-full bg-slate-100">
                        <div
                            class="h-2 rounded-full transition-all"
                            :class="group.barClass"
                            :style="{ width: `${group.progress}%` }"
                        />
                    </div>
                    <p
                        v-if="group.pendingNames.length"
                        class="mt-2 text-xs font-medium text-amber-700"
                    >
                        Falta colocar: {{ group.pendingNames.join(', ') }}
                    </p>
                    <p
                        v-else
                        class="mt-2 text-xs text-emerald-600"
                    >
                        Tudo certo por aqui!
                    </p>
                </div>
            </div>
        </Card>
        <Card
            v-if="bagHistoryFeed.length"
            tone="slate"
            class="mt-4 space-y-3"
        >
            <div class="flex items-start justify-between gap-3">
                <div>
                    <p class="text-base font-semibold text-slate-900">Atualizações recentes</p>
                    <p class="text-sm text-slate-600">Últimos movimentos registrados nas malas.</p>
                </div>
            </div>
            <ol class="space-y-3 max-h-64 overflow-y-auto pr-1">
                <li
                    v-for="entry in bagHistoryFeed"
                    :key="entry.id"
                    class="rounded-2xl border border-slate-100 bg-white/80 p-3 text-sm text-slate-600 shadow-sm"
                >
                    <div class="flex items-center justify-between gap-2">
                        <p class="font-semibold text-slate-800">{{ entry.bagName }}</p>
                        <span class="text-xs text-slate-400">
                            {{ formatRelativeTimeLabel(entry.created_at) }}
                        </span>
                    </div>
                    <p class="text-sm">{{ formatHistoryMessage(entry) }}</p>
                </li>
            </ol>
        </Card>

        <Card
            v-if="bagNotesTargets.length"
            tone="slate"
            class="mt-4 space-y-4"
        >
            <div class="flex flex-wrap items-start justify-between gap-3">
                <div>
                    <p class="text-base font-semibold text-slate-900">Notas e checklist das malas</p>
                    <p class="text-sm text-slate-600">Guarde lembretes importantes e marque o que já está pronto em cada mala.</p>
                </div>
                <div class="flex items-center gap-2">
                    <button
                        type="button"
                        class="inline-flex items-center gap-2 rounded-full border border-slate-200 px-3 py-1.5 text-xs font-semibold text-slate-600 transition hover:bg-white disabled:cursor-not-allowed disabled:opacity-60"
                        :disabled="!selectedBagNotesId || bagNotesDirty || shareModalLoading"
                        @click="openBagSummaryModal"
                    >
                        <Share2 class="h-4 w-4" />
                        Gerar resumo
                    </button>
                    <NotebookPen class="h-5 w-5 text-slate-400" aria-hidden="true" />
                </div>
            </div>
            <div class="flex flex-wrap gap-2">
                <button
                    v-for="bag in bagNotesTargets"
                    :key="bag.id"
                    type="button"
                    class="rounded-full border px-3 py-1.5 text-sm font-semibold transition"
                    :class="bag.id === selectedBagNotesId ? 'border-emerald-400 bg-emerald-50 text-emerald-700 shadow' : 'border-slate-200 bg-white text-slate-600 hover:bg-white'"
                    @click="selectedBagNotesId = bag.id"
                >
                    {{ bag.name }}
                    <span
                        v-if="(bag.notes ?? '').trim().length || (bag.checklist?.length ?? 0)"
                        class="ml-1 text-xs text-amber-500"
                    >
                        •
                    </span>
                </button>
            </div>
            <div v-if="currentBagNotes && currentBagMeta" class="grid gap-4 md:grid-cols-2">
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-sm font-semibold text-slate-700">
                        <NotebookPen class="h-4 w-4 text-amber-500" />
                        Notas da {{ currentBagMeta.name }}
                    </label>
                    <p v-if="currentBagLastUpdate" class="text-xs text-slate-400">
                        Última atualização: {{ formatRelativeTimeLabel(currentBagLastUpdate.created_at) }}
                    </p>
                    <textarea
                        v-model="currentBagNotes.notes"
                        :maxlength="bagNotesMax"
                        rows="4"
                        class="w-full rounded-2xl border border-slate-200 bg-white/90 p-3 text-sm text-slate-700 shadow-inner shadow-slate-50 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                        placeholder="Ex.: Usar cadeado TSA, colocar etiqueta com destino..."
                        @input="touchCurrentBagDraft"
                    />
                    <div class="text-right text-xs text-slate-400">
                        {{ bagNotesCharCount }} / {{ bagNotesMax }} caracteres
                    </div>
                </div>
                <div class="space-y-2">
                    <label class="flex items-center gap-2 text-sm font-semibold text-slate-700">
                        <ListChecks class="h-4 w-4 text-slate-500" />
                        Checklist rápido
                    </label>
                    <div class="space-y-2">
                        <div
                            v-for="item in currentBagNotes.checklist"
                            :key="item.id"
                            class="flex items-center gap-2 rounded-2xl border border-slate-100 bg-white/80 p-2 shadow-sm"
                        >
                            <input
                                v-model="item.completed"
                                type="checkbox"
                                class="h-4 w-4 rounded border-slate-300 text-emerald-500 focus:ring-emerald-300"
                                @change="touchCurrentBagDraft"
                            />
                            <input
                                v-model="item.text"
                                type="text"
                                class="flex-1 rounded-full border border-transparent bg-transparent px-3 py-1 text-sm text-slate-700 focus:border-emerald-200 focus:outline-none"
                                placeholder="Ex.: Colocar etiqueta"
                                maxlength="160"
                                @input="touchCurrentBagDraft"
                            />
                            <button
                                type="button"
                                class="text-slate-400 transition hover:text-rose-500"
                                @click="removeChecklistItem(item.id)"
                                aria-label="Remover item"
                            >
                                <X class="h-4 w-4" />
                            </button>
                        </div>
                        <button
                            type="button"
                            class="inline-flex items-center gap-2 rounded-full border border-dashed border-slate-300 px-3 py-1.5 text-xs font-semibold text-slate-600 transition hover:border-emerald-300 hover:text-emerald-600 disabled:cursor-not-allowed disabled:opacity-60"
                            :disabled="maxChecklistReached"
                            @click="addChecklistItem"
                        >
                            <Plus class="h-4 w-4" />
                            Novo item
                        </button>
                    </div>
                </div>
            </div>
            <p v-else class="text-sm text-slate-500">Selecione uma mala para adicionar notas.</p>
            <div
                v-if="currentBagNotes && currentBagMeta"
                class="flex flex-wrap justify-end gap-2"
            >
                <button
                    type="button"
                    class="rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 transition hover:bg-white disabled:cursor-not-allowed disabled:opacity-60"
                    :disabled="!bagNotesDirty"
                    @click="resetBagNotes"
                >
                    Descartar alterações
                </button>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-emerald-400 disabled:cursor-not-allowed disabled:opacity-60"
                    :disabled="!bagNotesDirty || isBagNotesSaving"
                    @click="saveBagNotes"
                >
                    <span
                        v-if="isBagNotesSaving"
                        class="h-2 w-2 animate-ping rounded-full bg-white"
                        aria-hidden="true"
                    />
                    Salvar notas
                </button>
            </div>
        </Card>

        <Card tone="yellow" class="space-y-4">
            <template v-if="packItems.length">
                <div class="rounded-2xl bg-white/70 px-3 py-3 text-xs text-slate-600 ring-1 ring-black/5 sm:text-sm">
                    <div class="flex items-start gap-2 pb-2">
                        <Package class="mt-[2px] h-4 w-4 text-amber-500" />
                        <p>
                            Use a busca, filtros e ações em massa para reorganizar vários itens de uma vez só. O bloco abaixo permanece visível enquanto você rola dentro da lista.
                        </p>
                    </div>
                    <div
                        ref="listContainer"
                        class="relative max-h-[65vh] overflow-y-auto pr-1"
                    >
                        <div
                            class="sticky top-0 z-20 space-y-3 rounded-2xl bg-white/95 px-3 py-3 shadow ring-1 ring-black/5 backdrop-blur supports-[backdrop-filter]:backdrop-blur"
                        >
                            <div class="flex flex-wrap items-center gap-3">
                                <div class="relative flex-1 min-w-[200px] sm:min-w-[260px]">
                                    <input
                                        v-model="searchQuery"
                                        type="search"
                                        placeholder="Buscar por nome, notas ou categoria…"
                                        class="w-full rounded-full border border-slate-200 bg-white/90 px-3 py-2 text-sm text-slate-700 shadow-inner shadow-slate-100 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                                    />
                                    <span
                                        v-if="searchQuery"
                                        class="pointer-events-none absolute inset-y-0 right-3 flex items-center text-[11px] font-medium text-slate-400"
                                    >
                                        {{ filteredPackItems.length }} resultado(s)
                                    </span>
                                </div>
                                <div class="flex flex-wrap items-center gap-2">
                                    <button
                                        v-for="option in filterOptions"
                                        :key="option.value"
                                        type="button"
                                        class="rounded-full border px-3 py-1 text-xs font-semibold transition sm:text-sm"
                                        :class="[
                                            activeFilter === option.value
                                                ? 'border-emerald-300 bg-emerald-500 text-white shadow'
                                                : 'border-slate-200 bg-white/80 text-slate-600 hover:bg-white',
                                        ]"
                                        @click="setActiveFilter(option.value)"
                                    >
                                        {{ option.label }}
                                    </button>
                                </div>
                            </div>
                            <div class="space-y-2 rounded-2xl bg-white/80 px-3 py-2 text-xs text-slate-600 ring-1 ring-slate-200 sm:text-sm">
                                <div class="flex flex-wrap items-center justify-between gap-2">
                                    <label class="inline-flex items-center gap-2 font-semibold text-slate-700">
                                        <input
                                            type="checkbox"
                                            class="h-5 w-5 rounded border-slate-300 text-amber-500 focus:ring-amber-400"
                                            :checked="allSelectedOnPage"
                                            @change="toggleSelectAllOnPage($event.target.checked)"
                                        />
                                        Selecionar todos da lista
                                    </label>
                                    <span v-if="selectedIds.length" class="text-xs font-medium text-slate-500">
                                        {{ selectedIds.length }} selecionado(s)
                                    </span>
                                </div>
                                <div class="flex flex-wrap items-center gap-2" v-if="selectedIds.length">
                                    <select
                                        v-model="bulkBagChoice"
                                        class="rounded-full border border-slate-200 bg-white px-3 py-1 text-xs text-slate-700 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:text-sm"
                                    >
                                        <option value="">Sem mala</option>
                                        <option v-for="bag in bagOptions" :key="bag.value" :value="bag.value">
                                            {{ bag.label }}
                                        </option>
                                    </select>
                                    <button
                                        type="button"
                                        class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-3 py-1.5 text-xs font-semibold text-white shadow transition hover:bg-slate-800 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 sm:text-sm disabled:cursor-not-allowed disabled:opacity-60"
                                        :disabled="bulkAssigning"
                                        @click="handleBulkAssign"
                                    >
                                        <span v-if="bulkAssigning" class="h-2 w-2 animate-ping rounded-full bg-white" aria-hidden="true" />
                                        Enviar seleção
                                    </button>
                                    <button
                                        type="button"
                                        class="rounded-full border border-slate-200 px-3 py-1 text-xs font-semibold text-slate-600 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 sm:text-sm"
                                        :disabled="bulkAssigning"
                                        @click="handleBulkPacked(true)"
                                    >
                                        Marcar embalado
                                    </button>
                                    <button
                                        type="button"
                                        class="rounded-full border border-slate-200 px-3 py-1 text-xs font-semibold text-slate-600 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 sm:text-sm"
                                        :disabled="bulkAssigning"
                                        @click="handleBulkPacked(false)"
                                    >
                                        Marcar pendente
                                    </button>
                                    <button
                                        type="button"
                                        class="rounded-full border border-slate-200 px-3 py-1 text-xs font-semibold text-slate-600 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300 sm:text-sm"
                                        @click="clearSelection"
                                    >
                                        Limpar seleção ({{ selectedIds.length }})
                                    </button>
                                </div>
                            </div>
                            <div class="flex flex-wrap items-center justify-between gap-2">
                                <span class="font-semibold text-slate-700">
                                    Embalados: {{ packedCount }} / {{ packItems.length }}
                                </span>
                                <button
                                    v-if="hasPacked"
                                    type="button"
                                    class="inline-flex items-center gap-2 rounded-full border border-amber-200 px-4 py-2 text-xs font-semibold text-amber-700 transition hover:bg-amber-100 sm:text-sm"
                                    @click="markAllPacked(false)"
                                    aria-label="Desmarcar todos os itens embalados"
                                >
                                    Desmarcar todos
                                </button>
                            </div>
                        </div>

                        <div
                            v-if="filteredPackItems.length"
                            class="space-y-4 pt-4 pb-4"
                        >
                            <div
                                v-for="item in filteredPackItems"
                                :key="item.id"
                                class="flex flex-col gap-4 rounded-2xl bg-white/70 p-4 ring-1 ring-white/40 sm:flex-row sm:items-center sm:justify-between"
                                :class="selection.has(item.id) ? 'ring-amber-300 ring-2' : ''"
                            >
                                <div class="flex flex-1 items-start gap-3">
                                    <label class="pt-2">
                                        <input
                                            type="checkbox"
                                            class="h-5 w-5 rounded border-slate-300 text-amber-500 focus:ring-amber-400"
                                            :checked="selection.has(item.id)"
                                            @change="toggleItemSelection(item.id, $event.target.checked)"
                                        />
                                    </label>
                                    <div
                                        class="relative flex h-16 w-16 flex-shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-amber-100/60"
                                    >
                                        <img
                                            v-if="hasPhoto(item)"
                                            :src="itemPhoto(item)"
                                            :alt="item.title ?? item.name"
                                            class="max-h-full max-w-full cursor-zoom-in object-contain transition hover:scale-[1.04]"
                                            loading="lazy"
                                            decoding="async"
                                            @error="() => markPhotoFailed(item)"
                                            @click.stop="openImagePreview(item)"
                                        />
                                        <Package v-else class="h-7 w-7 text-amber-500/60" />
                                        <button
                                            v-if="hasPhoto(item)"
                                            type="button"
                                            class="absolute right-1 top-1 inline-flex h-7 w-7 items-center justify-center rounded-xl bg-white/85 text-slate-700 shadow ring-1 ring-slate-100 transition hover:bg-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-400"
                                            @click.stop="openImagePreview(item)"
                                            aria-label="Ampliar imagem"
                                        >
                                            <ZoomIn class="h-4 w-4" />
                                        </button>
                                    </div>
                                    <div class="space-y-1">
                                        <div class="flex flex-wrap items-center gap-2">
                                            <p class="text-base font-semibold text-slate-900 sm:text-lg">
                                                {{ item.title ?? item.name }}
                                            </p>
                                            <span
                                                v-if="item.priority"
                                                class="inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[11px] font-semibold"
                                                :class="priorityBadgeClass(item.priority)"
                                            >
                                                {{ priorityMetaMap[item.priority]?.emoji ?? '•' }}
                                                {{ priorityMetaMap[item.priority]?.shortLabel ?? 'Prioritário' }}
                                            </span>
                                        </div>
                                        <p v-if="item.notes" class="text-sm text-slate-600">{{ item.notes }}</p>
                                        <div class="flex flex-wrap gap-2 text-[11px] font-medium text-slate-500 sm:text-xs">
                                            <span class="inline-flex items-center gap-1 rounded-full bg-white/70 px-2 py-0.5 ring-1 ring-white/60">
                                                ⚖️ {{ formatKg(item.weight ?? item.weight_kg ?? 0) }}
                                            </span>
                                            <span class="inline-flex items-center gap-1 rounded-full bg-white/70 px-2 py-0.5 ring-1 ring-white/60">
                                                🧊 {{ formatVolume(item) ?? 'Sem volume' }}
                                            </span>
                                            <span class="inline-flex items-center gap-1 rounded-full bg-white/70 px-2 py-0.5 ring-1 ring-white/60 capitalize">
                                                🏷️ {{ item.category ?? 'Sem categoria' }}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="space-y-3 sm:w-56">
                                    <div class="flex flex-wrap gap-2">
                                        <button
                                            v-for="option in bagQuickOptions"
                                            :key="`${item.id}-${option.value || 'none'}`"
                                            type="button"
                                            class="inline-flex flex-1 items-center justify-center rounded-full border border-amber-200 px-3 py-1.5 text-xs font-semibold transition sm:text-sm"
                                            :class="[
                                                isItemInBag(item, option.value)
                                                    ? 'bg-amber-400 text-slate-900 shadow'
                                                    : 'text-slate-600 hover:bg-white',
                                                option.value && isBagLocked(option.value)
                                                    ? 'cursor-not-allowed opacity-60 hover:bg-transparent'
                                                    : '',
                                            ]"
                                            :disabled="Boolean(option.value) && isBagLocked(option.value)"
                                            :title="option.value && isBagLocked(option.value) ? bagLockMessage(option.value) : `Enviar para ${option.label}`"
                                            @click="assignBag(item, option.value ?? '')"
                                        >
                                            {{ option.label }}
                                        </button>
                                    </div>

                                    <div class="space-y-1">
                                        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Prioridade</p>
                                        <div class="flex flex-wrap gap-1">
                                            <button
                                                v-for="option in priorityOptions"
                                                :key="`${item.id}-priority-${option.value || 'normal'}`"
                                                type="button"
                                                class="rounded-full border px-2.5 py-1 text-[11px] font-semibold uppercase tracking-wide transition"
                                                :class="[
                                                    (item.priority ?? '') === option.value
                                                        ? `${option.chipClass} border-transparent shadow`
                                                        : 'border-slate-200 bg-white text-slate-600 hover:bg-slate-50',
                                                ]"
                                                :disabled="isPriorityUpdating(item.id)"
                                                @click="setItemPriority(item, option.value)"
                                            >
                                                <span class="flex items-center gap-1">
                                                    <span aria-hidden="true">{{ option.emoji }}</span>
                                                    {{ option.shortLabel }}
                                                </span>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="flex items-center gap-2">
                                        <label class="inline-flex items-center gap-2 rounded-full bg-white/80 px-3 py-1 text-sm font-medium text-slate-600 ring-1 ring-black/5">
                                            <input
                                                type="checkbox"
                                                class="h-4 w-4 rounded border-slate-300 text-amber-500 focus:ring-amber-300"
                                                :checked="item.packed"
                                                @change="onPackedChange(item, $event.target.checked)"
                                                :aria-label="`Marcar ${item.title ?? item.name} como embalado`"
                                            />
                                            Embalado
                                        </label>
                                        <button
                                            type="button"
                                            class="inline-flex items-center justify-center rounded-full bg-amber-500/15 px-2 py-1 text-xs font-semibold uppercase tracking-wide text-amber-600 ring-1 ring-amber-300 transition hover:bg-amber-500/25 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-400"
                                            @click="openItemHelp(item)"
                                        >
                                            Detalhes
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div
                            v-else
                            class="rounded-2xl border border-dashed border-slate-300/70 bg-white/60 p-8 text-center text-sm text-slate-500 sm:text-base"
                        >
                            Nenhum item encontrado para a busca atual. Ajuste os filtros para visualizar novamente.
                        </div>
                    </div>
                </div>
            </template>
            <template v-else>
                <div class="py-10 text-center text-sm text-slate-600">
                    Nenhum item aguardando embalagem por enquanto.
                </div>
            </template>
        </Card>

        <ImagePreviewModal
            v-if="previewSrc"
            v-model="previewVisible"
            :src="previewSrc"
            :alt="previewAlt"
        />
        <OverlayModal
            :model-value="shareModalVisible"
            @close="closeShareModal"
        >
            <template #header>
                <div class="space-y-1">
                    <p class="text-base font-semibold text-slate-900">Resumo da mala</p>
                    <p class="text-sm text-slate-500">
                        {{ shareBagInfo ? shareBagInfo.name : 'Selecione uma mala' }}
                    </p>
                </div>
            </template>
            <div v-if="shareModalLoading" class="flex items-center gap-2 text-sm text-slate-500">
                <span class="h-2 w-2 animate-ping rounded-full bg-emerald-400" />
                Carregando resumo...
            </div>
            <div v-else-if="shareError" class="text-sm text-rose-600">
                {{ shareError }}
            </div>
            <div v-else-if="shareBagInfo" class="space-y-4">
                <div class="rounded-2xl bg-slate-50/80 p-4 text-sm text-slate-600">
                    <p class="font-semibold text-slate-800">{{ shareBagInfo.name }}</p>
                    <p>Capacidade: {{ formatKg(Number(shareBagInfo.capacity_kg) || 0) }}</p>
                    <p v-if="shareBagInfo.dimensions">Dimensões: {{ shareBagInfo.dimensions }}</p>
                    <p>
                        Itens embalados:
                        {{ shareBagInfo.totals ? shareBagInfo.totals.items : 0 }} • Peso total:
                        {{ formatKg(Number(shareBagInfo.totals?.weight_kg ?? 0) || 0) }}
                    </p>
                </div>
                <div
                    class="rounded-2xl border border-slate-100 bg-white/90 p-4 text-sm text-slate-600 shadow-inner shadow-slate-50"
                >
                    <p class="mb-2 font-semibold text-slate-800">Texto para compartilhar</p>
                    <pre class="max-h-72 overflow-y-auto whitespace-pre-wrap text-xs sm:text-sm">{{ shareSummaryText }}</pre>
                </div>
            </div>
            <template #footer>
                <div class="flex-1 text-left">
                    <p v-if="copyFeedback" class="text-xs font-semibold text-emerald-600">
                        {{ copyFeedback }}
                    </p>
                </div>
                <button
                    type="button"
                    class="rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 transition hover:bg-white disabled:cursor-not-allowed disabled:opacity-60"
                    :disabled="shareModalLoading"
                    @click="copySummaryToClipboard"
                >
                    Copiar
                </button>
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-full bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow transition hover:bg-emerald-400 disabled:cursor-not-allowed disabled:opacity-60"
                    :disabled="shareModalLoading"
                    @click="shareSummaryViaWeb"
                >
                    <Share2 class="h-4 w-4" />
                    Compartilhar
                </button>
            </template>
        </OverlayModal>
    </AppLayout>
</template>

<script setup>
import axios from 'axios';
import { Head, usePage } from '@inertiajs/vue3';
import {
    computed,
    inject,
    nextTick,
    onBeforeUnmount,
    onMounted,
    reactive,
    ref,
    watch,
    watchEffect,
} from 'vue';
import {
    ListChecks,
    Luggage,
    NotebookPen,
    Package,
    Plus,
    Share2,
    X,
    ZoomIn,
} from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import Suitcase from '@/Components/Suitcase.vue';
import WeightBar from '@/Components/WeightBar.vue';
import VolumeBar from '@/Components/VolumeBar.vue';
import { useDecisionStore } from '@/stores/decision';
import { toast } from '@/utils/toast';
import ImagePreviewModal from '@/Components/ImagePreviewModal.vue';
import OverlayModal from '@/Components/OverlayModal.vue';

const decisionStore = useDecisionStore();
const page = usePage();
const numberFormatter = new Intl.NumberFormat('pt-BR');

const formatKg = (value) => `${Number(value ?? 0).toFixed(1)} kg`;
const formatLiters = (value) => `${(Number(value ?? 0) / 1000).toFixed(1)} L`;

const move = computed(() => page.props.move ?? null);

watchEffect(() => {
    decisionStore.setMove(move.value);
});


const listContainer = ref(null);
const registerScrollTarget = inject('registerScrollTarget', null);
let unregisterScrollTarget = null;

onMounted(async () => {
    if (move.value?.id) {
        try {
            await Promise.all([decisionStore.fetchPack(), decisionStore.fetchResumo()]);
        } catch (error) {
            console.error(error);
        }
    }

    if (registerScrollTarget) {
        unregisterScrollTarget = registerScrollTarget(listContainer);
    }
});

onBeforeUnmount(() => {
    unregisterScrollTarget?.();
});

const packItems = computed(() => decisionStore.pack.items ?? []);
const rawPackBags = computed(() => decisionStore.pack.bags ?? []);
const packTotals = computed(() => decisionStore.pack.totals ?? {});
const selection = reactive(new Set());
const bagOptions = computed(() => {
    const source = rawPackBags.value ?? [];
    if (!Array.isArray(source)) return [];
    const options = [];
    const seen = new Set();
    source.forEach((bag, index) => {
        const raw = bag?.code ?? bag?.slug ?? bag?.id ?? index;
        const value = raw != null ? String(raw) : `bag-${index}`;
        if (seen.has(value)) return;
        seen.add(value);
        const label = bag?.name ?? `Mala ${String(raw ?? index + 1).toUpperCase()}`;
        options.push({ value, label });
    });
    return options;
});
const bagLabelMap = computed(() => {
    const map = { '': 'Sem mala' };
    bagOptions.value.forEach((option) => {
        map[option.value] = option.label;
    });
    return map;
});
const bagFilterOptions = computed(() =>
    bagOptions.value.map((option) => ({
        value: `bag:${option.value}`,
        label: option.label,
    })),
);
const bagQuickOptions = computed(() => {
    if (!bagOptions.value.length) {
        return [{ value: '', label: 'Sem mala' }];
    }
    const all = [...bagOptions.value, { value: '', label: 'Sem mala' }];
    const seen = new Set();
    return all.filter((option) => {
        const key = option.value ?? '';
        if (seen.has(key)) return false;
        seen.add(key);
        return true;
    });
});
const priorityOptions = [
    { value: '', label: 'Normal', shortLabel: 'Normal', emoji: '•', chipClass: 'bg-slate-100 text-slate-600', barClass: 'bg-slate-400' },
    { value: 'essential', label: 'Essencial', shortLabel: 'Essencial', emoji: '🔥', chipClass: 'bg-rose-100 text-rose-700', barClass: 'bg-rose-500' },
    { value: 'priority', label: 'Prioritário', shortLabel: 'Prioritário', emoji: '⚡', chipClass: 'bg-amber-100 text-amber-700', barClass: 'bg-amber-500' },
    { value: 'optional', label: 'Opcional', shortLabel: 'Opcional', emoji: '🌿', chipClass: 'bg-sky-100 text-sky-700', barClass: 'bg-sky-500' },
];
const priorityMetaMap = priorityOptions.reduce((acc, option) => {
    acc[option.value || 'none'] = option;
    return acc;
}, {});
const priorityTimelineKeys = ['essential', 'priority', 'optional'];
const priorityLoading = reactive({});
const bagNotesDrafts = reactive({});
const bagNotesSaving = reactive({});
const selectedBagNotesId = ref('');
const bagNotesMax = 1200;
const bagNotesLimit = 25;
const shareModalVisible = ref(false);
const shareModalLoading = ref(false);
const shareSummary = ref(null);
const shareError = ref('');
const copyFeedback = ref('');
let copyFeedbackTimer = null;

const generateChecklistId = () => {
    if (globalThis.crypto?.randomUUID) {
        return globalThis.crypto.randomUUID();
    }
    return `note-${Date.now()}-${Math.random().toString(16).slice(2, 8)}`;
};

const sanitizeChecklistFromServer = (list) => {
    if (!Array.isArray(list)) {
        return [];
    }
    return list
        .map((entry) => ({
            id: entry?.id ? String(entry.id) : generateChecklistId(),
            text: typeof entry?.text === 'string' ? entry.text : '',
            completed: Boolean(entry?.completed),
        }))
        .map((entry) => ({
            ...entry,
            text: entry.text.slice(0, 160),
        }));
};

const syncBagDraftFromRaw = (bag, { force = false } = {}) => {
    const bagId = bagIdFromRaw(bag);
    if (!bagId) return;
    const sanitized = {
        notes: typeof bag.notes === 'string' ? bag.notes : '',
        checklist: sanitizeChecklistFromServer(bag.checklist),
    };
    const hash = JSON.stringify(sanitized);
    const existing = bagNotesDrafts[bagId];
    if (!existing || force || !existing.dirty) {
        bagNotesDrafts[bagId] = {
            notes: sanitized.notes,
            checklist: sanitized.checklist.map((entry) => ({ ...entry })),
            dirty: false,
            serverHash: hash,
        };
    } else {
        existing.serverHash = hash;
    }
};

const bagIdFromRaw = (bag) => {
    if (!bag) return '';
    if (bag.id != null) return String(bag.id);
    if (bag.code != null) return String(bag.code);
    if (bag.slug != null) return String(bag.slug);
    return '';
};

watch(
    rawPackBags,
    (bags) => {
        const bagList = Array.isArray(bags) ? bags : [];
        const nextIds = new Set();
        bagList.forEach((bag) => {
            const bagId = bagIdFromRaw(bag);
            if (!bagId) {
                return;
            }
            nextIds.add(bagId);
            syncBagDraftFromRaw(bag);
        });

        Object.keys(bagNotesDrafts).forEach((bagId) => {
            if (!nextIds.has(bagId)) {
                delete bagNotesDrafts[bagId];
            }
        });

        if (!nextIds.size) {
            selectedBagNotesId.value = '';
            return;
        }

        if (!nextIds.has(selectedBagNotesId.value)) {
            selectedBagNotesId.value = nextIds.values().next().value;
        }
    },
    { immediate: true },
);
const failedImages = reactive(new Set());
const showLegend = ref(false);

const searchQuery = ref('');
const activeFilter = ref('all');
const filterOptions = computed(() => [
    { value: 'all', label: 'Todos' },
    ...bagFilterOptions.value,
    { value: 'unassigned', label: 'Sem mala' },
    { value: 'packed', label: 'Embalados' },
    { value: 'unpacked', label: 'Pendentes' },
]);

const normalize = (value) =>
    (value ?? '')
        .toString()
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '');

const matchesFilter = (item, filter) => {
    const bagCode = (item?.bag ?? item?.bag_code ?? '').toString();
    if (filter.startsWith('bag:')) {
        const target = filter.slice(4);
        return target ? bagCode === target : false;
    }
    switch (filter) {
        case 'unassigned':
            return !bagCode;
        case 'packed':
            return Boolean(item?.packed);
        case 'unpacked':
            return !item?.packed;
        default:
            return true;
    }
};

const matchesQuery = (item, query) => {
    if (!query) return true;
    const haystack = normalize(
        `${item?.title ?? item?.name ?? ''} ${item?.notes ?? ''} ${item?.category ?? ''} ${item?.section ?? ''}`,
    );
    return haystack.includes(query);
};

const filteredPackItems = computed(() => {
    const filter = activeFilter.value;
    const query = normalize(searchQuery.value);
    return packItems.value.filter((item) => matchesFilter(item, filter) && matchesQuery(item, query));
});
const selectedIds = computed(() => Array.from(selection));
const allSelectedOnPage = computed(
    () => filteredPackItems.value.length > 0
        && filteredPackItems.value.every((item) => selection.has(item.id)),
);

const toggleSelectAllOnPage = (checked) => {
    const idsOnPage = filteredPackItems.value.map((item) => item.id);
    idsOnPage.forEach((id) => {
        if (checked) {
            selection.add(id);
        } else {
            selection.delete(id);
        }
    });
};

const clearSelection = () => {
    selection.clear();
};

const toggleItemSelection = (id, checked) => {
    if (checked) {
        selection.add(id);
    } else {
        selection.delete(id);
    }
};
const bagFromRawById = (id) => {
    if (!id) return null;
    const targetId = String(id);
    const source = Array.isArray(rawPackBags.value) ? rawPackBags.value : [];
    return source.find((bag) => bagIdFromRaw(bag) === targetId) ?? null;
};
const touchCurrentBagDraft = () => {
    if (currentBagNotes.value && !currentBagNotes.value.dirty) {
        currentBagNotes.value.dirty = true;
    }
};
const addChecklistItem = () => {
    const draft = currentBagNotes.value;
    if (!draft || draft.checklist.length >= bagNotesLimit) {
        return;
    }
    draft.checklist.push({
        id: generateChecklistId(),
        text: '',
        completed: false,
    });
    touchCurrentBagDraft();
};
const removeChecklistItem = (id) => {
    const draft = currentBagNotes.value;
    if (!draft) {
        return;
    }
    const index = draft.checklist.findIndex((entry) => entry.id === id);
    if (index >= 0) {
        draft.checklist.splice(index, 1);
        touchCurrentBagDraft();
    }
};
const sanitizeChecklistForSubmit = (list) => {
    if (!Array.isArray(list)) {
        return [];
    }
    return list
        .map((entry) => ({
            id: entry?.id ?? generateChecklistId(),
            text: (entry?.text ?? '').trim(),
            completed: Boolean(entry?.completed),
        }))
        .filter((entry) => entry.text.length > 0);
};
const saveBagNotes = async () => {
    const bagId = selectedBagNotesId.value;
    const draft = currentBagNotes.value;
    if (!bagId || !draft) {
        return;
    }
    bagNotesSaving[bagId] = true;
    try {
        await decisionStore.updateBagNotes(bagId, {
            notes: draft.notes?.trim() ? draft.notes.trim() : null,
            checklist: sanitizeChecklistForSubmit(draft.checklist),
        });
        draft.dirty = false;
        toast.success(`Notas salvas para ${currentBagMeta.value?.name ?? 'a mala'}`);
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível salvar as notas ❌');
    } finally {
        bagNotesSaving[bagId] = false;
    }
};
const resetBagNotes = () => {
    const bagId = selectedBagNotesId.value;
    if (!bagId) {
        return;
    }
    const bag = bagFromRawById(bagId);
    if (bag) {
        syncBagDraftFromRaw(bag, { force: true });
    }
};
const closeShareModal = () => {
    shareModalVisible.value = false;
    shareSummary.value = null;
    shareError.value = '';
};
const openBagSummaryModal = async () => {
    const bagId = selectedBagNotesId.value;
    if (!bagId) {
        return;
    }
    shareModalVisible.value = true;
    shareModalLoading.value = true;
    shareSummary.value = null;
    shareError.value = '';
    try {
        const { data } = await axios.get(`/api/bags/${bagId}/summary`);
        shareSummary.value = data;
    } catch (error) {
        console.error(error);
        shareError.value = 'Não foi possível carregar o resumo.';
        toast.error('Falha ao gerar resumo da mala ❌');
    } finally {
        shareModalLoading.value = false;
    }
};
const shareBagInfo = computed(() => shareSummary.value?.bag ?? null);
const shareItems = computed(() => (Array.isArray(shareSummary.value?.items) ? shareSummary.value.items : []));
const shareSummaryText = computed(() => {
    if (!shareBagInfo.value) {
        return '';
    }
    const bag = shareBagInfo.value;
    const lines = [];
    lines.push(`Resumo da ${bag.name}`);
    lines.push(`Código: ${bag.code ?? '—'}`);
    if (bag.dimensions) {
        lines.push(`Dimensões: ${bag.dimensions}`);
    }
    if (bag.capacity_kg) {
        lines.push(`Capacidade: ${formatKg(Number(bag.capacity_kg) || 0)}`);
    }
    lines.push('');
    lines.push(`Itens embalados: ${bag.totals?.items ?? 0}`);
    lines.push(`Peso total: ${formatKg(Number(bag.totals?.weight_kg) || 0)}`);
    lines.push(`Itens marcados como prontos: ${bag.totals?.packed ?? 0}`);
    lines.push('');
    if ((bag.notes ?? '').trim()) {
        lines.push('Notas:');
        lines.push(bag.notes.trim());
        lines.push('');
    }
    if (Array.isArray(bag.checklist) && bag.checklist.length) {
        lines.push('Checklist:');
        bag.checklist.forEach((entry, index) => {
            lines.push(`${entry.completed ? '✅' : '⬜️'} ${entry.text ?? `Item ${index + 1}`}`);
        });
        lines.push('');
    }
    if (shareItems.value.length) {
        lines.push('Itens na mala:');
        shareItems.value.forEach((item, index) => {
            lines.push(`${index + 1}. ${item.title ?? item.name ?? 'Item'} — ${formatKg(item.weight ?? item.weight_kg ?? 0)}`);
        });
    }
    return lines.join('\n');
});
const fallbackCopyText = (text) => {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.setAttribute('readonly', '');
    textarea.style.position = 'absolute';
    textarea.style.left = '-9999px';
    document.body.appendChild(textarea);
    const selection = document.getSelection();
    const selected = selection?.rangeCount > 0 ? selection.getRangeAt(0) : null;
    textarea.select();
    let success = false;
    try {
        success = document.execCommand('copy');
    } catch (error) {
        success = false;
    }
    document.body.removeChild(textarea);
    if (selected) {
        selection?.removeAllRanges();
        selection?.addRange(selected);
    }
    return success;
};

const showCopyFeedback = (message) => {
    copyFeedback.value = message;
    clearTimeout(copyFeedbackTimer);
    copyFeedbackTimer = setTimeout(() => {
        copyFeedback.value = '';
    }, 2500);
};

const copySummaryToClipboard = async () => {
    if (!shareSummaryText.value) return;
    const text = shareSummaryText.value;
    try {
        if (navigator.clipboard?.writeText) {
            await navigator.clipboard.writeText(text);
        } else if (!fallbackCopyText(text)) {
            throw new Error('copy-failed');
        }
        toast.success('Resumo copiado 📋');
        showCopyFeedback('Resumo copiado!');
    } catch (error) {
        console.error(error);
        const fallbackSuccess = fallbackCopyText(text);
        if (fallbackSuccess) {
            toast.success('Resumo copiado 📋');
            showCopyFeedback('Resumo copiado!');
        } else {
            toast.error('Não foi possível copiar o resumo ❌');
        }
    }
};
const shareSummaryViaWeb = async () => {
    if (!shareSummaryText.value) return;
    if (navigator.share) {
        try {
            await navigator.share({
                title: `Resumo da ${shareBagInfo.value?.name ?? 'mala'}`,
                text: shareSummaryText.value,
            });
        } catch (error) {
            if (error?.name !== 'AbortError') {
                console.error(error);
                copySummaryToClipboard();
            }
        }
        return;
    }
    copySummaryToClipboard();
};
const priorityBadgeClass = (value) => priorityMetaMap[value || 'none']?.chipClass ?? 'bg-slate-100 text-slate-600';
const isPriorityUpdating = (id) => Boolean(priorityLoading[id]);
const setItemPriority = async (item, value) => {
    if (!item) {
        return;
    }
    const normalized = value ?? '';
    if ((item.priority ?? '') === normalized) {
        return;
    }
    priorityLoading[item.id] = true;
    try {
        await decisionStore.updateItemPriority(item.id, normalized || null);
        const meta = priorityMetaMap[normalized || 'none'];
        toast.success(
            normalized
                ? `Prioridade “${meta?.label ?? 'personalizada'}” aplicada ✅`
                : 'Item voltou para prioridade normal ↩︎',
        );
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar a prioridade ❌');
    } finally {
        priorityLoading[item.id] = false;
    }
};

const bulkBagChoice = ref('');
const bulkAssigning = ref(false);

watch(
    bagOptions,
    (options) => {
        if (!options.length) {
            bulkBagChoice.value = '';
            return;
        }
        if (!bulkBagChoice.value || !options.some((option) => option.value === bulkBagChoice.value)) {
            bulkBagChoice.value = options[0].value ?? '';
        }
    },
    { immediate: true },
);

const previewVisible = ref(false);
const previewItem = ref(null);

const openImagePreview = (item) => {
    if (!itemPhoto(item)) return;
    previewItem.value = item;
    previewVisible.value = true;
};

const previewSrc = computed(() => (previewItem.value ? itemPhoto(previewItem.value) : null));
const previewAlt = computed(() => previewItem.value?.title ?? previewItem.value?.name ?? 'Item');

watch(previewVisible, (visible) => {
    if (!visible) {
        previewItem.value = null;
    }
});

const scrollListToTop = () => {
    if (!listContainer.value) return;
    listContainer.value.scrollTo({ top: 0, behavior: 'smooth' });
};

const setActiveFilter = (value) => {
    if (activeFilter.value === value) return;
    activeFilter.value = value;
    nextTick(() => scrollListToTop());
};

watch(searchQuery, () => {
    nextTick(() => scrollListToTop());
});

watch(
    filterOptions,
    (options) => {
        const values = options.map((option) => option.value);
        if (!values.includes(activeFilter.value)) {
            activeFilter.value = 'all';
        }
    },
    { immediate: true },
);

watch(packItems, () => {
    const validIds = new Set(packItems.value.map((item) => item.id));
    Array.from(selection).forEach((id) => {
        if (!validIds.has(id)) {
            selection.delete(id);
        }
    });
});

const itemPhoto = (item) => {
    const source =
        item?.photo?.trim?.() ||
        item?.thumbnail_url?.trim?.() ||
        item?.photo_url?.trim?.() ||
        null;
    if (!source) return null;
    if (failedImages.has(item.id)) return null;
    return source;
};

const hasPhoto = (item) => Boolean(itemPhoto(item));

const markPhotoFailed = (item) => {
    if (!item?.id) return;
    failedImages.add(item.id);
};

const bagLockMap = computed(() => {
    const map = {};
    rawPackBags.value.forEach((bag) => {
        const code = String(bag.code ?? bag.id ?? '');
        const weightRatio = Number(bag.weight_ratio ?? bag.weightRatio ?? 0);
        const volumeRatio = Number(bag.volume_ratio ?? bag.volumeRatio ?? 0);
        const lockedByWeight = Boolean(bag.locked_by_weight ?? bag.lockedByWeight) || weightRatio >= 1;
        const lockedByVolume = Boolean(bag.locked_by_volume ?? bag.lockedByVolume) || volumeRatio >= 1;
        const lockedFlag = bag.locked ?? (lockedByWeight || lockedByVolume);
        const locked = Boolean(lockedFlag);
        map[code] = {
            locked,
            lockedByWeight,
            lockedByVolume,
        };
    });
    return map;
});

const isBagLocked = (code) => {
    const info = bagLockMap.value[String(code ?? '')];
    return Boolean(info?.locked);
};

const bagLockMessage = (code) => {
    const info = bagLockMap.value[String(code ?? '')];
    if (!info?.locked) return '';
    const label = formatBagLabel(code);
    if (info.lockedByWeight && info.lockedByVolume) {
        return `${label} cheia: peso e volume no limite`;
    }
    if (info.lockedByWeight) {
        return `${label} cheia: limite de peso atingido`;
    }
    if (info.lockedByVolume) {
        return `${label} cheia: limite de volume atingido`;
    }
    return `${label} cheia`;
};

const suitcaseSummaries = computed(() =>
    rawPackBags.value.map((bag, index) => {
        const capacityKg = Number(bag.capacity_kg ?? bag.capacity ?? 0) || 0;
        const actualKg = Number(bag.total_kg ?? bag.yes_kg ?? bag.used ?? 0) || 0;
        const reservedKg = Number(bag.reservedAppliedKg ?? bag.reserved_kg ?? bag.reserved_applied_kg ?? 0) || 0;
        const projectedKg = Number(bag.projectedWeightKg ?? bag.projected_weight_kg ?? 0) || 0;
        let effectiveKg = Number(bag.usedWithProjection ?? bag.effective_kg ?? bag.effectiveKg ?? 0);
        if (!effectiveKg) {
            effectiveKg = actualKg + reservedKg + projectedKg;
        }
        const remainingKg = bag.remaining_kg != null ? Number(bag.remaining_kg) : Math.max(capacityKg - effectiveKg, 0);
        const weightRatio = bag.weight_ratio ?? (capacityKg ? effectiveKg / capacityKg : 0);

        const capacityVolumeCm3 = Number(
            bag.capacity_volume_cm3 ??
                bag.capacityVolume_cm3 ??
                bag.capacityVolume ??
                bag.capacity_volume ??
                0,
        ) || 0;
        const actualVolumeCm3 = Number(
            bag.total_volume_cm3 ??
                bag.volume_cm3 ??
                bag.volumeCm3 ??
                bag.used_volume_cm3 ??
                0,
        ) || 0;
        const reservedVolumeCm3 = Number(
            bag.reserved_volume_cm3 ??
                bag.reservedVolumeCm3 ??
                bag.reservedVolumeAppliedCm3 ??
                0,
        ) || 0;
        const projectedVolumeCm3 = Number(bag.projected_volume_cm3 ?? bag.projectedVolumeCm3 ?? 0) || 0;

        let effectiveVolumeCm3 = Number(
            bag.volumeWithProjectionCm3 ??
                bag.effective_volume_cm3 ??
                bag.effectiveVolumeCm3 ??
                0,
        );
        if (!effectiveVolumeCm3) {
            effectiveVolumeCm3 = actualVolumeCm3 + reservedVolumeCm3 + projectedVolumeCm3;
        }

        const remainingVolumeCm3 =
            bag.remaining_volume_cm3 != null
                ? Number(bag.remaining_volume_cm3)
                : bag.remainingVolumeCm3 != null
                    ? Number(bag.remainingVolumeCm3)
                    : capacityVolumeCm3
                        ? Math.max(capacityVolumeCm3 - effectiveVolumeCm3, 0)
                        : null;

        const volumeRatio = bag.volume_ratio ?? (capacityVolumeCm3 ? effectiveVolumeCm3 / capacityVolumeCm3 : 0);

        const lockedByWeight = Boolean(bag.locked_by_weight ?? bag.lockedByWeight) || weightRatio >= 1;
        const lockedByVolume = Boolean(bag.locked_by_volume ?? bag.lockedByVolume) || volumeRatio >= 1;
        const locked = Boolean(bag.locked ?? (lockedByWeight || lockedByVolume));

        let status = bag.status;
        if (!status) {
            if (locked) status = 'Fechado';
            else if (Math.max(weightRatio, volumeRatio) >= 0.9) status = 'Lotado';
            else status = 'Normal';
        }

        return {
            id: String(bag.id ?? `bag-${index}`),
            code: String(bag.code ?? bag.id ?? `bag-${index}`),
            name: bag.name ?? `Mala ${index + 1}`,
            dims: bag.dimensions ?? '—',
            current: effectiveKg,
            max: capacityKg,
            ratio: Math.max(weightRatio, volumeRatio),
            status,
            locked,
            lockReasons: {
                weight: lockedByWeight,
                volume: lockedByVolume,
            },
            weight: {
                actual: actualKg,
                reserved: reservedKg,
                projected: projectedKg,
                effective: effectiveKg,
                remaining: remainingKg,
            },
            volume: {
                actual: actualVolumeCm3,
                reserved: reservedVolumeCm3,
                projected: projectedVolumeCm3,
                effective: effectiveVolumeCm3,
                capacity: capacityVolumeCm3 || null,
                remaining: remainingVolumeCm3,
            },
            notes: bag.notes ?? '',
            checklist: Array.isArray(bag.checklist) ? bag.checklist : [],
            history: Array.isArray(bag.history) ? bag.history : [],
        };
    }),
);
const bagNotesTargets = computed(() =>
    suitcaseSummaries.value.map((bag) => ({
        id: bag.id,
        name: bag.name,
        notes: bag.notes ?? '',
        checklist: Array.isArray(bag.checklist) ? bag.checklist : [],
        history: Array.isArray(bag.history) ? bag.history : [],
    })),
);
const currentBagNotes = computed(() => (selectedBagNotesId.value ? bagNotesDrafts[selectedBagNotesId.value] ?? null : null));
const currentBagMeta = computed(() =>
    bagNotesTargets.value.find((bag) => bag.id === selectedBagNotesId.value) ?? null,
);
const bagNotesDirty = computed(() => Boolean(currentBagNotes.value?.dirty));
const bagNotesCharCount = computed(() => currentBagNotes.value?.notes?.length ?? 0);
const isBagNotesSaving = computed(() => Boolean(selectedBagNotesId.value && bagNotesSaving[selectedBagNotesId.value]));
const maxChecklistReached = computed(() => (currentBagNotes.value?.checklist?.length ?? 0) >= bagNotesLimit);
const bagHistoryById = computed(() => {
    const map = {};
    suitcaseSummaries.value.forEach((bag) => {
        map[bag.id] = Array.isArray(bag.history) ? bag.history : [];
    });
    return map;
});
const currentBagLastUpdate = computed(() => {
    const history = bagHistoryById.value[selectedBagNotesId.value] ?? [];
    return history.length ? history[0] : null;
});
const bagHistoryFeed = computed(() => {
    const entries = [];
    suitcaseSummaries.value.forEach((bag) => {
        (bag.history ?? []).forEach((entry) => {
            entries.push({
                ...entry,
                bagId: bag.id,
                bagName: bag.name,
            });
        });
    });
    return entries
        .sort((a, b) => {
            const dateA = a.created_at ? new Date(a.created_at).getTime() : 0;
            const dateB = b.created_at ? new Date(b.created_at).getTime() : 0;
            return dateB - dateA;
        })
        .slice(0, 8);
});
const priorityTimeline = computed(() => {
    const groups = priorityTimelineKeys.map((key) => {
        const meta = priorityMetaMap[key] ?? {};
        return {
            key,
            label: meta.label ?? key,
            emoji: meta.emoji ?? '•',
            barClass: meta.barClass ?? 'bg-slate-400',
            chipClass: meta.chipClass ?? 'bg-slate-100 text-slate-600',
            total: 0,
            assigned: 0,
            packed: 0,
            pendingNames: [],
        };
    });
    const map = Object.fromEntries(groups.map((group) => [group.key, group]));
    packItems.value.forEach((item) => {
        const key = item.priority ?? '';
        const group = map[key];
        if (!group) {
            return;
        }
        group.total += 1;
        if (item.bag) {
            group.assigned += 1;
        } else if (group.pendingNames.length < 3) {
            const label = (item.title ?? item.name ?? 'Item').toString();
            group.pendingNames.push(label);
        }
        if (item.packed) {
            group.packed += 1;
        }
    });
    groups.forEach((group) => {
        group.progress = group.total ? Math.min((group.assigned / group.total) * 100, 100) : 0;
    });
    return {
        visible: groups.some((group) => group.total > 0),
        groups: groups.filter((group) => group.total > 0),
        essentialPending: map.essential?.pendingNames ?? [],
    };
});

const packTotalCapacityKg = computed(() => {
    const capacity = Number(packTotals.value.total_capacity ?? 0);
    if (capacity > 0) return capacity;
    return rawPackBags.value.reduce((sum, bag) => sum + Number(bag.capacity_kg ?? bag.capacity ?? 0), 0);
});

const packReservedKg = computed(() => Number(packTotals.value.reserved_kg ?? decisionStore.reservedKg ?? 0));

const packEffectiveWeightKg = computed(() =>
    suitcaseSummaries.value.reduce((sum, bag) => sum + Number(bag.weight?.effective ?? 0), 0),
);

const packUsedWeightKg = packEffectiveWeightKg;

const packRemainingWeightKg = computed(() =>
    Math.max(packTotalCapacityKg.value - packEffectiveWeightKg.value, 0),
);

const packTotalVolumeCm3 = computed(() => {
    const total = Number(packTotals.value.total_volume_cm3 ?? 0);
    if (total > 0) return total;
    return rawPackBags.value.reduce(
        (sum, bag) =>
            sum +
            Number(
                bag.capacity_volume_cm3 ??
                    bag.capacityVolume_cm3 ??
                    bag.capacityVolume ??
                    bag.capacity_volume ??
                    0,
            ),
        0,
    );
});

const packReservedVolumeCm3 = computed(() =>
    Number(packTotals.value.reserved_volume_cm3 ?? decisionStore.reservedVolumeCm3 ?? 0),
);

const packEffectiveVolumeCm3 = computed(() =>
    suitcaseSummaries.value.reduce((sum, bag) => sum + Number(bag.volume?.effective ?? 0), 0),
);

const packUsedVolumeCm3 = packEffectiveVolumeCm3;

const packRemainingVolumeCm3 = computed(() =>
    Math.max(packTotalVolumeCm3.value - packEffectiveVolumeCm3.value, 0),
);

const lockedBagsCount = computed(() =>
    rawPackBags.value.filter((bag) => {
        const weightRatio = Number(bag.weight_ratio ?? bag.weightRatio ?? 0);
        const volumeRatio = Number(bag.volume_ratio ?? bag.volumeRatio ?? 0);
        const lockedByWeight = Boolean(bag.locked_by_weight ?? bag.lockedByWeight) || weightRatio >= 1;
        const lockedByVolume = Boolean(bag.locked_by_volume ?? bag.lockedByVolume) || volumeRatio >= 1;
        return Boolean(bag.locked ?? (lockedByWeight || lockedByVolume));
    }).length,
);
const lockedBagNames = computed(() =>
    rawPackBags.value
        .filter((bag) => {
            const weightRatio = Number(bag.weight_ratio ?? bag.weightRatio ?? 0);
            const volumeRatio = Number(bag.volume_ratio ?? bag.volumeRatio ?? 0);
            const lockedByWeight = Boolean(bag.locked_by_weight ?? bag.lockedByWeight) || weightRatio >= 1;
            const lockedByVolume = Boolean(bag.locked_by_volume ?? bag.lockedByVolume) || volumeRatio >= 1;
            return Boolean(bag.locked ?? (lockedByWeight || lockedByVolume));
        })
        .map((bag) => bag.name ?? `Mala ${String(bag.code ?? bag.id ?? '').toUpperCase()}`),
);

const totalBagsCount = computed(() => rawPackBags.value.length);

const packedCount = computed(() => packItems.value.filter((item) => item.packed).length);
const hasPacked = computed(() => packItems.value.some((item) => item.packed));

const allPackedBanner = computed(() => decisionStore.allPacked && packItems.value.length > 0);

const markAllPacked = async (value) => {
    if (!packItems.value.length) return;
    const ids = packItems.value.map((item) => item.id);
    try {
        const operations = [decisionStore.markPacked(ids, value)];
        if (!value) {
            operations.push(decisionStore.assignBagBulk(ids, ''));
        }
        await Promise.all(operations);
        toast.success(value ? 'Itens marcados como embalados ✅' : 'Todos os itens liberados das malas ↩︎');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar os itens ❌');
    }
};

const assignBag = async (item, bag) => {
    if (!item) return;
    if (bag && isBagLocked(bag)) {
        toast.info(bagLockMessage(bag) || 'Esta mala já está cheia');
        return;
    }

    const operations = [];
    if (item.bag !== bag) {
        operations.push(decisionStore.assignBag(item.id, bag));
    }
    if (!item.packed) {
        operations.push(decisionStore.markPacked([item.id], true));
    }

    if (!operations.length) {
        return;
    }

    try {
        await Promise.all(operations);
        const label = bag ? formatBagLabel(bag) : 'Sem mala';
        toast.success(bag ? `Item preparado na ${label}` : 'Item removido da mala');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar o item ❌');
    }
};

const onPackedChange = async (item, checked) => {
    try {
        const operations = [decisionStore.markPacked([item.id], checked)];
        if (!checked && item.bag) {
            operations.push(decisionStore.assignBag(item.id, ''));
        }
        await Promise.all(operations);
        toast.success(checked ? 'Marcado como embalado ✅' : 'Item voltou para a fila e saiu da mala ↩︎');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar o item ❌');
    }
};

const handleBulkAssign = async () => {
    if (!selectedIds.value.length) return;
    bulkAssigning.value = true;
    const bagCode = bulkBagChoice.value ?? '';
    try {
        await decisionStore.assignBagBulk(selectedIds.value, bagCode);
        toast.success(
            bagCode
                ? `Seleção enviada para ${formatBagLabel(bagCode)}`
                : 'Seleção removida das malas',
        );
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível aplicar a seleção ❌');
    } finally {
        bulkAssigning.value = false;
    }
};

const handleBulkPacked = async (value) => {
    if (!selectedIds.value.length) return;
    bulkAssigning.value = true;
    try {
        await decisionStore.markPacked(selectedIds.value, value);
        if (!value) {
            await decisionStore.assignBagBulk(selectedIds.value, '');
        }
        toast.success(value ? 'Seleção marcada como embalada ✅' : 'Seleção voltou para pendentes ↩︎');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar a seleção ❌');
    } finally {
        bulkAssigning.value = false;
    }
};

const itemsByBag = computed(() => {
    const map = {};
    packItems.value.forEach((item) => {
        const code = itemBagCode(item);
        if (!map[code]) {
            map[code] = [];
        }
        map[code].push(item);
    });
    Object.values(map).forEach((items) => {
        items.sort(
            (a, b) => Number(b.weight ?? b.weight_kg ?? 0) - Number(a.weight ?? a.weight_kg ?? 0),
        );
    });
    return map;
});

const rebalanceSuggestion = computed(() => {
    const problematic = suitcaseSummaries.value.find((bag) => {
        const remainingWeight = Number(bag.weight?.remaining ?? 0);
        const remainingVolume = Number(bag.volume?.remaining ?? 0);
        return bag.locked || bag.status === 'Fechado' || remainingWeight <= 0 || remainingVolume <= 0;
    });

    if (!problematic) {
        return null;
    }

    const sourceCode = problematic.code ?? problematic.id ?? '';
    const fromName = formatBagLabel(sourceCode);
    const options = itemsByBag.value[sourceCode] ?? [];
    if (!options.length) {
        return {
            mode: 'info',
            title: 'Sem itens para mover',
            description: `${fromName} está travada, mas nenhum item foi atribuído a ela ainda.`,
        };
    }

    const candidate = options[0];
    const candidateWeight = Number(candidate.weight ?? candidate.weight_kg ?? 0);
    const candidateVolume = Number(candidate.volume_cm3 ?? 0);
    const candidateTitle = candidate.title ?? candidate.name ?? 'Item';

    const targets = suitcaseSummaries.value
        .filter(
            (bag) =>
                (bag.code ?? bag.id ?? '') !== sourceCode
                && !bag.locked
                && bag.status !== 'Fechado',
        )
        .map((bag) => ({
            code: bag.code ?? bag.id ?? '',
            name: bag.name ?? formatBagLabel(bag.code ?? bag.id ?? ''),
            remainingWeight: Number(bag.weight?.remaining ?? 0),
            remainingVolume: Number(bag.volume?.remaining ?? 0),
        }))
        .filter((entry) => entry.remainingWeight > candidateWeight * 0.4);

    if (!targets.length) {
        return {
            mode: 'manual',
            title: 'Nenhuma mala com folga',
            description: `${candidateTitle} é o item mais pesado da ${fromName}. Remova-o temporariamente para liberar ${formatKg(candidateWeight)} e tentar outro arranjo.`,
            itemId: candidate.id,
            freedWeight: candidateWeight,
        };
    }

    const target = targets.sort((a, b) => b.remainingWeight - a.remainingWeight)[0];
    const targetName = target.name ?? formatBagLabel(target.code ?? '');

    return {
        mode: 'action',
        title: 'Sugestão de redistribuição',
        description: `${candidateTitle} pode sair da ${fromName} e liberar ${formatKg(candidateWeight)} indo para ${targetName}.`,
        itemId: candidate.id,
        targetCode: target.code ?? '',
        weightFreed: candidateWeight,
        volumeFreed: candidateVolume,
    };
});

const suggestionLoading = ref(false);

const applyRebalanceSuggestion = async () => {
    const suggestion = rebalanceSuggestion.value;
    if (!suggestion || suggestion.mode !== 'action') return;

    const item = packItems.value.find((candidate) => candidate.id === suggestion.itemId);
    if (!item) return;

    suggestionLoading.value = true;
    try {
        await assignBag(item, suggestion.targetCode);
        toast.success(
            `Enviado para ${formatBagLabel(suggestion.targetCode)} para liberar espaço`,
        );
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível aplicar a sugestão ❌');
    } finally {
        suggestionLoading.value = false;
    }
};

const releaseRebalanceItem = async () => {
    const suggestion = rebalanceSuggestion.value;
    if (!suggestion || suggestion.mode !== 'manual') return;

    const item = packItems.value.find((candidate) => candidate.id === suggestion.itemId);
    if (!item) return;

    suggestionLoading.value = true;
    try {
        await Promise.all([
            decisionStore.assignBag(item.id, ''),
            decisionStore.markPacked([item.id], false),
        ]);
        toast.success('Item liberado para reorganização ↩︎');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível liberar o item ❌');
    } finally {
        suggestionLoading.value = false;
    }
};

const openItemHelp = (item) => {
    const bagLabel = item.bag ? `Na ${formatBagLabel(item.bag)}` : 'Ainda sem mala';
    const weightLabel = `${(item.weight ?? 0).toFixed(1)} kg`;
    const volumeLabel = formatVolume(item) ?? 'Sem volume estimado';
    toast.info(`${item.title ?? item.name}: ${bagLabel} • ${weightLabel} • ${volumeLabel}`);
};

const statusBanner = computed(() => {
    if (lockedBagNames.value.length) {
        return {
            tone: 'yellow',
            emoji: '🧳',
            title: 'Alguma mala travou',
            message: `${lockedBagNames.value.join(', ')} atingiu o limite. Reorganize itens ou remova peso.`,
        };
    }
    if (!packItems.value.length) {
        return {
            tone: 'slate',
            emoji: '📦',
            title: 'Sem itens pendentes',
            message: 'Todos os itens já foram embalados ou removidos. Volte ao Resumo ou Decidir para novas ações.',
        };
    }
    return null;
});

const formatVolume = (item) => {
    const cm3 = item.volume_cm3 ?? null;
    const liters = item.volume_liters ?? (cm3 != null ? cm3 / 1000 : null);
    if (liters == null || Number.isNaN(liters)) {
        return null;
    }
    const cm3Value = cm3 ?? liters * 1000;
    return `${Number(liters).toFixed(1)} L (${numberFormatter.format(Math.round(cm3Value))} cm³)`;
};

const formatBagLabel = (code) => {
    const key = code == null ? '' : String(code);
    return bagLabelMap.value[key] ?? `Mala ${key.toUpperCase()}`;
};

const itemBagCode = (item) => (item?.bag ?? item?.bag_code ?? '').toString();
const isItemInBag = (item, code) => itemBagCode(item) === (code ?? '').toString();
const relativeTimeFormatter = new Intl.RelativeTimeFormat('pt-BR', { numeric: 'auto' });
const formatRelativeTimeLabel = (value) => {
    if (!value) return '';
    const target = new Date(value).getTime();
    if (Number.isNaN(target)) return '';
    const diffMs = target - Date.now();
    const diffMinutes = Math.round(diffMs / (1000 * 60));
    if (Math.abs(diffMinutes) < 60) {
        return relativeTimeFormatter.format(diffMinutes, 'minute');
    }
    const diffHours = Math.round(diffMinutes / 60);
    if (Math.abs(diffHours) < 48) {
        return relativeTimeFormatter.format(diffHours, 'hour');
    }
    const diffDays = Math.round(diffHours / 24);
    return relativeTimeFormatter.format(diffDays, 'day');
};
const formatHistoryMessage = (entry) => {
    if (!entry) return '';
    const meta = entry.meta ?? {};
    const title = meta.item_title ?? 'Item';
    switch (entry.action) {
        case 'added':
            return `${title} entrou na ${entry.bagName}${meta.from_bag_name ? ` (veio da ${meta.from_bag_name})` : ''}`;
        case 'removed':
            return `${title} saiu para reorganizar${meta.to_bag_name ? ` → ${meta.to_bag_name}` : ''}`;
        case 'notes_updated': {
            const count = meta.checklist_count ?? 0;
            if (count > 0) {
                return `Checklist atualizada (${count} item${count === 1 ? '' : 's'})`;
            }
            return 'Notas atualizadas';
        }
        default:
            return `${title} atualizado`;
    }
};
</script>
