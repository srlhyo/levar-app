<template>
    <div class="min-h-screen bg-slate-50 text-slate-900">
        <div class="mx-auto flex min-h-screen max-w-md flex-col justify-center px-4 py-12">
            <div class="rounded-3xl bg-white/90 p-8 shadow-lg ring-1 ring-black/5">
                <h1 class="text-2xl font-bold text-slate-800 sm:text-3xl">Entrar</h1>
                <p class="mt-2 text-sm text-slate-600">
                    Informe seu email e enviaremos um link mágico para entrar.
                </p>

                <form class="mt-6 space-y-4" @submit.prevent="submit">
                    <input type="hidden" name="_token" :value="form._token" />
                    <div class="space-y-2">
                        <label for="email" class="text-sm font-medium text-slate-700">Email</label>
                        <input
                            id="email"
                            v-model="form.email"
                            type="email"
                            required
                            autocomplete="email"
                            class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-2 text-slate-900 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            placeholder="voce@email.com"
                        />
                        <p v-if="form.errors.email" class="text-xs font-semibold text-rose-500">
                            {{ form.errors.email }}
                        </p>
                    </div>
                    <button
                        type="submit"
                        class="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-sky-500 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-sky-400 disabled:cursor-not-allowed disabled:opacity-60"
                        :disabled="form.processing"
                    >
                        <Loader2 v-if="form.processing" class="h-4 w-4 animate-spin" />
                        <span>{{ form.processing ? 'Enviando...' : 'Enviar link' }}</span>
                    </button>
                </form>

                <p v-if="status" class="mt-6 rounded-2xl bg-emerald-50 px-4 py-3 text-sm font-medium text-emerald-600">
                    {{ status }}
                </p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useForm, usePage } from '@inertiajs/vue3';
import { computed, watch } from 'vue';
import { Loader2 } from 'lucide-vue-next';

const page = usePage();
const status = computed(() => page.props.flash?.status || page.props.status || null);
const csrfToken = computed(
    () =>
        page.props.csrf_token ??
        document.head?.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ??
        '',
);

const form = useForm({
    email: '',
    _token: csrfToken.value,
});

watch(
    csrfToken,
    (token) => {
        form._token = token ?? '';
    },
    { immediate: true },
);

const submit = () => {
    form.post(route('login.store'));
};
</script>
