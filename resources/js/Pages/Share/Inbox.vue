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
                            <p class="text-sm font-semibold text-slate-900">{{ item.name }}</p>
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
            @undo="toast.info('Upload reenviado (mock)')"
        />
    </AppLayout>
</template>

<script setup>
import { computed } from 'vue';
import { Head } from '@inertiajs/vue3';
import { AlertTriangle, CheckCircle2, Clock, Inbox, UploadCloud } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Card from '@/Components/Card.vue';
import IconPill from '@/Components/IconPill.vue';
import ToastUndo from '@/Components/ToastUndo.vue';
import { toast } from '@/utils/toast';

const queue = [
    {
        id: 'upload-1',
        name: 'Sala • Sofa azul.heic',
        description: 'Tirado no iPhone da Lauren',
        size: '3.1 MB',
        status: 'uploading',
        updatedAt: 'há 12s',
    },
    {
        id: 'upload-2',
        name: 'Quarto • Roupa de cama.zip',
        description: '21 arquivos',
        size: '18.4 MB',
        status: 'queued',
        updatedAt: 'há 1 min',
    },
    {
        id: 'upload-3',
        name: 'Cozinha • Panelas novas.jpg',
        description: 'Adicionado pelo Pedro',
        size: '2.6 MB',
        status: 'done',
        updatedAt: 'há 5 min',
    },
    {
        id: 'upload-4',
        name: 'Garage • Ferramentas.mov',
        description: 'Vídeo 4K • verificar compressão',
        size: '125 MB',
        status: 'error',
        updatedAt: 'há 2 min',
    },
];

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

const counts = computed(() => ({
    queued: queue.filter((item) => item.status === 'queued').length,
    uploading: queue.filter((item) => item.status === 'uploading').length,
    done: queue.filter((item) => item.status === 'done').length,
    error: queue.filter((item) => item.status === 'error').length,
}));
</script>
