<template>
    <div class="auth-shell">
        <div class="auth-aura" aria-hidden="true"></div>
        <div class="auth-card">
            <div class="auth-hero">
                <TileIcon3D tone="emerald" class="auth-hero__icon">
                    <Lock class="h-5 w-5" />
                </TileIcon3D>
                <div>
                    <p class="auth-eyebrow">Etapa 00 • Bem-vindo</p>
                    <h1 class="auth-hero__title">Entrar no EasyTrip</h1>
                    <p class="auth-hero__subtitle">Acesse com seu email e continue organizando a mudança com calma.</p>
                </div>
            </div>

            <form class="auth-form" @submit.prevent="submit">
                <label class="auth-field">
                    <span class="auth-field__label">Email</span>
                    <div class="auth-field__control">
                        <Mail class="auth-field__icon" aria-hidden="true" />
                        <input
                            id="email"
                            v-model="form.email"
                            type="email"
                            required
                            autocomplete="email"
                            class="auth-input"
                            placeholder="voce@email.com"
                        />
                    </div>
                    <p v-if="form.errors.email" class="auth-field__error">
                        {{ form.errors.email }}
                    </p>
                </label>

                <label class="auth-field">
                    <span class="auth-field__label">Senha</span>
                    <div class="auth-field__control">
                        <Lock class="auth-field__icon" aria-hidden="true" />
                        <input
                            id="password"
                            v-model="form.password"
                            type="password"
                            required
                            autocomplete="current-password"
                            class="auth-input"
                            placeholder="••••••••"
                        />
                    </div>
                    <p v-if="form.errors.password" class="auth-field__error">
                        {{ form.errors.password }}
                    </p>
                </label>

                <div class="auth-inline">
                    <label class="auth-remember">
                        <input
                            v-model="form.remember"
                            type="checkbox"
                            class="auth-remember__checkbox"
                        />
                        <span>Lembrar de mim</span>
                    </label>
                    <button
                        type="button"
                        class="auth-link auth-link--muted"
                        @click.prevent.stop="toggleAdminShortcut"
                        aria-label="Alternar modo admin"
                    >
                        •••
                    </button>
                </div>

                <button
                    type="submit"
                    class="auth-button"
                    :disabled="form.processing"
                >
                    <Loader2 v-if="form.processing" class="h-4 w-4 animate-spin" />
                    <span>{{ form.processing ? 'Entrando...' : 'Entrar' }}</span>
                </button>
            </form>

            <p class="auth-footer">
                Ainda não tem conta?
                <Link :href="route('register')" class="auth-link">
                    Crie uma agora
                </Link>
            </p>
        </div>
    </div>
</template>

<script setup>
import { Link, useForm, router, usePage } from '@inertiajs/vue3';
import { route } from 'ziggy-js';
import { computed, watch } from 'vue';
import { Loader2, Lock, Mail } from 'lucide-vue-next';
import TileIcon3D from '@/Components/home/TileIcon3D.vue';

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

<style scoped>
.auth-shell {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 3rem 1.5rem;
    background: linear-gradient(135deg, #f8fafc, #ecfeff);
    position: relative;
    overflow: hidden;
}
.auth-aura {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 15% 20%, rgba(16, 185, 129, 0.15), transparent 55%), radial-gradient(circle at 85% 10%, rgba(6, 182, 212, 0.12), transparent 50%);
    filter: blur(20px);
    pointer-events: none;
}
.auth-card {
    position: relative;
    width: 100%;
    max-width: 420px;
    border-radius: 2rem;
    padding: 2rem;
    background: rgba(255, 255, 255, 0.92);
    border: 1px solid rgba(148, 163, 184, 0.25);
    box-shadow: 0 35px 65px rgba(15, 23, 42, 0.15);
    backdrop-filter: blur(8px);
    display: grid;
    gap: 1.75rem;
}
.auth-hero {
    display: flex;
    gap: 1rem;
    align-items: center;
}
.auth-hero__icon {
    --tile-icon-size: 3.2rem;
    animation: float 9s ease-in-out infinite;
}
.auth-eyebrow {
    font-size: 0.75rem;
    letter-spacing: 0.4em;
    text-transform: uppercase;
    font-weight: 600;
    color: #0f766e;
}
.auth-hero__title {
    font-size: 1.75rem;
    font-weight: 600;
    color: #0f172a;
}
.auth-hero__subtitle {
    margin-top: 0.35rem;
    font-size: 0.95rem;
    color: #475569;
}
.auth-form {
    display: grid;
    gap: 1.2rem;
}
.auth-field {
    display: grid;
    gap: 0.4rem;
}
.auth-field__label {
    font-size: 0.85rem;
    font-weight: 600;
    color: #0f172a;
}
.auth-field__control {
    position: relative;
}
.auth-field__icon {
    position: absolute;
    left: 0.9rem;
    top: 50%;
    transform: translateY(-50%);
    width: 1rem;
    height: 1rem;
    color: #0f766e;
}
.auth-input {
    width: 100%;
    padding: 0.7rem 0.95rem 0.7rem 2.4rem;
    border-radius: 1.25rem;
    border: 1px solid rgba(16, 185, 129, 0.25);
    background: rgba(255, 255, 255, 0.95);
    font-size: 0.95rem;
    color: #0f172a;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.8),
        0 14px 28px rgba(15, 23, 42, 0.08);
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}
.auth-input:focus {
    outline: none;
    border-color: rgba(6, 182, 212, 0.5);
    box-shadow: 0 0 0 2px rgba(6, 182, 212, 0.2), 0 18px 35px rgba(6, 182, 212, 0.15);
}
.auth-field__error {
    font-size: 0.75rem;
    font-weight: 600;
    color: #b91c1c;
}
.auth-inline {
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.auth-remember {
    display: inline-flex;
    align-items: center;
    gap: 0.45rem;
    font-size: 0.85rem;
    color: #475569;
}
.auth-remember__checkbox {
    width: 1rem;
    height: 1rem;
    border-radius: 0.35rem;
    border: 1px solid rgba(148, 163, 184, 0.5);
    color: #0ea5e9;
}
.auth-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    border-radius: 999px;
    padding: 0.75rem 1.2rem;
    font-size: 0.95rem;
    font-weight: 600;
    color: white;
    background: linear-gradient(120deg, #059669, #0ea5e9);
    box-shadow: 0 20px 35px rgba(14, 165, 233, 0.25);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.auth-button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}
.auth-button:active {
    transform: scale(0.97);
}
.auth-footer {
    font-size: 0.9rem;
    color: #475569;
    text-align: center;
}
.auth-link {
    font-weight: 600;
    color: #0f766e;
    transition: color 0.2s ease;
}
.auth-link:hover {
    color: #0ea5e9;
}
.auth-link--muted {
    font-size: 0.8rem;
    color: rgba(15, 23, 42, 0.4);
}
.auth-link--muted:hover {
    color: #0f172a;
}
@keyframes float {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-4px);
    }
}
@media (max-width: 480px) {
    .auth-card {
        padding: 1.5rem;
    }
    .auth-shell {
        padding: 2rem 1rem;
    }
}
</style>
