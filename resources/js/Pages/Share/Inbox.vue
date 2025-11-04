<template>
    <Head title="Inbox de Compartilhamento" />
    <AppLayout>
        <template #title>Inbox</template>
        <template #subtitle>Acompanhe os envios vindos do catalogador e veja o status de cada arquivo.</template>

        <Card tone="blue" class="space-y-4">
            <div class="flex flex-wrap items-center gap-3 text-xs font-semibold text-slate-600">
                <span class="rounded-full bg-white/80 px-3 py-1 shadow ring-1 ring-white/60">
                    {{ counts.uploading }} enviando
                </span>
                <span class="rounded-full bg-white/80 px-3 py-1 shadow ring-1 ring-white/60">
                    {{ counts.queued }} na fila
                </span>
                <span class="rounded-full bg-white/80 px-3 py-1 shadow ring-1 ring-white/60">
                    {{ counts.done }} concluídos
                </span>
                <span
                    v-if="counts.error"
                    class="rounded-full bg-rose-100/80 px-3 py-1 text-rose-600 shadow ring-1 ring-white/60"
                >
                    {{ counts.error }} com erro
                </span>
            </div>
        </Card>

        <Card tone="blue" class="overflow-hidden">
            <div
                class="grid grid-cols-[1.4fr,120px,140px,auto] gap-4 px-4 pb-3 text-xs font-semibold uppercase tracking-wide text-slate-600"
            >
                <span>Arquivo</span>
                <span>Tamanho</span>
                <span>Status</span>
                <span>Atualizado</span>
            </div>
            <div class="divide-y divide-white/60">
                <div
                    v-for="item in queue"
                    :key="item.id"
                    class="grid grid-cols-[1.4fr,120px,140px,auto] items-center gap-4 bg-white/60 px-4 py-4"
                >
                    <div class="flex items-center gap-3">
                        <IconPill tone="blue">
                            <component :is="statusConfig[item.status].icon" class="h-4 w-4" />
                        </IconPill>
                        <div>
                            <p class="text-sm font-semibold text-slate-900">{{ item.title ?? item.name }}</p>
                            <p class="text-xs text-slate-500">{{ item.description }}</p>
                        </div>
                    </div>
                    <span class="text-sm text-slate-600">{{ item.size }}</span>
                    <span
                        class="inline-flex items-center justify-center rounded-full px-3 py-1 text-xs font-semibold"
                        :class="statusConfig[item.status].badge"
                    >
                        {{ statusConfig[item.status].label }}
                    </span>
                    <span class="text-right text-xs text-slate-500">{{ item.updatedAt }}</span>
                </div>
            </div>
        </Card>

        <ToastUndo
            v-if="counts.error"
            message="1 upload falhou. Tocar para tentar novamente."
            :duration="6000"
            @undo="handleRetry"
        />
    </AppLayout>
</template>

<script setup>
import { computed, onMounted, watchEffect } from 'vue';
import { Head, usePage } from '@inertiajs/vue3';
import { AlertTriangle, CheckCircle2, Clock, Inbox, UploadCloud } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';
import ToastUndo from '@/Components/ToastUndo.vue';
import { useDecisionStore } from '@/stores/decision';
import { toast } from '@/utils/toast';

const decisionStore = useDecisionStore();
const page = usePage();
const move = computed(() => page.props.move ?? null);

watchEffect(() => {
    decisionStore.setMove(move.value);
});

onMounted(async () => {
    if (!move.value?.id) return;
    try {
        await decisionStore.fetchUploads();
    } catch (error) {
        console.error(error);
        toast.error('Não foi possível carregar a fila de uploads.');
    }
});

const statusConfig = {
    queued: {
        label: 'Na fila',
        icon: Clock,
        badge: 'bg-white px-3 py-1 text-xs font-semibold text-slate-600 ring-1 ring-slate-300/60',
    },
    uploading: {
        label: 'Enviando',
        icon: UploadCloud,
        badge: 'bg-sky-500/90 px-3 py-1 text-xs font-semibold text-white',
    },
    done: {
        label: 'Concluído',
        icon: CheckCircle2,
        badge: 'bg-emerald-500/90 px-3 py-1 text-xs font-semibold text-white',
    },
    error: {
        label: 'Erro',
        icon: AlertTriangle,
        badge: 'bg-rose-500/90 px-3 py-1 text-xs font-semibold text-white',
    },
};

const queue = computed(() => decisionStore.uploads.queue ?? []);

const counts = computed(() => {
    const source = decisionStore.uploads.counts ?? {};
    return {
        queued: source.queued ?? queue.value.filter((item) => item.status === 'queued').length,
        uploading: source.uploading ?? queue.value.filter((item) => item.status === 'uploading').length,
        done: source.done ?? queue.value.filter((item) => item.status === 'done').length,
        error: source.error ?? queue.value.filter((item) => item.status === 'error').length,
    };
});

const handleRetry = () => {
    toast.info('Reenvio iniciado. Continue pelo catalogador.');
};
</script>
