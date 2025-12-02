<template>
    <div class="auth-shell">
        <div class="auth-aura register" aria-hidden="true"></div>
        <div class="auth-card">
            <div class="auth-hero">
                <TileIcon3D tone="sky" class="auth-hero__icon">
                    <UserPlus class="h-5 w-5" />
                </TileIcon3D>
                <div>
                    <p class="auth-eyebrow">Etapa 00 • Entrada</p>
                    <h1 class="auth-hero__title">Crie sua conta EasyTrip</h1>
                    <p class="auth-hero__subtitle">Registre-se para acompanhar peso, volume e decisões com tranquilidade.</p>
                </div>
            </div>

            <form class="auth-form" @submit.prevent="submit">
                <label class="auth-field">
                    <span class="auth-field__label">Nome completo</span>
                    <div class="auth-field__control">
                        <User class="auth-field__icon" aria-hidden="true" />
                        <input
                            id="name"
                            v-model="form.name"
                            type="text"
                            required
                            autocomplete="name"
                            class="auth-input"
                            placeholder="Seu nome"
                        />
                    </div>
                    <p v-if="form.errors.name" class="auth-field__error">
                        {{ form.errors.name }}
                    </p>
                </label>

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
                            autocomplete="new-password"
                            class="auth-input"
                            placeholder="Mínimo de 8 caracteres"
                        />
                    </div>
                    <p v-if="form.errors.password" class="auth-field__error">
                        {{ form.errors.password }}
                    </p>
                </label>

                <label class="auth-field">
                    <span class="auth-field__label">Confirmar senha</span>
                    <div class="auth-field__control">
                        <Lock class="auth-field__icon" aria-hidden="true" />
                        <input
                            id="password_confirmation"
                            v-model="form.password_confirmation"
                            type="password"
                            required
                            autocomplete="new-password"
                            class="auth-input"
                            placeholder="Repita a senha"
                        />
                    </div>
                </label>

                <div
                    v-if="showAdminToggle"
                    class="auth-admin"
                >
                    <label class="inline-flex items-center gap-2 text-sm font-semibold text-emerald-800">
                        <input
                            v-model="form.is_admin"
                            type="checkbox"
                            class="auth-remember__checkbox"
                        />
                        Registrar como admin
                    </label>
                    <button
                        type="button"
                        class="auth-link auth-link--muted"
                        @click="showAdminToggle = false"
                    >
                        fechar
                    </button>
                </div>

                <button
                    type="submit"
                    class="auth-button auth-button--cool"
                    :disabled="form.processing"
                >
                    <Loader2 v-if="form.processing" class="h-4 w-4 animate-spin" />
                    <span>{{ form.processing ? 'Criando conta...' : 'Cadastrar' }}</span>
                </button>
            </form>

            <div class="auth-footer auth-footer--dual">
                <span>Já tem uma conta?</span>
                <Link :href="route('login')" class="auth-link">
                    Fazer login
                </Link>
                <button
                    type="button"
                    class="auth-link auth-link--muted"
                    @click="showAdminToggle = !showAdminToggle"
                >
                    Modo admin
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';
import { route } from 'ziggy-js';
import { Loader2, Lock, Mail, User, UserPlus } from 'lucide-vue-next';
import TileIcon3D from '@/Components/home/TileIcon3D.vue';

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

<style scoped>
.auth-shell {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 3rem 1.5rem;
    background: linear-gradient(135deg, #fdf2f8, #f0fdfa);
    position: relative;
    overflow: hidden;
}
.auth-aura {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 20% 15%, rgba(186, 230, 253, 0.18), transparent 60%), radial-gradient(circle at 80% 0%, rgba(14, 165, 233, 0.12), transparent 55%);
    filter: blur(18px);
    pointer-events: none;
}
.auth-aura.register {
    background: radial-gradient(circle at 25% 10%, rgba(147, 197, 253, 0.2), transparent 60%), radial-gradient(circle at 80% 15%, rgba(99, 102, 241, 0.18), transparent 55%);
}
.auth-card {
    position: relative;
    width: 100%;
    max-width: 440px;
    border-radius: 2rem;
    padding: 2rem;
    background: rgba(255, 255, 255, 0.94);
    border: 1px solid rgba(148, 163, 184, 0.25);
    box-shadow: 0 40px 70px rgba(15, 23, 42, 0.18);
    backdrop-filter: blur(10px);
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
    color: #2563eb;
}
.auth-input {
    width: 100%;
    padding: 0.7rem 0.95rem 0.7rem 2.4rem;
    border-radius: 1.25rem;
    border: 1px solid rgba(99, 102, 241, 0.25);
    background: rgba(255, 255, 255, 0.95);
    font-size: 0.95rem;
    color: #0f172a;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.8),
        0 14px 28px rgba(99, 102, 241, 0.15);
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}
.auth-input:focus {
    outline: none;
    border-color: rgba(79, 70, 229, 0.45);
    box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.2), 0 18px 35px rgba(79, 70, 229, 0.15);
}
.auth-field__error {
    font-size: 0.75rem;
    font-weight: 600;
    color: #b91c1c;
}
.auth-admin {
    border-radius: 1.5rem;
    border: 1px solid rgba(34, 197, 94, 0.35);
    background: rgba(240, 253, 244, 0.9);
    padding: 0.8rem 1rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
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
    background: linear-gradient(120deg, #0ea5e9, #2563eb);
    box-shadow: 0 20px 35px rgba(59, 130, 246, 0.25);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.auth-button--cool {
    background: linear-gradient(120deg, #6366f1, #0ea5e9);
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
.auth-footer--dual {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.5rem;
}
.auth-link {
    font-weight: 600;
    color: #2563eb;
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
.auth-remember__checkbox {
    width: 1rem;
    height: 1rem;
    border-radius: 0.35rem;
    border: 1px solid rgba(148, 163, 184, 0.5);
    color: #0ea5e9;
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
    .auth-footer--dual {
        flex-direction: column;
        gap: 0.25rem;
    }
}
</style>
