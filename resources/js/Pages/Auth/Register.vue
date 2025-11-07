<template>
    <div class="min-h-screen bg-slate-50 text-slate-900">
        <div class="mx-auto flex min-h-screen max-w-md flex-col justify-center px-4 py-12">
            <div class="rounded-3xl bg-white/90 p-8 shadow-lg ring-1 ring-black/5 space-y-6">
                <header class="space-y-1">
                    <p class="text-xs font-semibold uppercase tracking-wide text-sky-500">Criar conta</p>
                    <h1 class="text-2xl font-bold text-slate-900 sm:text-3xl">Comece agora</h1>
                    <p class="text-sm text-slate-600">
                        Registre-se para organizar sua mudança com o Levar.
                    </p>
                </header>

                <form class="space-y-4" @submit.prevent="submit">
                    <div class="space-y-2">
                        <label for="name" class="text-sm font-medium text-slate-700">Nome completo</label>
                        <input
                            id="name"
                            v-model="form.name"
                            type="text"
                            required
                            autocomplete="name"
                            class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-2 text-slate-900 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            placeholder="Seu nome"
                        />
                        <p v-if="form.errors.name" class="text-xs font-semibold text-rose-500">
                            {{ form.errors.name }}
                        </p>
                    </div>

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

                    <div class="space-y-2">
                        <label for="password" class="text-sm font-medium text-slate-700">Senha</label>
                        <input
                            id="password"
                            v-model="form.password"
                            type="password"
                            required
                            autocomplete="new-password"
                            class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-2 text-slate-900 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            placeholder="Mínimo de 8 caracteres"
                        />
                        <p v-if="form.errors.password" class="text-xs font-semibold text-rose-500">
                            {{ form.errors.password }}
                        </p>
                    </div>

                    <div class="space-y-2">
                        <label for="password_confirmation" class="text-sm font-medium text-slate-700">Confirmar senha</label>
                        <input
                            id="password_confirmation"
                            v-model="form.password_confirmation"
                            type="password"
                            required
                            autocomplete="new-password"
                            class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-2 text-slate-900 shadow-inner shadow-slate-200 focus:border-sky-400 focus:outline-none focus:ring-2 focus:ring-sky-200"
                            placeholder="Repita a senha"
                        />
                    </div>

                    <div
                        v-if="showAdminToggle"
                        class="flex items-center justify-between rounded-2xl bg-emerald-50 px-3 py-2 text-xs font-semibold text-emerald-700"
                    >
                        <label class="inline-flex items-center gap-2">
                            <input
                                v-model="form.is_admin"
                                type="checkbox"
                                class="h-4 w-4 rounded border-emerald-300 text-emerald-500 focus:ring-emerald-400"
                            />
                            Registrar como admin
                        </label>
                        <button
                            type="button"
                            class="text-[11px] font-semibold uppercase tracking-wide text-emerald-600 hover:text-emerald-500"
                            @click="showAdminToggle = false"
                        >
                            fechar
                        </button>
                    </div>

                    <button
                        type="submit"
                        class="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-sky-500 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-sky-400 disabled:cursor-not-allowed disabled:opacity-60"
                        :disabled="form.processing"
                    >
                        <Loader2 v-if="form.processing" class="h-4 w-4 animate-spin" />
                        <span>{{ form.processing ? 'Criando conta...' : 'Cadastrar' }}</span>
                    </button>
                </form>

                <p class="text-sm text-slate-600 flex items-center justify-between">
                    Já tem uma conta?
                    <Link :href="route('login')" class="font-semibold text-sky-600 hover:text-sky-500">
                        Fazer login
                    </Link>
                    <button
                        type="button"
                        class="text-[11px] font-semibold uppercase tracking-wide text-slate-300 transition hover:text-slate-500"
                        @click="showAdminToggle = !showAdminToggle"
                    >
                        Modo admin
                    </button>
                </p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';
import { route } from 'ziggy-js';
import { Loader2 } from 'lucide-vue-next';

const page = usePage();
const initialShowAdmin = page.url?.includes('admin=1') ?? false;
const csrfToken = computed(() => page.props.csrf_token);

const form = useForm({
    name: '',
    email: '',
    password: '',
    password_confirmation: '',
    is_admin: false,
    _token: csrfToken.value,
});

const showAdminToggle = ref(initialShowAdmin);

watch(csrfToken, (token) => {
    form._token = token ?? '';
});

const submit = () => {
    form.post(route('register'), {
        onFinish: () => form.reset('password', 'password_confirmation', 'is_admin'),
    });
};
</script>
