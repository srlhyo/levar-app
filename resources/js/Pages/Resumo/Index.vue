<template>
    <Head title="Resumo" />
    <AppLayout>
        <template #title>Resumo</template>
        <template #subtitle>Uma visão geral das malas, pendências e itens que vão com a gente.</template>

        <section class="resumo-panel">
            <div class="resumo-panel__head">
                <div class="resumo-panel__title-block">
                    <TileIcon3D tone="slate" class="resumo-panel__icon">
                        <Layers3 class="h-5 w-5" />
                    </TileIcon3D>
                    <div>
                        <p class="resumo-eyebrow">Panorama consolidado</p>
                        <h2 class="resumo-panel__title">Panorama da mudança</h2>
                        <p class="resumo-panel__subtitle">
                            Indicadores vivos com totais, pendências e atalhos rápidos para reequilibrar a mudança.
                        </p>
                    </div>
                </div>
                <div class="resumo-panel__toggles">
                    <button type="button" class="resumo-panel__link" @click="setAllPanoramaSections(true)">Expandir tudo</button>
                    <span aria-hidden="true" class="resumo-panel__divider">•</span>
                    <button type="button" class="resumo-panel__link" @click="setAllPanoramaSections(false)">Recolher tudo</button>
                </div>
            </div>

            <div class="resumo-accordion-group">
                <article class="resumo-accordion">
                    <button
                        type="button"
                        class="resumo-accordion__trigger"
                        @click="togglePanoramaSection('counts')"
                    >
                        <div class="resumo-accordion__title">
                            <TileIcon3D tone="emerald" class="resumo-accordion__icon">
                                <Gauge class="h-4 w-4" />
                            </TileIcon3D>
                            <span>Totais por decisão</span>
                        </div>
                        <ChevronDown class="h-4 w-4 transition" :class="panoramaSections.counts ? 'rotate-180' : ''" />
                    </button>
                    <transition name="fade">
                        <div v-if="panoramaSections.counts" class="resumo-accordion__body">
                            <div class="resumo-summary-grid">
                                <div class="resumo-summary-card resumo-summary-card--emerald">
                                    <div class="resumo-summary-card__icon-wrap">
                                        <TileIcon3D tone="emerald" class="resumo-summary-card__icon">
                                            <Check class="h-4 w-4" />
                                        </TileIcon3D>
                                    </div>
                                    <div>
                                        <p class="resumo-summary-card__label">Vai levar</p>
                                        <p class="resumo-summary-card__value">{{ stats.take }}</p>
                                        <button
                                            v-if="takeItems.length"
                                            type="button"
                                            class="resumo-summary-card__action"
                                            :disabled="globalRequeueLoading.take"
                                            @click="handleGlobalRequeue('take')"
                                        >
                                            <span v-if="globalRequeueLoading.take" class="animate-pulse">Reinserindo…</span>
                                            <span v-else>Reinserir no Decidir</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="resumo-summary-card resumo-summary-card--amber">
                                    <div class="resumo-summary-card__icon-wrap">
                                        <TileIcon3D tone="amber" class="resumo-summary-card__icon">
                                            <Clock class="h-4 w-4" />
                                        </TileIcon3D>
                                    </div>
                                    <div>
                                        <p class="resumo-summary-card__label">Pendentes</p>
                                        <p class="resumo-summary-card__value">{{ stats.pending }}</p>
                                        <button
                                            v-if="pendingItems.length"
                                            type="button"
                                            class="resumo-summary-card__action"
                                            :disabled="globalRequeueLoading.pending"
                                            @click="handleGlobalRequeue('pending')"
                                        >
                                            <span v-if="globalRequeueLoading.pending" class="animate-pulse">Reinserindo…</span>
                                            <span v-else>Reinserir no Decidir</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="resumo-summary-card resumo-summary-card--rose">
                                    <div class="resumo-summary-card__icon-wrap">
                                        <TileIcon3D tone="crimson" class="resumo-summary-card__icon">
                                            <X class="h-4 w-4" />
                                        </TileIcon3D>
                                    </div>
                                    <div>
                                        <p class="resumo-summary-card__label">Não levar</p>
                                        <p class="resumo-summary-card__value">{{ stats.leave }}</p>
                                        <button
                                            v-if="leaveItems.length"
                                            type="button"
                                            class="resumo-summary-card__action"
                                            :disabled="globalRequeueLoading.leave"
                                            @click="handleGlobalRequeue('leave')"
                                        >
                                            <span v-if="globalRequeueLoading.leave" class="animate-pulse">Reinserindo…</span>
                                            <span v-else>Reinserir no Decidir</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="resumo-summary-card resumo-summary-card--slate">
                                    <div class="resumo-summary-card__icon-wrap">
                                        <TileIcon3D tone="slate" class="resumo-summary-card__icon">
                                            <Layers3 class="h-4 w-4" />
                                        </TileIcon3D>
                                    </div>
                                    <div>
                                        <p class="resumo-summary-card__label">Indefinidos</p>
                                        <p class="resumo-summary-card__value">{{ stats.undecided }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </transition>
                </article>

                <article class="resumo-accordion">
                    <button
                        type="button"
                        class="resumo-accordion__trigger"
                        @click="togglePanoramaSection('totals')"
                    >
                        <div class="resumo-accordion__title">
                            <TileIcon3D tone="slate" class="resumo-accordion__icon">
                                <ListChecks class="h-4 w-4" />
                            </TileIcon3D>
                            <span>Totais catalogados</span>
                        </div>
                        <ChevronDown class="h-4 w-4 transition" :class="panoramaSections.totals ? 'rotate-180' : ''" />
                    </button>
                    <transition name="fade">
                        <div v-if="panoramaSections.totals" class="resumo-accordion__body">
                            <div class="resumo-totals-grid">
                                <div class="resumo-total-card resumo-total-card--slate">
                                    <TileIcon3D tone="slate" class="resumo-total-card__icon">
                                        <Layers3 class="h-4 w-4" />
                                    </TileIcon3D>
                                    <div>
                                        <p class="resumo-total-card__label">Total catalogado</p>
                                        <p class="resumo-total-card__value">{{ stats.total }}</p>
                                    </div>
                                </div>
                                <div class="resumo-total-card resumo-total-card--emerald">
                                    <TileIcon3D tone="emerald" class="resumo-total-card__icon">
                                        <Activity class="h-4 w-4" />
                                    </TileIcon3D>
                                    <div>
                                        <p class="resumo-total-card__label">Processados</p>
                                        <p class="resumo-total-card__value">{{ processedSummary }}</p>
                                    </div>
                                </div>
                                <div class="resumo-total-card resumo-total-card--amber">
                                    <TileIcon3D tone="amber" class="resumo-total-card__icon">
                                        <Clock class="h-4 w-4" />
                                    </TileIcon3D>
                                    <div>
                                        <p class="resumo-total-card__label">Pendentes (total)</p>
                                        <p class="resumo-total-card__value">{{ stats.pending_total ?? pendingTotal }}</p>
                                    </div>
                                </div>
                                <div class="resumo-total-card resumo-total-card--indigo">
                                    <TileIcon3D tone="indigo" class="resumo-total-card__icon">
                                        <Archive class="h-4 w-4" />
                                    </TileIcon3D>
                                    <div>
                                        <p class="resumo-total-card__label">Cartas no deck</p>
                                        <p class="resumo-total-card__value">{{ pendingDeckCount }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </transition>
                </article>

                <article class="resumo-accordion">
                    <button
                        type="button"
                        class="resumo-accordion__trigger"
                        @click="togglePanoramaSection('progress')"
                    >
                        <div class="resumo-accordion__title">
                            <TileIcon3D tone="indigo" class="resumo-accordion__icon">
                                <BarChart3 class="h-4 w-4" />
                            </TileIcon3D>
                            <span>Indicadores rápidos</span>
                        </div>
                        <ChevronDown class="h-4 w-4 transition" :class="panoramaSections.progress ? 'rotate-180' : ''" />
                    </button>
                    <transition name="fade">
                        <div v-if="panoramaSections.progress" class="resumo-accordion__body">
                            <div class="resumo-quickstats">
                                <div class="resumo-quickstat">
                                    <TileIcon3D tone="emerald" class="resumo-quickstat__icon">
                                        <Activity class="h-4 w-4" />
                                    </TileIcon3D>
                                    <div>
                                        <p class="resumo-quickstat__label">Progresso geral</p>
                                        <p class="resumo-quickstat__value">{{ completionPercent }}% concluído</p>
                                    </div>
                                </div>
                                <div class="resumo-quickstat">
                                    <TileIcon3D tone="sky" class="resumo-quickstat__icon">
                                        <Package class="h-4 w-4" />
                                    </TileIcon3D>
                                    <div>
                                        <p class="resumo-quickstat__label">Pronto para levar</p>
                                        <p class="resumo-quickstat__value">{{ readyPercent }}% dos itens</p>
                                    </div>
                                </div>
                                <div class="resumo-quickstat">
                                    <TileIcon3D tone="amber" class="resumo-quickstat__icon">
                                        <Archive class="h-4 w-4" />
                                    </TileIcon3D>
                                    <div>
                                        <p class="resumo-quickstat__label">Já embalados</p>
                                        <p class="resumo-quickstat__value">{{ packedPercent }}% embalado</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </transition>
                </article>
            </div>
        </section>

        <section
            v-if="statusBanner"
            class="resumo-status-card"
            :class="`resumo-status-card--${statusBanner.tone ?? 'slate'}`"
        >
            <TileIcon3D :tone="statusBanner.tone ?? 'slate'" class="resumo-status-card__icon">
                <span aria-hidden="true" class="text-xl">{{ statusBanner.emoji }}</span>
            </TileIcon3D>
            <div class="resumo-status-card__body">
                <p class="resumo-status-card__title">{{ statusBanner.title }}</p>
                <p class="resumo-status-card__message">{{ statusBanner.message }}</p>
                <div class="resumo-status-card__actions">
                    <button
                        v-for="action in statusBanner.actions"
                        :key="action.label"
                        type="button"
                        class="resumo-status-card__button"
                        :class="statusBanner.tone === 'green' ? 'resumo-status-card__button--warm' : ''"
                        @click="action.handler?.()"
                    >
                        {{ action.label }}
                    </button>
                </div>
            </div>
        </section>

        <section class="resumo-panel-soft">
            <div class="resumo-panel-soft__head">
                <div>
                    <p class="resumo-eyebrow resumo-eyebrow--muted">Capacidade das malas</p>
                    <h2 class="resumo-panel-soft__title">Distribua peso e volume com segurança</h2>
                    <p class="resumo-panel-soft__subtitle">
                        Monitore peso e volume de cada mala. Quando algo lotar, siga para Embalar ou reinsira itens no deck do Decidir.
                    </p>
                </div>
                <div class="resumo-panel-soft__cta">
                    <button type="button" class="resumo-cta resumo-cta--warm" @click="goToPack">
                        Abrir Embalar
                    </button>
                    <button type="button" class="resumo-cta resumo-cta--cool" @click="goToDecidir">
                        Ir para Decidir
                        <span aria-hidden="true">→</span>
                    </button>
                </div>
            </div>

            <div class="resumo-accordion-group resumo-accordion-group--soft">
                <article class="resumo-accordion resumo-accordion--ghost">
                    <button
                        type="button"
                        class="resumo-accordion__trigger"
                        @click="toggleCapacitySection('bars')"
                    >
                        <div class="resumo-accordion__title">
                            <TileIcon3D tone="sky" class="resumo-accordion__icon">
                                <RefreshCcw class="h-4 w-4" />
                            </TileIcon3D>
                            <span>Resumo de capacidades</span>
                        </div>
                        <ChevronDown class="h-4 w-4 transition" :class="capacitySections.bars ? 'rotate-180' : ''" />
                    </button>
                    <transition name="fade">
                        <div v-if="capacitySections.bars" class="resumo-accordion__body space-y-3">
                            <div class="resumo-capacity-card">
                                <button
                                    type="button"
                                    class="resumo-capacity-card__trigger"
                                    @click="toggleCapacityBarSection('weight')"
                                >
                                    <div class="resumo-capacity-card__label">
                                        <TileIcon3D tone="emerald" class="resumo-capacity-card__icon">
                                            <Weight class="h-4 w-4" />
                                        </TileIcon3D>
                                        <div>
                                            <p class="resumo-capacity-card__title">Peso total disponível</p>
                                            <p class="resumo-capacity-card__meta">
                                                {{ formatKg(totalCapacityKg) }} • {{ formatKg(remainingCapacityKg) }} livres
                                            </p>
                                        </div>
                                    </div>
                                    <ChevronDown class="h-4 w-4 transition" :class="capacityBarSections.weight ? 'rotate-180' : ''" />
                                </button>
                                <transition name="fade">
                                    <div v-if="capacityBarSections.weight" class="resumo-capacity-card__body">
                                        <div v-if="capacitySkeletonVisible" class="resumo-capacity-card__skeleton" />
                                        <div v-else>
                                            <WeightBar
                                                :bags="bagSummaries"
                                                :reserved-kg="stats.reservedKg ?? 0"
                                                :total-capacity-kg="totalCapacityKg"
                                                :yes-weight-kg="yesWeightKg"
                                            />
                                        </div>
                                    </div>
                                </transition>
                            </div>

                            <div class="resumo-capacity-card">
                                <button
                                    type="button"
                                    class="resumo-capacity-card__trigger"
                                    @click="toggleCapacityBarSection('volume')"
                                >
                                    <div class="resumo-capacity-card__label">
                                        <TileIcon3D tone="indigo" class="resumo-capacity-card__icon">
                                            <Cuboid class="h-4 w-4" />
                                        </TileIcon3D>
                                        <div>
                                            <p class="resumo-capacity-card__title">Volume total disponível</p>
                                            <p class="resumo-capacity-card__meta">
                                                {{ formatLiters(volumeTotalCapacityCm3) }} ({{ formatCm3(volumeTotalCapacityCm3) }})
                                                • {{ formatLiters(volumeRemainingCm3) }} livres
                                            </p>
                                        </div>
                                    </div>
                                    <ChevronDown class="h-4 w-4 transition" :class="capacityBarSections.volume ? 'rotate-180' : ''" />
                                </button>
                                <transition name="fade">
                                    <div v-if="capacityBarSections.volume" class="resumo-capacity-card__body">
                                        <div v-if="capacitySkeletonVisible" class="resumo-capacity-card__skeleton" />
                                        <div v-else>
                                            <VolumeBar
                                                :bags="bagSummaries"
                                                :reserved-cm3="volumeReservedCm3"
                                                :total-capacity-cm3="volumeTotalCapacityCm3"
                                                :used-cm3="volumeUsedCm3"
                                            />
                                        </div>
                                    </div>
                                </transition>
                            </div>
                        </div>
                    </transition>
                </article>

                <article class="resumo-accordion resumo-accordion--ghost">
                    <button
                        type="button"
                        class="resumo-accordion__trigger"
                        @click="toggleCapacitySection('cards')"
                    >
                        <div class="resumo-accordion__title">
                            <TileIcon3D tone="slate" class="resumo-accordion__icon">
                                <Briefcase class="h-4 w-4" />
                            </TileIcon3D>
                            <span>Detalhe por mala</span>
                        </div>
                        <ChevronDown class="h-4 w-4 transition" :class="capacitySections.cards ? 'rotate-180' : ''" />
                    </button>
                    <transition name="fade">
                        <div v-if="capacitySections.cards" class="resumo-accordion__body">
                            <div v-if="suitcaseCards.length" class="resumo-suitcase-grid">
                                <Suitcase
                                    v-for="bag in suitcaseCards"
                                    :key="bag.id"
                                    :name="bag.name"
                                    :dims="bag.dims"
                                    :current="bag.current"
                                    :max="bag.max"
                                    :status="bag.status"
                                    :ratio="bag.ratio"
                                    :weight="bag.weight"
                                    :volume="bag.volume"
                                />
                            </div>
                            <div v-else class="resumo-empty-card">
                                <p class="font-semibold text-slate-800">Nenhuma mala cadastrada ainda.</p>
                                <p class="text-sm text-slate-600">Use a tela Embalar para configurar as malas e acompanhar os espaços utilizados.</p>
                            </div>
                        </div>
                    </transition>
                </article>
            </div>
        </section>

        <section class="resumo-items-card">
            <div class="resumo-items-card__head">
                <div class="resumo-items-card__title-block">
                    <TileIcon3D tone="slate" class="resumo-items-card__icon resumo-items-card__icon--glow">
                        <ListChecks class="h-5 w-5" />
                    </TileIcon3D>
                    <div>
                        <p class="resumo-eyebrow resumo-eyebrow--muted">Listas por decisão</p>
                        <h2 class="resumo-items-card__title">Itens por decisão</h2>
                        <p class="resumo-items-card__subtitle">
                            Navegue pelos itens marcados como levar, pendentes ou não levar com filtros avançados e seleção rápida.
                        </p>
                    </div>
                </div>
            </div>
            <div class="resumo-badge-row">
                <span class="resumo-badge resumo-badge--emerald">
                    <TileIcon3D tone="emerald" class="resumo-badge__icon">
                        <Check class="h-3.5 w-3.5" />
                    </TileIcon3D>
                    <span>Levar</span>
                    <span class="resumo-badge__value">{{ stats.take }}</span>
                </span>
                <span class="resumo-badge resumo-badge--amber">
                    <TileIcon3D tone="amber" class="resumo-badge__icon">
                        <Clock class="h-3.5 w-3.5" />
                    </TileIcon3D>
                    <span>Pendentes</span>
                    <span class="resumo-badge__value">{{ stats.pending_total ?? pendingTotal }}</span>
                </span>
                <span class="resumo-badge resumo-badge--rose">
                    <TileIcon3D tone="rose" class="resumo-badge__icon">
                        <X class="h-3.5 w-3.5" />
                    </TileIcon3D>
                    <span>Não levar</span>
                    <span class="resumo-badge__value">{{ stats.leave }}</span>
                </span>
            </div>

            <Tabs v-model="activeTab" :items="tabItems" label="Listas por decisão">
                <div v-if="showListCard" class="resumo-items-shell">
                    <div class="resumo-filter-panel">
                        <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                            <div class="resumo-search-grid">
                                <div class="resumo-search-card">
                                    <TileIcon3D tone="slate" class="resumo-search-card__icon">
                                        <Search class="h-4 w-4" />
                                    </TileIcon3D>
                                    <div class="resumo-search-card__body">
                                        <p class="resumo-search-card__label">Buscar itens</p>
                                        <input
                                            v-model="searchQuery"
                                            type="search"
                                            placeholder="Buscar por nome, notas ou mala…"
                                            class="resumo-search-card__input"
                                        />
                                        <span class="resumo-search-card__meta">
                                            {{ totalFilteredCount }} resultado(s)
                                        </span>
                                    </div>
                                </div>
                                <button
                                    type="button"
                                    class="resumo-filter-toggle"
                                    @click="toggleFilters"
                                >
                                    <SlidersHorizontal class="h-4 w-4" />
                                    {{ filtersExpanded ? 'Ocultar filtros' : 'Mostrar filtros' }}
                                </button>
                                <FilterMenu
                                    :show="showFiltersPanel"
                                    :page-size.sync="pageSize"
                                    :page-options="pageSizeOptions"
                                    @clear="handleClearFilters"
                                />
                            </div>
                            <div class="resumo-list-meta">
                                Exibindo
                                <span class="font-semibold text-slate-900">{{ pageStart }}–{{ pageEnd }}</span>
                                de
                                <span class="font-semibold text-slate-900">{{ totalFilteredCount }}</span>
                                itens
                            </div>
                        </div>
                        <div class="resumo-select-row">
                            <label class="resumo-select-all">
                                <input
                                    ref="selectAllRef"
                                    type="checkbox"
                                    class="resumo-select-all__input"
                                    :checked="allSelected"
                                    @change="toggleSelectAll"
                                />
                                <span>Selecionar todos</span>
                            </label>
                            <div class="resumo-select-actions">
                                <button
                                    type="button"
                                    class="resumo-cta resumo-cta--cool resumo-cta--compact"
                                    :disabled="!selectedCount"
                                    @click="handleBulkRequeue"
                                    title="Devolver a seleção para o deck da tela Decidir"
                                >
                                    ↩ Voltar para o deck do Decidir
                                </button>
                                <span v-if="selectedCount" class="resumo-select-count">
                                    {{ selectedCount }} selecionado(s)
                                </span>
                            </div>
                        </div>
                        <div
                            v-if="showBulkBagAssign"
                            class="resumo-bulk-assign"
                        >
                            <span class="font-semibold text-slate-800">Enviar seleção para</span>
                            <select
                                v-model="bulkBagChoice"
                                class="resumo-bulk-assign__select"
                            >
                                <option value="">Sem mala</option>
                                <option v-for="bag in bagOptions" :key="bag.value" :value="bag.value">
                                    {{ bag.label }}
                                </option>
                            </select>
                            <button
                                type="button"
                                class="resumo-bulk-assign__action"
                                :disabled="bulkAssignLoading"
                                @click="handleBulkAssign"
                            >
                                <span
                                    v-if="bulkAssignLoading"
                                    class="h-2 w-2 animate-ping rounded-full bg-white"
                                    aria-hidden="true"
                                />
                                Aplicar
                            </button>
                        </div>
                    </div>
                    <div class="relative">
                        <div class="pointer-events-none absolute inset-x-0 top-0 h-6 rounded-t-3xl bg-gradient-to-b from-white via-white/80 to-transparent z-10"></div>
                        <div class="pointer-events-none absolute inset-x-0 bottom-0 h-6 rounded-b-3xl bg-gradient-to-t from-white via-white/80 to-transparent z-10"></div>
                        <div
                            ref="listContainer"
                            class="max-h-[72vh] overflow-y-auto pr-2 pb-6 space-y-4"
                        >
                            <div class="space-y-3 px-4">
                                <ItemRow
                                    v-for="item in currentItems"
                                    :key="item.id"
                                    :item="item"
                                    :selected="currentSelection.has(item.id)"
                                    :show-delete="false"
                                    @toggle-select="toggleSelection"
                                />
                            </div>

                            <div
                                v-if="totalPages > 1"
                                class="resumo-pagination"
                            >
                                <div class="flex flex-wrap items-center justify-between gap-3">
                                    <div class="space-x-2">
                                        <button
                                            type="button"
                                            class="resumo-pagination__button"
                                            :disabled="currentPage <= 1"
                                            @click="currentPage = Math.max(currentPage - 1, 1)"
                                        >
                                            ← Anterior
                                        </button>
                                        <button
                                            type="button"
                                            class="resumo-pagination__button"
                                            :disabled="currentPage >= totalPages"
                                            @click="currentPage = Math.min(currentPage + 1, totalPages)"
                                        >
                                            Próxima →
                                        </button>
                                    </div>
                                    <div class="resumo-pagination__meta">
                                        <span>Página</span>
                                        <input
                                            v-model.number="currentPage"
                                            type="number"
                                            min="1"
                                            :max="totalPages"
                                            class="resumo-pagination__input"
                                        />
                                        <span>de {{ totalPages }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <transition name="slide-up">
                        <div
                            v-if="selectedCount"
                            class="resumo-selection-bar"
                        >
                            <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-end">
                                <button
                                    type="button"
                                    class="resumo-cta resumo-cta--cool"
                                    @click="handleBulkRequeue"
                                >
                                    ↩ Voltar para o deck do Decidir
                                </button>
                                <button
                                    type="button"
                                    class="resumo-cta resumo-cta--ghost"
                                    @click="clearCurrentSelection"
                                >
                                    Limpar seleção
                                </button>
                            </div>
                        </div>
                    </transition>

                </div>

                <div
                    v-else
                    class="resumo-empty-card mt-4 text-center"
                >
                    <p class="text-base font-semibold text-slate-800">{{ currentEmpty.title }}</p>
                    <p class="mt-1 text-sm text-slate-600">{{ currentEmpty.description }}</p>
                </div>
            </Tabs>
        </section>

    </AppLayout>
</template>

<script setup>
import { Head, usePage, router } from '@inertiajs/vue3';
import { computed, inject, nextTick, onBeforeUnmount, onMounted, reactive, ref, watch, watchEffect } from 'vue';
import {
    Activity,
    Archive,
    BarChart3,
    Briefcase,
    Check,
    ChevronDown,
    Clock,
    Cuboid,
    Gauge,
    Layers3,
    ListChecks,
    Package,
    Search,
    RefreshCcw,
    SlidersHorizontal,
    X,
    Weight,
} from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import FilterMenu from '@/Components/FilterMenu.vue';
import ItemRow from '@/Components/ItemRow.vue';
import Suitcase from '@/Components/Suitcase.vue';
import TileIcon3D from '@/Components/home/TileIcon3D.vue';
import Tabs from '@/Components/Tabs.vue';
import VolumeBar from '@/Components/VolumeBar.vue';
import WeightBar from '@/Components/WeightBar.vue';
import { useDecisionStore } from '@/stores/decision';
import { toast } from '@/utils/toast';

const decisionStore = useDecisionStore();
const page = usePage();
const move = computed(() => page.props.move ?? null);

watchEffect(() => {
    decisionStore.setMove(move.value);
});

const goToPack = () => {
    router.visit('/pick');
};

const goToDecidir = () => {
    router.visit('/decidir');
};

const panoramaSections = reactive({
    counts: false,
    totals: false,
    progress: false,
});
const capacitySections = reactive({
    bars: false,
    cards: false,
});
const capacityBarSections = reactive({
    weight: false,
    volume: false,
});
const setAllPanoramaSections = (state) => {
    Object.keys(panoramaSections).forEach((key) => {
        panoramaSections[key] = state;
    });
};
const togglePanoramaSection = (key) => {
    panoramaSections[key] = !panoramaSections[key];
};
const toggleCapacitySection = (key) => {
    capacitySections[key] = !capacitySections[key];
};
const toggleCapacityBarSection = (key) => {
    capacityBarSections[key] = !capacityBarSections[key];
};
const activeTab = ref('take');
const selectAllRef = ref(null);
const selection = reactive({
    take: new Set(),
    pending: new Set(),
    leave: new Set(),
});
const globalRequeueLoading = reactive({
    take: false,
    pending: false,
    leave: false,
});
const bulkBagChoice = ref('');
const bulkAssignLoading = ref(false);

const takeItems = computed(() => decisionStore.takeList ?? []);
const pendingItems = computed(() => decisionStore.pendingList ?? []);
const undecidedItems = computed(() => decisionStore.undecidedList ?? []);
const leaveItems = computed(() => decisionStore.leaveList ?? []);
const isLoadingResumo = computed(() => decisionStore.loading.resumo);
const bagOptions = computed(() => {
    const source = decisionStore.resumo.bags ?? move.value?.bags ?? [];
    if (!Array.isArray(source)) return [];
    const seen = new Set();
    const options = [];
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
const hasBagOptions = computed(() => bagOptions.value.length > 0);
const bagLabelMap = computed(() => {
    const map = { '': 'Sem mala' };
    bagOptions.value.forEach((option) => {
        map[option.value] = option.label;
    });
    return map;
});
const allResumoItems = computed(() => {
    const map = new Map();
    [...takeItems.value, ...pendingItems.value, ...undecidedItems.value, ...leaveItems.value].forEach((item) => {
        map.set(item.id, item);
    });
    return Array.from(map.values());
});

const decisionLabels = {
    take: 'Itens para levar',
    pending: 'Pendentes',
    leave: 'Itens que não vão',
};

const collectIdsForDecision = (key) => {
    switch (key) {
        case 'take':
            return takeItems.value.map((item) => item.id);
        case 'pending':
            return pendingItems.value.map((item) => item.id);
        case 'leave':
            return leaveItems.value.map((item) => item.id);
        default:
            return [];
    }
};

const tabItems = computed(() => [
    {
        key: 'take',
        label: 'Levar',
        badge: decisionStore.yesCount,
        icon: '✔',
        accent: 'emerald',
        description: 'Itens confirmados para ir',
    },
    {
        key: 'pending',
        label: 'Pendentes',
        badge: pendingItems.value.length,
        icon: '⏳',
        accent: 'amber',
        description: 'Aguardam decisão',
    },
    {
        key: 'leave',
        label: 'Não levar',
        badge: decisionStore.noCount,
        icon: '✖',
        accent: 'rose',
        description: 'Itens descartados',
    },
]);

const listsByTab = computed(() => ({
    take: takeItems.value,
    pending: pendingItems.value,
    leave: leaveItems.value,
}));

const rawTabItems = computed(() => listsByTab.value[activeTab.value] ?? []);

const searchQuery = ref('');
const pageSizeOptions = [10, 25, 50, 100];
const defaultPageSize = 25;
const pageSize = ref(defaultPageSize);
const currentPage = ref(1);
const filtersExpanded = ref(false);
const filtersDirty = computed(
    () => Boolean(searchQuery.value.trim()) || pageSize.value !== defaultPageSize,
);
const showFiltersPanel = computed(() => filtersExpanded.value || filtersDirty.value);
watch(filtersDirty, (dirty) => {
    if (dirty) {
        filtersExpanded.value = true;
    }
});
const toggleFilters = () => {
    filtersExpanded.value = !filtersExpanded.value;
};

const normalize = (value) => (value ?? '').toString().toLowerCase();

const filteredItems = computed(() => {
    const query = normalize(searchQuery.value);

    return rawTabItems.value.filter((item) => {
        if (!query) return true;

        const bagLabel = item.bag_name ?? (item.bag ? `Mala ${item.bag}` : '');
        const haystack = normalize(
            `${item.title ?? ''} ${item.notes ?? ''} ${item.category ?? ''} ${item.section ?? ''} ${item.bag ?? ''} ${bagLabel}`,
        );

        return haystack.includes(query);
    });
});

const totalFilteredCount = computed(() => filteredItems.value.length);
const showListCard = computed(() => totalFilteredCount.value > 0 || Boolean(searchQuery.value.trim()));

const totalPages = computed(() => {
    if (!totalFilteredCount.value) return 0;
    return Math.max(1, Math.ceil(totalFilteredCount.value / pageSize.value));
});

const currentItems = computed(() => {
    if (!totalFilteredCount.value) return [];
    const start = (currentPage.value - 1) * pageSize.value;
    return filteredItems.value.slice(start, start + pageSize.value);
});

const pageStart = computed(() => {
    if (!totalFilteredCount.value) return 0;
    return Math.min((currentPage.value - 1) * pageSize.value + 1, totalFilteredCount.value);
});

const pageEnd = computed(() => {
    if (!totalFilteredCount.value) return 0;
    return Math.min(pageStart.value + pageSize.value - 1, totalFilteredCount.value);
});

const currentSelection = computed(() => selection[activeTab.value] ?? new Set());
const selectedIds = computed(() => Array.from(currentSelection.value));
const selectedCount = computed(() => selectedIds.value.length);
const allSelected = computed(
    () => currentItems.value.length > 0 && selectedIds.value.length === currentItems.value.length,
);
const someSelected = computed(
    () => selectedIds.value.length > 0 && selectedIds.value.length < currentItems.value.length,
);
const showBulkBagAssign = computed(
    () => activeTab.value === 'take' && hasBagOptions.value && selectedCount.value > 0,
);

const emptyStates = {
    take: {
        title: 'Nada por aqui ainda.',
        description: 'Decida itens no deck para montar a lista de levar.',
    },
    pending: {
        title: 'Sem pendências.',
        description: 'Os itens adiados aparecem aqui para retomar depois.',
    },
    leave: {
        title: 'Nenhum item marcado como “Não levar”.',
        description: 'Quando você descarta algo, ele aparece aqui.',
    },
};

const currentEmpty = computed(() => emptyStates[activeTab.value] ?? emptyStates.take);

const rawStats = computed(() => decisionStore.resumo.stats ?? {});

const pendingDeckCount = computed(() => rawStats.value.pending_deck ?? undecidedItems.value.length ?? 0);
const pendingBacklog = computed(() => rawStats.value.pending ?? pendingItems.value.length ?? 0);
const pendingTotal = computed(() => rawStats.value.pending_total ?? pendingBacklog.value);

const stats = computed(() => {
    const base = rawStats.value;
    const total = base.total ?? 0;
    const take = base.take ?? decisionStore.yesCount;
    const leave = base.leave ?? decisionStore.noCount;
    const pending = base.pending ?? pendingBacklog.value;
    const undecided = base.undecided ?? Math.max(total - (take + leave + pending), 0);
    const decided = base.decided ?? (take + leave);
    const processed = base.processed ?? (take + leave + pending);
    const reserved = base.reservedKg ?? decisionStore.reservedKg ?? 0;
    const totalCapacity = base.totalCapacityKg ?? 0;

    const takeList = decisionStore.resumo.lists.take ?? [];
    const fallbackYesWeight = takeList.reduce(
        (sum, item) => sum + (Number(item.weight ?? item.weight_kg ?? item.weightKg ?? 0) || 0),
        0,
    );
    const fallbackYesVolume = takeList.reduce((sum, item) => {
        if (item.volume_cm3 != null) return sum + Number(item.volume_cm3);
        if (item.volume_liters != null) return sum + Number(item.volume_liters) * 1000;
        if (item.dimensions) {
            const parts = item.dimensions
                .split(/[x×]/i)
                .map((part) => parseFloat(part.replace(/[^0-9,.]/g, '').replace(',', '.')))
                .filter((value) => !Number.isNaN(value) && value > 0);
            if (parts.length >= 3) {
                return sum + parts.slice(0, 3).reduce((acc, value) => acc * value, 1);
            }
        }
        return sum;
    }, 0);

    const yesWeight = base.yesWeightKg ?? fallbackYesWeight;
    const remainingCapacity = base.remainingCapacityKg ?? Math.max(totalCapacity - reserved - yesWeight, 0);

    const summaryVolumes = base.volumes ?? base.dimensions ?? null;
    const yesVolumeCm3 = summaryVolumes?.volume_cm3 ?? fallbackYesVolume;

    const items = allResumoItems.value;
    const packed = items.filter((item) => item.packed).length;

    return {
        ...base,
        total,
        take,
        leave,
        pending,
        pending_total: pendingTotal.value,
        pending_deck: pendingDeckCount.value,
        undecided,
        decided,
        processed,
        remaining: base.remaining ?? Math.max(0, total - processed),
        packed,
        reservedKg: reserved,
        totalCapacityKg: totalCapacity,
        yesWeightKg: yesWeight,
        remainingCapacityKg: remainingCapacity,
        yesVolumeCm3,
    };
});

const processedSummary = computed(() => stats.value.processed ?? ((stats.value.decided ?? 0) + (stats.value.pending ?? 0)));

const completionPercent = computed(() => {
    if (!stats.value.total) return 0;
    return Math.round(((stats.value.processed ?? 0) / stats.value.total) * 100);
});

const readyPercent = computed(() => {
    if (!stats.value.total) return 0;
    return Math.round(((stats.value.take ?? 0) / stats.value.total) * 100);
});

const packedPercent = computed(() => {
    if (!stats.value.total) return 0;
    return Math.round(((stats.value.packed ?? 0) / stats.value.total) * 100);
});

const bagSummaries = computed(() => {
    const list = decisionStore.resumo.bags ?? [];
    let reservedRemaining = Number(stats.value.reservedKg ?? decisionStore.reservedKg ?? 0);
    let volumeReservedTotal = Number(
        (stats.value.volumes ?? stats.value.dimensions)?.reserved_cm3 ?? 0,
    );
    if (volumeReservedTotal <= 0) {
        volumeReservedTotal = Number(decisionStore.reservedVolumeCm3 ?? 0);
    }
    if (volumeReservedTotal <= 0) {
        volumeReservedTotal = Number(move.value?.reserved_volume_cm3 ?? 0);
    }
    if (volumeReservedTotal <= 0) {
        volumeReservedTotal = list.reduce(
            (sum, bag) => sum + Number(bag.reserved_volume_cm3 ?? bag.reservedVolumeAppliedCm3 ?? 0),
            0,
        );
    }
    let reservedVolumeRemaining = volumeReservedTotal > 0 ? volumeReservedTotal : 0;
    const epsilon = 1e-4;

    const baseBags = list.map((bag, index) => {
        const capacity = Number(bag.capacity_kg ?? bag.capacity ?? 0) || 0;
        const actualUsed = Number(bag.yes_kg ?? bag.total_kg ?? bag.total ?? 0) || 0;

        const preReservedKg = Number(
            bag.reserved_applied_kg ?? bag.reservedAppliedKg ?? bag.reserved_kg ?? 0,
        );
        const preEffectiveKg = bag.effective_kg ?? bag.effectiveKg ?? null;
        const preRemainingKg = bag.remaining_kg ?? null;
        const preWeightRatio = bag.weight_ratio ?? bag.weightRatio ?? null;
        const preLockedByWeight = bag.locked_by_weight ?? bag.lockedByWeight ?? null;

        let reservedApplied = Number(preReservedKg) || 0;
        let effectiveUsed =
            preEffectiveKg != null ? Number(preEffectiveKg) : actualUsed + reservedApplied;
        let remaining =
            preRemainingKg != null ? Number(preRemainingKg) : Math.max(capacity - effectiveUsed, 0);
        let weightRatio =
            preWeightRatio != null ? Number(preWeightRatio) : capacity ? effectiveUsed / capacity : 0;
        let lockedByWeight =
            preLockedByWeight != null
                ? Boolean(preLockedByWeight)
                : capacity > 0 && weightRatio >= 1 - epsilon;

        if (preEffectiveKg == null && preReservedKg === 0) {
            const availableForReserved = Math.max(capacity - actualUsed, 0);
            reservedApplied = Math.min(availableForReserved, Math.max(reservedRemaining, 0));
            reservedRemaining -= reservedApplied;
            effectiveUsed = actualUsed + reservedApplied;
            remaining = Math.max(capacity - effectiveUsed, 0);
            weightRatio = capacity ? effectiveUsed / capacity : 0;
            lockedByWeight = capacity > 0 && weightRatio >= 1 - epsilon;
        }

        const rawCapacityVolume =
            bag.capacity_volume_cm3 ?? bag.capacityVolume_cm3 ?? bag.capacityVolumeCm3 ?? null;
        const capacityVolumeCm3 = rawCapacityVolume != null ? Number(rawCapacityVolume) : null;
        const volumeCm3 = Number(bag.total_volume_cm3 ?? bag.volume_cm3 ?? bag.volumeCm3 ?? 0) || 0;
        const preReservedVolume = Number(
            bag.reserved_volume_cm3 ?? bag.reservedVolumeAppliedCm3 ?? 0,
        );
        const preEffectiveVolume =
            bag.effective_volume_cm3 ?? bag.effectiveVolumeCm3 ?? null;
        const preRemainingVolume =
            bag.remaining_volume_cm3 ?? bag.remainingVolumeCm3 ?? null;
        const preVolumeRatio = bag.volume_ratio ?? bag.volumeRatio ?? null;
        const preLockedByVolume = bag.locked_by_volume ?? bag.lockedByVolume ?? null;

        let reservedVolumeApplied = Number(preReservedVolume) || 0;
        let effectiveVolumeCm3 =
            preEffectiveVolume != null
                ? Number(preEffectiveVolume)
                : volumeCm3 + reservedVolumeApplied;
        let remainingVolumeCm3 =
            preRemainingVolume !== null && preRemainingVolume !== undefined
                ? (preRemainingVolume === null ? null : Number(preRemainingVolume))
                : capacityVolumeCm3 != null
                    ? Math.max(capacityVolumeCm3 - effectiveVolumeCm3, 0)
                    : null;
        let volumeRatio =
            preVolumeRatio != null
                ? Number(preVolumeRatio)
                : capacityVolumeCm3 && capacityVolumeCm3 > 0
                    ? effectiveVolumeCm3 / capacityVolumeCm3
                    : 0;
        let lockedByVolume =
            preLockedByVolume != null
                ? Boolean(preLockedByVolume)
                : capacityVolumeCm3 && volumeRatio >= 1 - epsilon;

        if (preEffectiveVolume == null && preReservedVolume === 0 && capacityVolumeCm3 != null) {
            const availableVolumeForReserved = Math.max(capacityVolumeCm3 - volumeCm3, 0);
            reservedVolumeApplied = Math.min(
                availableVolumeForReserved,
                Math.max(reservedVolumeRemaining, 0),
            );
            reservedVolumeRemaining = Math.max(reservedVolumeRemaining - reservedVolumeApplied, 0);
            effectiveVolumeCm3 = volumeCm3 + reservedVolumeApplied;
            remainingVolumeCm3 = Math.max(capacityVolumeCm3 - effectiveVolumeCm3, 0);
            volumeRatio =
                capacityVolumeCm3 && capacityVolumeCm3 > 0
                    ? effectiveVolumeCm3 / capacityVolumeCm3
                    : 0;
            lockedByVolume = capacityVolumeCm3 && volumeRatio >= 1 - epsilon;
        }

        const locked =
            (bag.locked ?? null) !== null ? Boolean(bag.locked) : lockedByWeight || lockedByVolume;

        const status = bag.status
            ?? (locked
                ? 'Fechado'
                : (weightRatio >= 0.9 || volumeRatio >= 0.9 ? 'Lotado' : 'Normal'));

        return {
            id: bag.id ?? `bag-${index}`,
            name: bag.name ?? `Mala ${index + 1}`,
            code: bag.code ?? null,
            capacity,
            used: actualUsed,
            reservedAppliedKg: reservedApplied,
            effectiveUsedKg: effectiveUsed,
            remaining,
            remaining_kg: remaining,
            weightRatio,
            status,
            dimensions: bag.dimensions ?? '—',
            volumeCm3,
            capacityVolumeCm3,
            remainingVolumeCm3,
            reservedVolumeAppliedCm3: reservedVolumeApplied,
            effectiveVolumeCm3,
            volumeRatio,
            locked,
            lockedByWeight,
            lockedByVolume,
            projectedWeightKg: 0,
            projectedVolumeCm3: 0,
        };
    });

    const takeList = decisionStore.resumo.lists.take ?? [];
    const fallbackTakeWeight = takeList.reduce(
        (sum, item) => sum + (Number(item.weight ?? item.weight_kg ?? item.weightKg ?? 0) || 0),
        0,
    );
    const fallbackTakeVolume = takeList.reduce((sum, item) => {
        if (item.volume_cm3 != null) return sum + Number(item.volume_cm3);
        if (item.volume_liters != null) return sum + Number(item.volume_liters) * 1000;
        if (item.dimensions) {
            const parts = item.dimensions
                .split(/[x×]/i)
                .map((part) => parseFloat(part.replace(/[^0-9,.]/g, '').replace(',', '.')))
                .filter((value) => !Number.isNaN(value) && value > 0);
            if (parts.length >= 3) {
                return sum + parts.slice(0, 3).reduce((acc, value) => acc * value, 1);
            }
        }
        return sum;
    }, 0);

    const totalYesWeight = Number(stats.value.yesWeightKg ?? fallbackTakeWeight ?? 0);
    const assignedWeight = baseBags.reduce((sum, bag) => sum + (bag.used ?? 0), 0);
    let weightBacklog = Math.max(totalYesWeight - assignedWeight, 0);

    const totalYesVolume = Number(stats.value.yesVolumeCm3 ?? fallbackTakeVolume ?? 0);
    const assignedVolume = baseBags.reduce((sum, bag) => sum + (bag.volumeCm3 ?? bag.volume_cm3 ?? 0), 0);
    let volumeBacklog = Math.max(totalYesVolume - assignedVolume, 0);

    const adjustedBags = baseBags.map((bag) => {
        if (weightBacklog > 0 && bag.capacity > 0) {
            const available = Math.max(bag.capacity - bag.effectiveUsedKg, 0);
            if (available > 0) {
                const addition = Math.min(weightBacklog, available);
                bag.projectedWeightKg = addition;
                bag.effectiveUsedKg += addition;
                bag.remaining = Math.max(bag.capacity - bag.effectiveUsedKg, 0);
                bag.weightRatio = bag.capacity ? bag.effectiveUsedKg / bag.capacity : bag.weightRatio;
                weightBacklog -= addition;
            }
        }

        if (volumeBacklog > 0 && bag.capacityVolumeCm3) {
            const availableVolume = Math.max(bag.capacityVolumeCm3 - bag.effectiveVolumeCm3, 0);
            if (availableVolume > 0) {
                const addition = Math.min(volumeBacklog, availableVolume);
                bag.projectedVolumeCm3 = addition;
                bag.effectiveVolumeCm3 += addition;
                bag.remainingVolumeCm3 = Math.max(
                    bag.capacityVolumeCm3 - bag.effectiveVolumeCm3,
                    0,
                );
                bag.volumeRatio = bag.capacityVolumeCm3
                    ? bag.effectiveVolumeCm3 / bag.capacityVolumeCm3
                    : bag.volumeRatio;
                volumeBacklog -= addition;
            }
        }

        bag.usedWithProjection = bag.effectiveUsedKg;
        bag.volumeWithProjectionCm3 = bag.effectiveVolumeCm3;
        if (bag.capacityVolumeCm3 != null) {
            bag.remainingVolumeCm3 = Math.max(bag.capacityVolumeCm3 - bag.volumeWithProjectionCm3, 0);
        }

        bag.lockedByWeight = bag.lockedByWeight || (bag.capacity > 0 && bag.effectiveUsedKg >= bag.capacity - epsilon);
        bag.lockedByVolume =
            bag.lockedByVolume ||
            (bag.capacityVolumeCm3 && bag.effectiveVolumeCm3 >= bag.capacityVolumeCm3 - epsilon);
        bag.locked = bag.lockedByWeight || bag.lockedByVolume;

        bag.ratio = Math.max(bag.weightRatio ?? 0, bag.volumeRatio ?? 0);
        bag.remaining_kg = bag.remaining;

        if (bag.locked) {
            bag.status = 'Fechado';
        } else if (bag.weightRatio >= 0.9 || bag.volumeRatio >= 0.9) {
            bag.status = 'Lotado';
        } else {
            bag.status = 'Normal';
        }

        return bag;
    });

    return adjustedBags;
});

const capacitySkeletonVisible = computed(() => isLoadingResumo.value && bagSummaries.value.length === 0);

const totalCapacityKg = computed(() => (stats.value.totalCapacityKg ?? bagSummaries.value.reduce((sum, bag) => sum + bag.capacity, 0)));
const yesWeightKg = computed(() => (stats.value.yesWeightKg ?? bagSummaries.value.reduce((sum, bag) => sum + (bag.effectiveUsedKg ?? bag.used ?? 0), 0)));
const reservedCapacityKg = computed(() => stats.value.reservedKg ?? 0);
const remainingCapacityKg = computed(() => stats.value.remainingCapacityKg ?? Math.max(totalCapacityKg.value - reservedCapacityKg.value - yesWeightKg.value, 0));

const volumeSummary = computed(() => {
    const summary = stats.value.volumes ?? stats.value.dimensions;
    const bagVolume = (decisionStore.resumo.bags ?? []).reduce((sum, bag) => {
        const parsed = bag.capacity_volume_cm3 ?? bag.capacityVolume_cm3 ?? bag.capacityVolumeCm3 ?? null;
        if (parsed != null) return sum + Number(parsed);
        if (bag.dimensions) {
            const parts = bag.dimensions
                .split(/[x×]/i)
                .map((part) => parseFloat(part.replace(/[^0-9,.]/g, '').replace(',', '.')))
                .filter((value) => !Number.isNaN(value) && value > 0);
            if (parts.length >= 3) {
                return sum + parts.slice(0, 3).reduce((acc, value) => acc * value, 1);
            }
        }
        return sum;
    }, 0);
    if (summary) {
        const usedCm3 = Number(summary.volume_cm3 ?? 0);
        const reservedCm3 = Number(summary.reserved_cm3 ?? 0);
        const capacityCm3 = Number(summary.capacity_cm3 ?? bagVolume ?? 0);
        const availableCm3 = Number(
            summary.available_cm3 ?? capacityCm3 - reservedCm3,
        );
        const remainingCm3 = Number(
            summary.remaining_cm3 ?? availableCm3 - usedCm3,
        );
        const overflowCm3 = Number(
            summary.overflow_cm3 ?? (remainingCm3 < 0 ? Math.abs(remainingCm3) : 0),
        );
        return {
            count: summary.count ?? null,
            volume_cm3: usedCm3,
            volume_liters: Number(summary.volume_liters ?? (usedCm3 ? usedCm3 / 1000 : 0)),
            reserved_cm3: reservedCm3,
            reserved_liters: Number(summary.reserved_liters ?? (reservedCm3 ? reservedCm3 / 1000 : 0)),
            capacity_cm3: capacityCm3,
            capacity_liters: Number(summary.capacity_liters ?? (capacityCm3 ? capacityCm3 / 1000 : 0)),
            available_cm3: availableCm3,
            available_liters: Number(
                summary.available_liters ?? (availableCm3 ? availableCm3 / 1000 : 0),
            ),
            remaining_cm3: remainingCm3,
            remaining_liters: Number(
                summary.remaining_liters ?? (remainingCm3 ? remainingCm3 / 1000 : 0),
            ),
            overflow_cm3: overflowCm3,
            overflow_liters: Number(
                summary.overflow_liters ?? (overflowCm3 ? overflowCm3 / 1000 : 0),
            ),
        };
    }
    if (!bagVolume) return null;
    const usedFromBags = bagSummaries.value.reduce(
        (sum, bag) => sum + (Number(bag.volumeWithProjectionCm3 ?? bag.effectiveVolumeCm3 ?? bag.volumeCm3 ?? 0) || 0),
        0,
    );
    const reserved = bagSummaries.value.reduce(
        (sum, bag) => sum + (Number(bag.reservedVolumeAppliedCm3 ?? 0) || 0),
        0,
    );
    const remaining = Math.max(bagVolume - reserved - usedFromBags, 0);
    return {
        count: null,
        volume_cm3: usedFromBags,
        volume_liters: usedFromBags / 1000,
        reserved_cm3: reserved,
        reserved_liters: reserved / 1000,
        capacity_cm3: bagVolume,
        capacity_liters: bagVolume / 1000,
        available_cm3: bagVolume - reserved,
        available_liters: (bagVolume - reserved) / 1000,
        remaining_cm3: remaining,
        remaining_liters: remaining / 1000,
        overflow_cm3: 0,
        overflow_liters: 0,
    };
});

const volumeStats = computed(() => volumeSummary.value ?? null);
const volumeTotalCapacityCm3 = computed(() =>
    volumeStats.value?.capacity_cm3 ??
    bagSummaries.value.reduce((sum, bag) => sum + (bag.capacityVolumeCm3 ?? 0), 0),
);
const volumeUsedCm3 = computed(() =>
    volumeStats.value?.volume_cm3 ??
    bagSummaries.value.reduce((sum, bag) => sum + (bag.effectiveVolumeCm3 ?? bag.volumeCm3 ?? 0), 0),
);
const volumeReservedCm3 = computed(() =>
    volumeStats.value?.reserved_cm3 ??
    bagSummaries.value.reduce((sum, bag) => sum + (bag.reservedVolumeAppliedCm3 ?? 0), 0),
);
const volumeRemainingCm3 = computed(() =>
    volumeStats.value?.remaining_cm3 ??
    Math.max(volumeTotalCapacityCm3.value - volumeReservedCm3.value - volumeUsedCm3.value, 0),
);

const numberFormatter = new Intl.NumberFormat('pt-BR');
const formatKg = (value) => `${Number(value ?? 0).toFixed(1)} kg`;
const formatLiters = (cm3Value) => `${(Number(cm3Value ?? 0) / 1000).toFixed(1)} L`;
const formatCm3 = (value) => `${numberFormatter.format(Math.round(Number(value ?? 0))) } cm³`;

const suitcaseCards = computed(() =>
    bagSummaries.value.map((bag) => {
        const capacityVolumeCm3 = bag.capacityVolumeCm3 != null ? Number(bag.capacityVolumeCm3) : null;
        const actualVolumeCm3 = Number(bag.volumeCm3 ?? bag.volume_cm3 ?? 0);
        const reservedVolumeCm3 = Number(bag.reservedVolumeAppliedCm3 ?? bag.reserved_volume_cm3 ?? 0);
        const projectedVolumeCm3 = Number(bag.projectedVolumeCm3 ?? 0);
        const effectiveVolumeCm3 = Number(
            bag.volumeWithProjectionCm3 ??
                bag.effectiveVolumeCm3 ??
                bag.effective_volume_cm3 ??
                actualVolumeCm3 + projectedVolumeCm3 + reservedVolumeCm3,
        );
        const remainingVolumeCm3 =
            capacityVolumeCm3 != null ? Math.max(capacityVolumeCm3 - effectiveVolumeCm3, 0) : null;

        const actualWeightKg = Number(bag.used ?? bag.yes_kg ?? bag.total_kg ?? 0) || 0;
        const reservedWeightKg = Number(bag.reservedAppliedKg ?? 0);
        const projectedWeightKg = Number(bag.projectedWeightKg ?? 0);
        const effectiveWeightKg = Number(
            bag.usedWithProjection ?? bag.effectiveUsedKg ?? actualWeightKg + projectedWeightKg + reservedWeightKg,
        );
        const remainingWeightKg = Math.max((bag.capacity ?? 0) - effectiveWeightKg, 0);

        return {
            id: bag.id,
            name: bag.name,
            dims: bag.dimensions || '—',
            current: effectiveWeightKg,
            max: bag.capacity,
            volume: {
                current: effectiveVolumeCm3,
                actual: actualVolumeCm3,
                effective: effectiveVolumeCm3,
                reserved: reservedVolumeCm3,
                projected: projectedVolumeCm3,
                capacity: capacityVolumeCm3,
                remaining: remainingVolumeCm3,
            },
            weight: {
                actual: actualWeightKg,
                reserved: reservedWeightKg,
                projected: projectedWeightKg,
                effective: effectiveWeightKg,
                remaining: remainingWeightKg,
            },
            ratio: Math.max(Number(bag.ratio ?? 0), effectiveWeightKg && bag.capacity ? effectiveWeightKg / bag.capacity : 0),
            status: bag.status,
            locked: bag.locked,
            lockedByWeight: bag.lockedByWeight,
            lockedByVolume: bag.lockedByVolume,
        };
    }),
);
const lockedBagNames = computed(() =>
    bagSummaries.value.filter((bag) => bag.locked).map((bag) => bag.name).filter(Boolean),
);
const statusBanner = computed(() => {
    if (lockedBagNames.value.length) {
        return {
            tone: 'yellow',
            emoji: '🧳',
            title: 'Alguma mala travou',
            message: `${lockedBagNames.value.join(', ')} atingiu o limite de peso ou volume. Reorganize no Embalar ou remova itens.`,
            actions: [{ label: 'Abrir Embalar', handler: goToPack }],
        };
    }
    if (stats.value.pending_total > 0 && pendingDeckCount.value === 0) {
        return {
            tone: 'slate',
            emoji: '🗂️',
            title: 'Pendentes aguardando decisão',
            message: 'Reinsira os itens pendentes para continuar o processo de decisão.',
            actions: [{ label: 'Ir para Decidir', handler: goToDecidir }],
        };
    }
    if (
        stats.value.pending_total === 0
        && stats.value.undecided === 0
        && stats.value.take > 0
        && lockedBagNames.value.length === 0
    ) {
        return {
            tone: 'green',
            emoji: '🎒',
            title: 'Tudo decidido!',
            message: 'Hora de embalar: todos os itens já foram classificados.',
            actions: [{ label: 'Abrir Embalar', handler: goToPack }],
        };
    }
    return null;
});

const toggleSelection = ({ id, value }) => {
    const set = currentSelection.value;
    if (!set) return;
    if (value) {
        set.add(id);
    } else {
        set.delete(id);
    }
};

const toggleSelectAll = (event) => {
    const set = currentSelection.value;
    if (!set) return;
    const idsOnPage = currentItems.value.map((item) => item.id);
    if (!event.target.checked) {
        idsOnPage.forEach((id) => set.delete(id));
        return;
    }
    idsOnPage.forEach((id) => set.add(id));
};

const clearSelection = (ids) => {
    ['take', 'pending', 'leave'].forEach((key) => {
        ids.forEach((id) => selection[key].delete(id));
    });
};

const clearCurrentSelection = () => {
    currentSelection.value.clear();
};

const pruneSelection = () => {
    const validIds = new Set(filteredItems.value.map((item) => item.id));
    const set = currentSelection.value;
    Array.from(set).forEach((id) => {
        if (!validIds.has(id)) {
            set.delete(id);
        }
    });
};

const pruneAllSelection = () => {
    const decisionByTab = {
        take: 'yes',
        pending: 'pending',
        leave: 'no',
    };
    ['take', 'pending', 'leave'].forEach((key) => {
        const set = selection[key];
        const decisionKey = decisionByTab[key];
        Array.from(set).forEach((id) => {
            const item = decisionStore.itemsMap[id];
            if (!item || item.deleted || (decisionKey && item.decision !== decisionKey)) {
                set.delete(id);
            }
        });
    });
};

const listContainer = ref(null);

const scrollListToTop = () => {
    const target = listContainer.value;
    if (!target) return;

    const canScrollElement = target.scrollHeight - target.clientHeight > 4;
    if (canScrollElement) {
        target.scrollTo({ top: 0, behavior: 'smooth' });
        return;
    }

    if (typeof window !== 'undefined') {
        const rect = target.getBoundingClientRect();
        const top = window.scrollY + rect.top - 120;
        window.scrollTo({ top: Math.max(top, 0), behavior: 'smooth' });
    }
};

const resetFilters = () => {
    searchQuery.value = '';
    pageSize.value = defaultPageSize;
    currentPage.value = 1;
    nextTick(() => scrollListToTop());
};

const handleClearFilters = () => {
    resetFilters();
    filtersExpanded.value = false;
};

watch(
    () => currentItems.value.map((item) => item.id),
    () => {
        pruneSelection();
    },
);

watch([allSelected, someSelected], () => {
    if (!selectAllRef.value) return;
    selectAllRef.value.indeterminate = someSelected.value;
});

watch(
    () => allResumoItems.value.map((item) => `${item.id}:${item.decision}:${item.deleted}`),
    () => {
        pruneAllSelection();
    },
);

watch(searchQuery, () => {
    currentPage.value = 1;
    scrollListToTop();
});

watch(pageSize, () => {
    currentPage.value = 1;
    scrollListToTop();
});

watch(activeTab, () => {
    searchQuery.value = '';
    currentPage.value = 1;
    scrollListToTop();
});

watch([filteredItems, pageSize], () => {
    if (!totalFilteredCount.value) {
        if (currentPage.value !== 1) {
            currentPage.value = 1;
        }
        return;
    }

    const maxPages = totalPages.value || 1;
    if (currentPage.value > maxPages) {
        currentPage.value = maxPages;
    }
});

watch(currentPage, (value) => {
    if (!totalFilteredCount.value) {
        if (currentPage.value !== 1) {
            currentPage.value = 1;
        }
        return;
    }

    const maxPages = totalPages.value || 1;
    if (value < 1) {
        currentPage.value = 1;
        return;
    }

    if (value > maxPages) {
        currentPage.value = maxPages;
        return;
    }

    scrollListToTop();
});

watch(filteredItems, () => {
    pruneSelection();
});

watch(
    bagOptions,
    (options) => {
        if (!options.length) {
            bulkBagChoice.value = '';
            return;
        }
        if (bulkBagChoice.value && options.some((option) => option.value === bulkBagChoice.value)) {
            return;
        }
        bulkBagChoice.value = options[0].value ?? '';
    },
    { immediate: true },
);

const ensureUndecided = async (ids) => {
    const toReset = ids.filter((id) => {
        const item = decisionStore.itemsMap[id];
        if (!item) return true;
        const needsDecision = item.decision !== 'undecided';
        const hasBag = Boolean(item.bag_id);
        return needsDecision || hasBag;
    });

    if (!toReset.length) {
        return;
    }

    await decisionStore.decideItems(toReset, 'undecided', { clearBag: true });
};

const handleGlobalRequeue = async (decisionKey) => {
    const ids = collectIdsForDecision(decisionKey);
    if (!ids.length) {
        toast.info('Não há itens nessa lista.');
        return;
    }

    const label = decisionLabels[decisionKey] ?? 'Itens';
    globalRequeueLoading[decisionKey] = true;
    try {
        await ensureUndecided(ids);
        await decisionStore.requeueItems(ids);
        toast.success(`${label} voltaram ao Decidir ✅`);
    } catch (error) {
        console.error(error);
        toast.error(`Não foi possível reinserir ${label.toLowerCase()} ❌`);
    } finally {
        globalRequeueLoading[decisionKey] = false;
    }
};

const handleBulkRequeue = async () => {
    const ids = selectedIds.value;
    if (!ids.length) return;
    try {
        await ensureUndecided(ids);
        await decisionStore.requeueItems(ids);
        await Promise.allSettled([
            decisionStore.fetchResumo(),
            decisionStore.fetchDeck(),
            decisionStore.fetchPack(),
        ]);
        clearSelection(ids);
        toast.success('Itens reinseridos no deck ✅');
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível reinserir os itens ❌');
    }
};

const formatBagLabel = (value) => bagLabelMap.value[value ?? ''] ?? 'Sem mala';

const handleBulkAssign = async () => {
    if (!selectedIds.value.length) return;
    bulkAssignLoading.value = true;
    try {
        await decisionStore.assignBagBulk(selectedIds.value, bulkBagChoice.value ?? '');
        toast.success(
            bulkBagChoice.value
                ? `Seleção enviada para ${formatBagLabel(bulkBagChoice.value)}`
                : 'Seleção removida das malas',
        );
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível atualizar as malas ❌');
    } finally {
        bulkAssignLoading.value = false;
    }
};

const registerScrollTarget = inject('registerScrollTarget', null);
let unregisterScrollTarget = null;

onMounted(async () => {
    if (!move.value?.id) return;
    try {
        await Promise.all([
            decisionStore.fetchResumo(),
            decisionStore.fetchPack(),
            decisionStore.fetchDeck(),
        ]);
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível carregar o resumo ❌');
    }

    if (registerScrollTarget) {
        unregisterScrollTarget = registerScrollTarget(listContainer);
    }
});

onBeforeUnmount(() => {
    unregisterScrollTarget?.();
});
</script>

<style scoped>
.slide-up-enter-active,
.slide-up-leave-active {
    transition: all 0.2s ease;
}
.slide-up-enter-from,
.slide-up-leave-to {
    opacity: 0;
    transform: translateY(12px);
}
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.resumo-panel,
.resumo-panel-soft,
.resumo-items-card {
    position: relative;
    border-radius: 1.75rem;
    padding: 1.75rem;
    background: rgba(255, 255, 255, 0.96);
    border: 1px solid rgba(148, 163, 184, 0.2);
    box-shadow: 0 28px 60px rgba(15, 23, 42, 0.08);
    overflow: hidden;
}
.resumo-panel::before,
.resumo-panel::after,
.resumo-panel-soft::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    pointer-events: none;
}
.resumo-panel::before {
    background: radial-gradient(circle at 10% -10%, rgba(226, 232, 240, 0.92), transparent 55%);
}
.resumo-panel::after {
    background: linear-gradient(135deg, rgba(148, 163, 184, 0.18), rgba(129, 140, 248, 0.12), rgba(94, 234, 212, 0.08));
    animation: resumoAurora 26s ease infinite;
}
.resumo-items-card::before,
.resumo-items-card::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    pointer-events: none;
}
.resumo-items-card::before {
    background: radial-gradient(circle at 15% -10%, rgba(226, 232, 240, 0.9), transparent 60%);
}
.resumo-items-card::after {
    background: linear-gradient(140deg, rgba(129, 140, 248, 0.18), rgba(147, 197, 253, 0.16), rgba(94, 234, 212, 0.12));
    animation: resumoAurora 28s ease infinite;
}
.resumo-panel-soft::before {
    background: radial-gradient(circle at 90% 10%, rgba(203, 213, 225, 0.5), transparent 60%);
}
.resumo-panel > *,
.resumo-panel-soft > *,
.resumo-items-card > * {
    position: relative;
    z-index: 1;
}
.resumo-panel__head,
.resumo-panel-soft__head,
.resumo-items-card__head {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}
@media (min-width: 640px) {
    .resumo-panel__head,
    .resumo-panel-soft__head {
        flex-direction: row;
        align-items: center;
        justify-content: space-between;
    }
}
.resumo-panel__title-block,
.resumo-items-card__title-block {
    display: flex;
    gap: 1rem;
    align-items: center;
}
.resumo-panel__icon,
.resumo-items-card__icon {
    --tile-icon-size: 3.3rem;
    animation: resumoFloat 12s ease-in-out infinite;
}
.resumo-items-card__icon--glow {
    --tile-icon-size: 3.4rem;
    box-shadow:
        inset 0 2px 6px rgba(255, 255, 255, 0.5),
        0 18px 40px rgba(15, 23, 42, 0.1);
}
.resumo-eyebrow {
    font-size: 0.72rem;
    letter-spacing: 0.45em;
    font-weight: 600;
    text-transform: uppercase;
    color: #818cf8;
}
.resumo-eyebrow--muted {
    color: #94a3b8;
}
.resumo-panel__title,
.resumo-items-card__title,
.resumo-panel-soft__title {
    font-size: 1.5rem;
    font-weight: 700;
    color: #0f172a;
    line-height: 1.2;
}
@media (min-width: 640px) {
    .resumo-panel__title,
    .resumo-panel-soft__title,
    .resumo-items-card__title {
        font-size: 1.9rem;
    }
}
.resumo-panel__subtitle,
.resumo-panel-soft__subtitle,
.resumo-items-card__subtitle {
    color: #475569;
    font-size: 0.95rem;
}
.resumo-panel__toggles {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.85rem;
    color: #475569;
}
.resumo-panel__link {
    font-weight: 600;
    color: #0ea5e9;
    text-decoration: none;
}
.resumo-panel__link:hover {
    text-decoration: underline;
}
.resumo-panel__divider {
    color: rgba(148, 163, 184, 0.5);
}
.resumo-accordion-group {
    margin-top: 1.75rem;
    display: flex;
    flex-direction: column;
    gap: 1rem;
}
.resumo-accordion {
    border-radius: 1.5rem;
    background: rgba(255, 255, 255, 0.92);
    border: 1px solid rgba(226, 232, 240, 0.7);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6), 0 20px 35px rgba(15, 23, 42, 0.05);
}
.resumo-accordion--ghost {
    background: rgba(248, 250, 252, 0.9);
}
.resumo-accordion__trigger {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
    padding: 1rem 1.25rem;
    border-radius: 1.5rem;
    font-weight: 600;
    color: #0f172a;
}
.resumo-accordion__title {
    display: flex;
    align-items: center;
    gap: 0.85rem;
    font-size: 1rem;
}
.resumo-accordion__icon {
    --tile-icon-size: 2.5rem;
}
.resumo-accordion__body {
    padding: 0 1.25rem 1.25rem;
    color: #475569;
}
.resumo-summary-grid {
    display: grid;
    gap: 1rem;
}
@media (min-width: 640px) {
    .resumo-summary-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}
@media (min-width: 1024px) {
    .resumo-summary-grid {
        grid-template-columns: repeat(4, minmax(0, 1fr));
    }
}
.resumo-summary-card {
    border-radius: 1.5rem;
    padding: 1.1rem;
    color: white;
    position: relative;
    overflow: hidden;
    border: 1px solid rgba(148, 163, 184, 0.3);
    display: flex;
    align-items: center;
    gap: 0.9rem;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.35),
        0 25px 40px rgba(15, 23, 42, 0.12);
}
.resumo-summary-card::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.3), transparent 70%);
    pointer-events: none;
}
.resumo-summary-card--emerald {
    border-color: rgba(52, 211, 153, 0.2);
    background: linear-gradient(135deg, #0ea5e9, #10b981, #34d399);
}
.resumo-summary-card--rose {
    border-color: rgba(248, 113, 113, 0.3);
    background: linear-gradient(135deg, #ef4444, #dc2626, #f97316);
}
.resumo-summary-card--amber {
    border-color: rgba(251, 191, 36, 0.3);
    background: linear-gradient(135deg, #fde047, #fbbf24, #fb923c);
    color: #1f2937;
}
.resumo-summary-card--slate {
    border-color: rgba(148, 163, 184, 0.3);
    background: linear-gradient(135deg, #e2e8f0, #cbd5f5, #d1fae5);
    color: #0f172a;
}
.resumo-summary-card__label {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.2em;
    color: rgba(255, 255, 255, 0.85);
}
.resumo-summary-card__value {
    font-size: 2rem;
    font-weight: 700;
}
.resumo-summary-card--amber .resumo-summary-card__value,
.resumo-summary-card--slate .resumo-summary-card__value {
    color: #0f172a;
}
.resumo-summary-card--amber .resumo-summary-card__label,
.resumo-summary-card--slate .resumo-summary-card__label {
    color: rgba(15, 23, 42, 0.7);
}
.resumo-summary-card__action {
    margin-top: 0.75rem;
    width: 100%;
    border-radius: 999px;
    border: 1px solid rgba(15, 23, 42, 0.08);
    padding: 0.45rem 0.85rem;
    font-size: 0.75rem;
    font-weight: 600;
    color: #0f172a;
    background: rgba(255, 255, 255, 0.92);
    transition: transform 0.15s ease, box-shadow 0.15s ease;
}
.resumo-summary-card__action:hover {
    transform: translateY(-1px);
    box-shadow: 0 10px 20px rgba(15, 23, 42, 0.07);
}
.resumo-summary-card__icon-wrap {
    flex-shrink: 0;
}
.resumo-summary-card__icon {
    --tile-icon-size: 3rem;
}
.resumo-summary-card__action:disabled {
    opacity: 0.5;
}
.resumo-totals-grid {
    display: grid;
    gap: 0.75rem;
}
@media (min-width: 640px) {
    .resumo-totals-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}
@media (min-width: 1024px) {
    .resumo-totals-grid {
        grid-template-columns: repeat(4, minmax(0, 1fr));
    }
}
.resumo-total-card {
    border-radius: 1.4rem;
    padding: 1rem;
    background: rgba(248, 250, 252, 0.95);
    border: 1px solid rgba(226, 232, 240, 0.7);
    display: flex;
    align-items: center;
    gap: 0.85rem;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.6),
        0 20px 40px rgba(15, 23, 42, 0.08);
    color: #0f172a;
}
.resumo-total-card--slate {
    background: linear-gradient(135deg, rgba(226, 232, 240, 0.95), rgba(203, 213, 225, 0.9));
}
.resumo-total-card--emerald {
    background: linear-gradient(135deg, rgba(14, 165, 233, 0.12), rgba(16, 185, 129, 0.18));
    color: #064e3b;
}
.resumo-total-card--amber {
    background: linear-gradient(135deg, rgba(251, 191, 36, 0.18), rgba(249, 115, 22, 0.1));
    color: #78350f;
}
.resumo-total-card--indigo {
    background: linear-gradient(135deg, rgba(129, 140, 248, 0.2), rgba(99, 102, 241, 0.13));
    color: #1e1b4b;
}
.resumo-total-card__label {
    font-weight: 600;
    color: rgba(15, 23, 42, 0.7);
    text-transform: uppercase;
    font-size: 0.72rem;
    letter-spacing: 0.2em;
}
.resumo-total-card__value {
    display: block;
    font-size: 1.4rem;
    font-weight: 700;
}
.resumo-total-card__icon {
    --tile-icon-size: 2.8rem;
}
.resumo-quickstats {
    display: grid;
    gap: 0.75rem;
}
@media (min-width: 640px) {
    .resumo-quickstats {
        grid-template-columns: repeat(3, minmax(0, 1fr));
    }
}
.resumo-quickstat {
    display: flex;
    gap: 0.85rem;
    align-items: center;
    padding: 0.9rem 1rem;
    border-radius: 1.5rem;
    background: rgba(248, 250, 252, 0.95);
    border: 1px solid rgba(226, 232, 240, 0.7);
}
.resumo-quickstat__icon {
    --tile-icon-size: 2.6rem;
}
.resumo-quickstat__label {
    font-size: 0.72rem;
    text-transform: uppercase;
    letter-spacing: 0.15em;
    color: #94a3b8;
    font-weight: 600;
}
.resumo-quickstat__value {
    font-weight: 700;
    color: #0f172a;
}
.resumo-status-card {
    margin-top: 1.5rem;
    border-radius: 1.75rem;
    padding: 1.5rem;
    display: flex;
    gap: 1rem;
    align-items: flex-start;
    border: 1px solid rgba(148, 163, 184, 0.3);
    background: rgba(255, 255, 255, 0.92);
    box-shadow: 0 25px 50px rgba(15, 23, 42, 0.08);
}
.resumo-status-card--emerald {
    border-color: rgba(16, 185, 129, 0.25);
    background: linear-gradient(120deg, rgba(16, 185, 129, 0.12), rgba(255, 255, 255, 0.92));
}
.resumo-status-card--amber {
    border-color: rgba(251, 191, 36, 0.25);
    background: linear-gradient(120deg, rgba(251, 191, 36, 0.12), rgba(255, 255, 255, 0.94));
}
.resumo-status-card--rose {
    border-color: rgba(244, 114, 182, 0.25);
    background: linear-gradient(120deg, rgba(244, 114, 182, 0.12), rgba(255, 255, 255, 0.94));
}
.resumo-status-card__icon {
    --tile-icon-size: 3rem;
}
.resumo-status-card__body {
    flex: 1;
}
.resumo-status-card__title {
    font-size: 1.1rem;
    font-weight: 700;
    color: #0f172a;
}
.resumo-status-card__message {
    color: #475569;
    margin-top: 0.3rem;
}
.resumo-status-card__actions {
    margin-top: 1rem;
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
}
.resumo-status-card__button {
    border-radius: 999px;
    padding: 0.5rem 1rem;
    font-size: 0.85rem;
    font-weight: 600;
    background: rgba(15, 23, 42, 0.04);
    color: #0f172a;
    border: 1px solid rgba(15, 23, 42, 0.08);
    transition: transform 0.15s ease;
}
.resumo-status-card__button:hover {
    transform: translateY(-1px);
}
.resumo-status-card__button--warm {
    position: relative;
    overflow: hidden;
    background: linear-gradient(130deg, #fef3c7, #fbbf24, #f97316, #fb7185);
    background-size: 220% 220%;
    color: #78350f;
    border: 1px solid rgba(251, 191, 36, 0.4);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.7),
        0 18px 35px rgba(249, 115, 22, 0.3);
    animation: resumoWarmShift 8s ease-in-out infinite;
}
.resumo-status-card__button--warm::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: radial-gradient(circle at 20% 20%, rgba(255, 255, 255, 0.8), transparent 55%);
    opacity: 0.6;
    pointer-events: none;
    mix-blend-mode: screen;
}
.resumo-status-card__button--warm::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(120deg, transparent, rgba(255, 255, 255, 0.35), transparent);
    transform: translateX(-100%);
    animation: resumoWarmShimmer 3.5s ease infinite;
    pointer-events: none;
}
.resumo-status-card__button--warm:hover {
    transform: translateY(-2px);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.8),
        0 24px 45px rgba(249, 115, 22, 0.35);
}
.resumo-panel-soft__cta {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}
@media (min-width: 640px) {
    .resumo-panel-soft__cta {
        flex-direction: row;
        align-items: center;
    }
}
.resumo-cta {
    position: relative;
    z-index: 0;
    border-radius: 999px;
    padding: 0.7rem 1.5rem;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.4rem;
    transition: transform 0.15s ease, box-shadow 0.15s ease;
}
.resumo-cta--ghost {
    background: rgba(248, 250, 252, 0.9);
    color: #0f172a;
    border: 1px solid rgba(148, 163, 184, 0.4);
}
.resumo-cta--compact {
    padding: 0.45rem 1rem;
    font-size: 0.85rem;
}
.resumo-cta--warm {
    position: relative;
    overflow: hidden;
    background: linear-gradient(130deg, #fef3c7, #fbbf24, #f97316, #fb7185);
    background-size: 220% 220%;
    color: #78350f;
    border: 1px solid rgba(251, 191, 36, 0.4);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.7),
        0 25px 45px rgba(249, 115, 22, 0.35);
    animation: resumoWarmShift 8s ease-in-out infinite;
}
.resumo-cta--warm::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: radial-gradient(circle at 20% 20%, rgba(255, 255, 255, 0.8), transparent 55%);
    opacity: 0.6;
    pointer-events: none;
    mix-blend-mode: screen;
}
.resumo-cta--warm::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(120deg, transparent, rgba(255, 255, 255, 0.35), transparent);
    transform: translateX(-100%);
    animation: resumoWarmShimmer 3.5s ease infinite;
    pointer-events: none;
}
.resumo-cta--warm:hover {
    transform: translateY(-1px);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.8),
        0 32px 55px rgba(249, 115, 22, 0.4);
}
.resumo-cta--primary {
    background: linear-gradient(120deg, #10b981, #06b6d4);
    color: white;
    box-shadow: 0 20px 40px rgba(6, 182, 212, 0.25);
}
.resumo-cta--cool {
    position: relative;
    overflow: hidden;
    background: linear-gradient(130deg, #e0f2fe, #38bdf8, #6366f1, #8b5cf6);
    background-size: 220% 220%;
    color: #0f172a;
    border: 1px solid rgba(99, 102, 241, 0.35);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.7),
        0 25px 45px rgba(79, 70, 229, 0.32);
    animation: resumoCoolShift 9s ease-in-out infinite;
}
.resumo-cta--cool::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: radial-gradient(circle at 25% 25%, rgba(255, 255, 255, 0.9), transparent 60%);
    pointer-events: none;
    mix-blend-mode: screen;
    opacity: 0.55;
}
.resumo-cta--cool::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(120deg, transparent, rgba(255, 255, 255, 0.28), transparent);
    transform: translateX(-120%);
    animation: resumoCoolShimmer 4s ease infinite;
    pointer-events: none;
}
.resumo-cta--cool:hover {
    transform: translateY(-1px);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.8),
        0 32px 55px rgba(79, 70, 229, 0.42);
}
.resumo-accordion-group--soft .resumo-accordion {
    background: rgba(255, 255, 255, 0.9);
}
.resumo-capacity-card {
    border-radius: 1.5rem;
    background: rgba(248, 250, 252, 0.95);
    border: 1px solid rgba(226, 232, 240, 0.8);
    padding: 0.75rem;
}
.resumo-capacity-card__trigger {
    width: 100%;
    border-radius: 1.25rem;
    padding: 0.75rem 1rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.75rem;
    color: #0f172a;
    font-weight: 600;
}
.resumo-capacity-card__label {
    display: flex;
    gap: 0.85rem;
    align-items: center;
}
.resumo-capacity-card__icon {
    --tile-icon-size: 2.6rem;
}
.resumo-capacity-card__title {
    font-size: 1rem;
}
.resumo-capacity-card__meta {
    font-size: 0.85rem;
    color: #475569;
}
.resumo-capacity-card__body {
    margin-top: 0.75rem;
    border-radius: 1.25rem;
    background: rgba(255, 255, 255, 0.9);
    padding: 1rem;
    border: 1px dashed rgba(148, 163, 184, 0.4);
}
.resumo-capacity-card__skeleton {
    height: 14rem;
    border-radius: 1.25rem;
    background: linear-gradient(90deg, rgba(226, 232, 240, 0.6), rgba(248, 250, 252, 0.7), rgba(226, 232, 240, 0.6));
    background-size: 200% 100%;
    animation: shimmer 1.5s ease infinite;
}
.resumo-suitcase-grid {
    display: grid;
    gap: 1rem;
}
@media (min-width: 768px) {
    .resumo-suitcase-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}
