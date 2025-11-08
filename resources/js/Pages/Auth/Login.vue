<template>
    <div class="min-h-screen bg-slate-50 text-slate-900">
        <div class="mx-auto flex min-h-screen max-w-md flex-col justify-center px-4 py-12">
            <div class="rounded-3xl bg-white/90 p-8 shadow-lg ring-1 ring-black/5 space-y-6">
                <header class="space-y-1">
                    <p class="text-xs font-semibold uppercase tracking-wide text-emerald-500">Bem-vindo</p>
                    <h1 class="text-2xl font-bold text-slate-900 sm:text-3xl">Entrar</h1>
                    <p class="text-sm text-slate-600">
                        Acesse o Levar com seu email e senha.
                    </p>
                </header>

                <form class="space-y-4" @submit.prevent="submit">
                    <div class="space-y-2">
                        <label for="email" class="text-sm font-medium text-slate-700">Email</label>
                        <input
                            id="email"
                            v-model="form.email"
                            type="email"
                            required
                            autocomplete="email"
                            class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-2 text-slate-900 shadow-inner shadow-slate-200 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                            placeholder="voce@email.com"
                        />
                        <p v-if="form.errors.email" class="text-xs font-semibold text-rose-500">
                            {{ form.errors.email }}
                        </p>
                    </div>

                    <div class="space-y-2">
                        <label for="password" class="text-sm font-medium text-slate-700">Senha</label>
                        <input
                            id="password"
                            v-model="form.password"
                            type="password"
                            required
                            autocomplete="current-password"
                            class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-2 text-slate-900 shadow-inner shadow-slate-200 focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-200"
                            placeholder="••••••••"
                        />
                        <p v-if="form.errors.password" class="text-xs font-semibold text-rose-500">
                            {{ form.errors.password }}
                        </p>
                    </div>

                    <div class="flex items-center justify-between">
                        <label class="inline-flex items-center gap-2 text-sm text-slate-600">
                            <input
                                v-model="form.remember"
                                type="checkbox"
                                class="h-4 w-4 rounded border-slate-300 text-emerald-500 focus:ring-emerald-400"
                            />
                            Lembrar de mim
                        </label>
                        <button
                            type="button"
                            class="text-xs font-semibold uppercase tracking-wide text-slate-300 transition hover:text-slate-500"
                            @click.prevent.stop="toggleAdminShortcut"
                            aria-label="Alternar modo admin"
                        >
                            •••
                        </button>
                    </div>

                    <button
                        type="submit"
                        class="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-emerald-500 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-emerald-400 disabled:cursor-not-allowed disabled:opacity-60"
                        :disabled="form.processing"
                    >
                        <Loader2 v-if="form.processing" class="h-4 w-4 animate-spin" />
                        <span>{{ form.processing ? 'Entrando...' : 'Entrar' }}</span>
                    </button>
                </form>

                <p class="text-sm text-slate-600">
                    Ainda não tem conta?
                    <Link :href="route('register')" class="font-semibold text-emerald-600 hover:text-emerald-500">
                        Crie uma agora
                    </Link>
                </p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Link, useForm, router, usePage } from '@inertiajs/vue3';
import { route } from 'ziggy-js';
import { computed, watch } from 'vue';
import { Loader2 } from 'lucide-vue-next';

const page = usePage();
const csrfToken = computed(() => page.props.csrf_token);

const form = useForm({
    email: '',
    password: '',
    remember: false,
    _token: csrfToken.value,
});

watch(csrfToken, (token) => {
    form._token = token ?? '';
});

const toggleAdminShortcut = () => {
    router.visit(route('register', { admin: 1 }));
};

const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
    });
};
</script>
