<template>
    <div class="auth-shell">
        <div class="auth-aura" aria-hidden="true"></div>
        <div class="auth-card">
            <div class="auth-logo" aria-label="EasyTrip">
                <div class="auth-logo__inner">
                    <span class="auth-logo__mark">
                        <span>Easy</span>
                        <span>Trip</span>
                    </span>
                    <span class="auth-logo__spark" aria-hidden="true"></span>
                </div>
            </div>
            <div class="auth-hero">
                <TileIcon3D tone="emerald" class="auth-hero__icon auth-hero__icon--glow">
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
                        <span class="auth-field__icon">
                            <Mail class="h-4 w-4" aria-hidden="true" />
                        </span>
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
                        <span class="auth-field__icon">
                            <Lock class="h-4 w-4" aria-hidden="true" />
                        </span>
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
    padding: 2.5rem 2.2rem 2.2rem;
    background: rgba(255, 255, 255, 0.95);
    border: 1px solid rgba(45, 212, 191, 0.25);
    box-shadow:
        0 35px 65px rgba(15, 23, 42, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(18px);
    display: grid;
    gap: 1.75rem;
}
.auth-card::before {
    content: '';
    position: absolute;
    inset: 0.9rem;
    border-radius: 1.7rem;
    background: linear-gradient(140deg, rgba(16, 185, 129, 0.2), rgba(6, 182, 212, 0.18));
    opacity: 0.8;
    filter: blur(18px);
    z-index: 0;
    pointer-events: none;
}
.auth-card > * {
    position: relative;
    z-index: 1;
}
.auth-logo {
    display: flex;
    justify-content: center;
}
.auth-logo__inner {
    position: relative;
    width: 120px;
    height: 120px;
    border-radius: 999px;
    background: linear-gradient(160deg, #10b981, #14b8a6, #0ea5e9, #5eead4);
    background-size: 220% 220%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow:
        inset 0 0 25px rgba(255, 255, 255, 0.35),
        0 25px 45px rgba(15, 118, 110, 0.45);
    overflow: hidden;
    animation:
        authLogoPulse 10s ease-in-out infinite,
        authLogoGradient 14s ease-in-out infinite;
}
.auth-logo__inner::after {
    content: '';
    position: absolute;
    inset: 8px;
    border-radius: inherit;
    border: 1px solid rgba(255, 255, 255, 0.35);
}
.auth-logo__mark {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.1rem;
    font-size: 1.12rem;
    font-weight: 700;
    letter-spacing: 0.32rem;
    text-transform: uppercase;
    color: white;
    line-height: 1;
    text-shadow: 0 6px 15px rgba(2, 44, 34, 0.4);
}
.auth-logo__mark span:last-child {
    font-size: 1.15rem;
    letter-spacing: 0.08rem;
    font-family: 'Great Vibes', 'Pacifico', 'Caveat', cursive;
    font-weight: 600;
    text-transform: none;
    text-shadow: 0 5px 12px rgba(2, 44, 34, 0.35);
    transform: translateY(-0.05rem) rotate(-4deg);
}
.auth-logo__spark {
    position: absolute;
    width: 70%;
    height: 70%;
    border-radius: inherit;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.8), transparent 65%);
    top: -10%;
    left: -15%;
    opacity: 0.7;
    animation: authSparkle 6s ease-in-out infinite;
}
.auth-hero {
    display: flex;
    gap: 1rem;
    align-items: center;
}
.auth-hero__icon {
    --tile-icon-size: 3.2rem;
    animation: float 9s ease-in-out infinite;
    filter: drop-shadow(0 12px 22px rgba(16, 185, 129, 0.35));
    position: relative;
}
.auth-hero__icon--glow::after {
    content: '';
    position: absolute;
    inset: -8px;
    border-radius: 1.2rem;
    background: radial-gradient(circle, rgba(16, 185, 129, 0.3), transparent 65%);
    filter: blur(10px);
    z-index: -1;
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
    padding: 1.25rem 1.1rem;
    border-radius: 1.75rem;
    background: linear-gradient(145deg, rgba(240, 253, 250, 0.8), rgba(219, 234, 254, 0.75));
    border: 1px solid rgba(45, 212, 191, 0.25);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.9),
        0 20px 45px rgba(15, 23, 42, 0.1);
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
    left: 0.4rem;
    top: 50%;
    transform: translateY(-50%);
    width: 2.4rem;
    height: 2.4rem;
    border-radius: 999px;
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(6, 182, 212, 0.35));
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: #0f766e;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.5),
        0 8px 18px rgba(15, 118, 110, 0.25);
    animation: authIconPulse 8s ease-in-out infinite;
}
.auth-input {
    width: 100%;
    padding: 0.7rem 0.95rem 0.7rem 3.2rem;
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
.auth-remember {
    display: inline-flex;
    align-items: center;
    gap: 0.50rem;
    font-size: 0.85rem;
    color: #475569;
}
.auth-admin {
    border-radius: 1.5rem;
    border: 1px solid rgba(16, 185, 129, 0.3);
    background: rgba(240, 253, 250, 0.95);
    padding: 0.85rem 1rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.85);
}
.auth-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    border-radius: 1.75rem;
    padding: 0.85rem 1.35rem;
    font-size: 0.95rem;
    font-weight: 600;
    color: white;
    border: 1px solid rgba(255, 255, 255, 0.35);
    background: linear-gradient(135deg, #059669, #0ea5e9, #2dd4bf, #0f766e);
    background-size: 250% 250%;
    box-shadow:
        0 22px 40px rgba(14, 165, 233, 0.3),
        0 10px 20px rgba(8, 145, 178, 0.35),
        inset 0 1px 0 rgba(255, 255, 255, 0.4);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    animation:
        authGradientShift 9s ease infinite,
        authButtonGlow 4s ease-in-out infinite;
    position: relative;
    overflow: hidden;
}
.auth-button::after {
    content: '';
    position: absolute;
    inset: 3px;
    border-radius: inherit;
    border: 1px solid rgba(255, 255, 255, 0.45);
    opacity: 0.3;
    pointer-events: none;
}
.auth-button::before {
    content: '';
    position: absolute;
    top: -120%;
    left: -35%;
    width: 50%;
    height: 300%;
    transform: rotate(25deg);
    background: linear-gradient(120deg, rgba(255, 255, 255, 0.55), transparent 65%);
    animation: authButtonShine 4.5s linear infinite;
    pointer-events: none;
}
.auth-button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}
.auth-button:active {
    transform: scale(0.97);
}
.auth-button:focus-visible {
    outline: none;
    box-shadow:
        0 0 0 3px rgba(14, 165, 233, 0.2),
        0 18px 38px rgba(14, 165, 233, 0.25);
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
@keyframes authGradientShift {
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
@keyframes authButtonGlow {
    0%,
    100% {
        box-shadow:
            0 22px 40px rgba(14, 165, 233, 0.3),
            0 10px 20px rgba(8, 145, 178, 0.35),
            inset 0 1px 0 rgba(255, 255, 255, 0.4);
    }
    50% {
        box-shadow:
            0 28px 50px rgba(14, 165, 233, 0.35),
            0 14px 26px rgba(5, 150, 105, 0.35),
            inset 0 1px 0 rgba(255, 255, 255, 0.55);
    }
}
@keyframes authLogoPulse {
    0%,
    100% {
        transform: translateY(0) scale(1);
    }
    50% {
        transform: translateY(-6px) scale(1.03);
    }
}
@keyframes authLogoGradient {
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
@keyframes authSparkle {
    0%,
    100% {
        transform: rotate(0deg) scale(1);
        opacity: 0.55;
    }
    50% {
        transform: rotate(12deg) scale(1.05);
        opacity: 0.85;
    }
}
@keyframes authIconPulse {
    0%,
    100% {
        transform: translateY(-50%) scale(1);
    }
    50% {
        transform: translateY(-55%) scale(1.05);
    }
}
@keyframes authButtonShine {
    0% {
        transform: translate(-120%, -120%) rotate(25deg);
    }
    100% {
        transform: translate(220%, -120%) rotate(25deg);
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