@media (min-width: 1280px) {
    .resumo-suitcase-grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
    }
}
.resumo-empty-card {
    border-radius: 1.75rem;
    border: 1px dashed rgba(148, 163, 184, 0.6);
    padding: 1.5rem;
    background: rgba(248, 250, 252, 0.8);
    color: #475569;
}
.resumo-badge-row {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin-top: 1rem;
}
.resumo-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.35rem 0.85rem;
    border-radius: 999px;
    font-size: 0.85rem;
    font-weight: 600;
    background: rgba(248, 250, 252, 0.85);
    border: 1px solid rgba(148, 163, 184, 0.4);
    color: #0f172a;
}
.resumo-badge--emerald {
    border-color: rgba(16, 185, 129, 0.2);
    color: #047857;
}
.resumo-badge--amber {
    border-color: rgba(245, 158, 11, 0.3);
    color: #92400e;
}
.resumo-badge--rose {
    border-color: rgba(244, 114, 182, 0.3);
    color: #be185d;
}
.resumo-badge__icon {
    --tile-icon-size: 2.4rem;
}
.resumo-badge__value {
    font-weight: 700;
    color: #0f172a;
}
.resumo-items-shell {
    margin-top: 1.5rem;
    border-radius: 1.9rem;
    border: 1px solid rgba(148, 163, 184, 0.45);
    background: linear-gradient(145deg, rgba(241, 245, 249, 0.92), rgba(226, 232, 240, 0.85));
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.75),
        0 30px 45px rgba(15, 23, 42, 0.15);
    position: relative;
    overflow: hidden;
}
.resumo-items-shell::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(120deg, rgba(148, 163, 184, 0.15), rgba(129, 140, 248, 0.15), rgba(45, 212, 191, 0.12));
    animation: resumoItemsAurora 26s ease infinite;
    pointer-events: none;
}
.resumo-items-shell::after {
    content: '';
    position: absolute;
    inset: 0.8rem;
    border-radius: inherit;
    border: 1px solid rgba(255, 255, 255, 0.35);
    pointer-events: none;
}
.resumo-filter-panel {
    border-radius: 1.75rem;
    background: rgba(255, 255, 255, 0.95);
    padding: 1.25rem;
    margin-bottom: 1rem;
    box-shadow: 0 22px 45px rgba(15, 23, 42, 0.12);
    border: 1px solid rgba(148, 163, 184, 0.4);
    backdrop-filter: blur(16px);
    position: relative;
    overflow: hidden;
}
.resumo-filter-panel::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: radial-gradient(circle at 20% 15%, rgba(255, 255, 255, 0.65), transparent 60%);
    pointer-events: none;
}
.resumo-search-grid {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}
.resumo-search-card {
    display: flex;
    gap: 0.75rem;
    padding: 0.85rem 1rem;
    border-radius: 1.5rem;
    border: 1px solid rgba(148, 163, 184, 0.35);
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.96), rgba(248, 250, 252, 0.92));
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.7),
        0 15px 35px rgba(15, 23, 42, 0.08);
}
.resumo-search-card__icon {
    --tile-icon-size: 2.8rem;
}
.resumo-search-card__body {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
}
.resumo-search-card__label {
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 0.25em;
    color: #94a3b8;
    font-weight: 600;
}
.resumo-search-card__input {
    width: 100%;
    border-radius: 1rem;
    border: 1px solid rgba(148, 163, 184, 0.4);
    padding: 0.6rem 0.9rem;
    font-size: 0.95rem;
    color: #0f172a;
    background: rgba(248, 250, 252, 0.9);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6);
}
.resumo-search-card__input:focus {
    outline: none;
    border-color: rgba(14, 165, 233, 0.4);
    box-shadow: 0 0 0 2px rgba(14, 165, 233, 0.15);
}
.resumo-search-card__meta {
    font-size: 0.75rem;
    font-weight: 600;
    color: #475569;
}
.resumo-filter-toggle {
    border-radius: 999px;
    padding: 0.55rem 1rem;
    font-size: 0.85rem;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    font-weight: 600;
    color: #0f172a;
    border: 1px solid rgba(148, 163, 184, 0.35);
    background: rgba(255, 255, 255, 0.95);
    box-shadow: 0 12px 25px rgba(15, 23, 42, 0.08);
}
.resumo-filter-pill {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.2em;
    font-weight: 600;
    color: #10b981;
}
.resumo-list-meta {
    font-size: 0.85rem;
    color: #475569;
}
.resumo-select-row {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: space-between;
    gap: 0.75rem;
    margin-top: 1rem;
}
.resumo-select-all {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    font-weight: 600;
    color: #0f172a;
}
.resumo-select-all__input {
    width: 1.2rem;
    height: 1.2rem;
    border-radius: 0.4rem;
    border: 1px solid rgba(148, 163, 184, 0.6);
}
.resumo-select-actions {
    display: flex;
    align-items: center;
    gap: 0.6rem;
}
.resumo-chip-button {
    border-radius: 999px;
    border: 1px solid rgba(16, 185, 129, 0.35);
    padding: 0.4rem 0.9rem;
    font-size: 0.8rem;
    font-weight: 600;
    color: #047857;
    background: rgba(236, 253, 245, 0.9);
}
.resumo-chip-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}
.resumo-select-count {
    font-size: 0.8rem;
    color: #475569;
}
.resumo-bulk-assign {
    margin-top: 1rem;
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    align-items: center;
    padding: 0.75rem 1rem;
    border-radius: 1.25rem;
    background: rgba(248, 250, 252, 0.9);
    border: 1px solid rgba(226, 232, 240, 0.8);
}
.resumo-bulk-assign__select {
    border-radius: 999px;
    border: 1px solid rgba(148, 163, 184, 0.5);
    padding: 0.4rem 0.75rem;
    font-size: 0.85rem;
    background: white;
    color: #0f172a;
}
.resumo-bulk-assign__action {
    border-radius: 999px;
    padding: 0.45rem 1rem;
    font-size: 0.85rem;
    font-weight: 600;
    background: #0f172a;
    color: white;
}
.resumo-pagination {
    position: sticky;
    bottom: 0;
    border-radius: 1.5rem;
    background: rgba(255, 255, 255, 0.95);
    padding: 0.85rem 1.25rem;
    box-shadow: 0 -15px 30px rgba(15, 23, 42, 0.08);
    border: 1px solid rgba(226, 232, 240, 0.8);
    backdrop-filter: blur(10px);
}
.resumo-pagination__button {
    border-radius: 999px;
    border: 1px solid rgba(148, 163, 184, 0.5);
    padding: 0.35rem 0.9rem;
    font-weight: 600;
    font-size: 0.85rem;
    color: #475569;
}
.resumo-pagination__button:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}
.resumo-pagination__meta {
    display: flex;
    align-items: center;
    gap: 0.35rem;
    font-size: 0.85rem;
    color: #475569;
}
.resumo-pagination__input {
    width: 3.5rem;
    text-align: center;
    border-radius: 0.65rem;
    border: 1px solid rgba(148, 163, 184, 0.5);
    padding: 0.2rem 0.4rem;
}
.resumo-selection-bar {
    position: sticky;
    bottom: 0;
    border-radius: 1.5rem;
    padding: 1rem;
    background: linear-gradient(140deg, rgba(15, 23, 42, 0.92), rgba(30, 41, 59, 0.82));
    color: white;
    box-shadow: 0 -22px 44px rgba(15, 23, 42, 0.32);
    border: 1px solid rgba(15, 23, 42, 0.35);
}

