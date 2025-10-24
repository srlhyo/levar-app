<template>
    <Head title="Decidir o que Levar" />
    <div class="min-h-screen bg-background">
        <div class="p-6 text-center border-b border-border">
            <h1 class="text-3xl font-bold mb-2">Decidir o que Levar</h1>
            <p class="text-muted-foreground">Organize sua mudança de forma simples e visual</p>
        </div>

        <div class="p-6 grid gap-4 max-w-2xl mx-auto">
            <ModeCard
                title="Catalogar"
                subtitle="Tire fotos e adicione itens"
                bg-class="bg-catalog-secondary"
                gradient-class="bg-gradient-catalog"
                text-class="text-catalog"
                :disabled="!fullModeActive"
                @click="navigate('/catalogar')"
            >
                <template #icon>
                    <Camera class="h-8 w-8 text-white" />
                </template>
            </ModeCard>

            <ModeCard
                title="Decidir"
                subtitle="Escolha o que levar"
                bg-class="bg-decide-secondary"
                gradient-class="bg-gradient-decide"
                text-class="text-decide"
                @click="navigate('/decidir')"
            >
                <template #icon>
                    <Heart class="h-8 w-8 text-white" />
                </template>
            </ModeCard>

            <ModeCard
                title="Embalar"
                subtitle="Organize suas malas"
                bg-class="bg-pack-secondary"
                gradient-class="bg-gradient-pack"
                text-class="text-pack"
                :disabled="!fullModeActive"
                @click="navigate('/pick')"
            >
                <template #icon>
                    <Package class="h-8 w-8 text-white" />
                </template>
            </ModeCard>

            <ModeCard
                title="Resumo"
                subtitle="Veja o progresso"
                bg-class="bg-summary-secondary"
                gradient-class="bg-gradient-summary"
                text-class="text-summary"
                :disabled="!fullModeActive"
                @click="navigate('/resumo')"
            >
                <template #icon>
                    <FileText class="h-8 w-8 text-white" />
                </template>
            </ModeCard>
        </div>

        <div class="p-6 text-center text-sm text-muted-foreground">
            <p class="cursor-pointer select-none" @click="handleFooterClick">
                UK → Brasil • 2 malas de 23kg cada
            </p>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import { Head, router } from '@inertiajs/vue3';
import { Camera, Heart, Package, FileText } from 'lucide-vue-next';
import ModeCard from '@/Components/ModeCard.vue';
import { toast } from '@/utils/toast';
import AppLayout from '@/Layouts/AppLayout.vue';

defineOptions({ layout: AppLayout });

const fullModeActive = ref(false);
const clickCount = ref(0);

const navigate = (url) => {
    router.visit(url);
};

const handleFooterClick = () => {
    clickCount.value += 1;
    if (clickCount.value === 3) {
        fullModeActive.value = true;
        toast.success('Modo completo ativado ✨');
    }
};
</script>