@keyframes resumoAurora {
    0% {
        transform: translate(0, 0);
    }
    50% {
        transform: translate(-5%, 5%);
    }
    100% {
        transform: translate(0, 0);
    }
}

@keyframes resumoFloat {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-5px);
    }
}

@keyframes shimmer {
    0% {
        background-position: 200% 0;
    }
    100% {
        background-position: -200% 0;
    }
}

@keyframes resumoWarmShift {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

@keyframes resumoWarmShimmer {
    0% {
        transform: translateX(-120%);
        opacity: 0;
    }
    40% {
        opacity: 0.8;
    }
    70% {
        transform: translateX(120%);
        opacity: 0;
    }
    100% {
        opacity: 0;
    }
}

@keyframes resumoCoolShift {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

@keyframes resumoCoolShimmer {
    0% {
        transform: translateX(-140%);
        opacity: 0;
    }
    40% {
        opacity: 0.9;
    }
    70% {
        transform: translateX(140%);
        opacity: 0;
    }
    100% {
        opacity: 0;
    }
}

@keyframes resumoItemsAurora {
    0% {
        opacity: 0.6;
        transform: translate3d(0, 0, 0);
    }
    50% {
        opacity: 0.9;
        transform: translate3d(-12px, 8px, 0);
    }
    100% {
        opacity: 0.6;
        transform: translate3d(0, 0, 0);
    }
}
</style>
