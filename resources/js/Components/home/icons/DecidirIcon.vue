<template>
    <div class="decidir-icon" aria-hidden="true">
        <span class="decidir-icon__glow"></span>
        <div class="decidir-card decidir-card--yes">
            <span class="label">Levar</span>
            <span class="emoji">❤️</span>
        </div>
        <div class="decidir-card decidir-card--no">
            <span class="label">Não levar</span>
            <span class="emoji">✕</span>
        </div>
        <div class="decidir-card decidir-card--pending">
            <span class="label">Depois</span>
            <span class="emoji">🌀</span>
        </div>
    </div>
</template>

<script setup>
// purely visual
</script>

<style scoped>
.decidir-icon {
    position: relative;
    width: 86px;
    height: 86px;
    perspective: 900px;
}

.decidir-icon__glow {
    position: absolute;
    inset: 16px;
    border-radius: 1.75rem;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.5), transparent 70%);
    filter: blur(10px);
    opacity: 0.6;
}

.decidir-card {
    position: absolute;
    inset: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.2rem;
    border-radius: 1.25rem;
    border: 1px solid rgba(255, 255, 255, 0.6);
    color: white;
    text-shadow: 0 10px 30px rgba(15, 23, 42, 0.4);
    box-shadow: 0 15px 40px rgba(15, 23, 42, 0.35);
    transform-style: preserve-3d;
    font-size: 0.6rem;
    text-transform: uppercase;
    letter-spacing: 0.08em;
}
.decidir-card .emoji {
    font-size: 1.4rem;
}

.decidir-card--yes {
    background: linear-gradient(135deg, #22d3ee, #818cf8);
    animation: cardYes 6s ease-in-out infinite;
}
.decidir-card--no {
    background: linear-gradient(135deg, #fb7185, #f43f5e);
    animation: cardNo 6s ease-in-out infinite;
}
.decidir-card--pending {
    background: linear-gradient(135deg, #fbbf24, #fb923c);
    animation: cardPending 6s ease-in-out infinite;
}

@keyframes cardYes {
    0% {
        transform: translate3d(-14px, -8px, 30px) rotateX(15deg) rotateY(-18deg);
    }
    50% {
        transform: translate3d(-6px, -10px, 40px) rotateX(8deg) rotateY(-6deg);
    }
    100% {
        transform: translate3d(-14px, -8px, 30px) rotateX(15deg) rotateY(-18deg);
    }
}
@keyframes cardNo {
    0% {
        transform: translate3d(16px, 6px, -20px) rotateX(-12deg) rotateY(16deg);
    }
    50% {
        transform: translate3d(8px, 8px, -10px) rotateX(-4deg) rotateY(6deg);
    }
    100% {
        transform: translate3d(16px, 6px, -20px) rotateX(-12deg) rotateY(16deg);
    }
}
@keyframes cardPending {
    0% {
        transform: translate3d(0, 0, 0) rotateX(0deg) rotateY(0deg);
    }
    50% {
        transform: translate3d(0, -4px, 10px) rotateX(4deg) rotateY(-4deg);
    }
    100% {
        transform: translate3d(0, 0, 0) rotateX(0deg) rotateY(0deg);
    }
}

@media (prefers-reduced-motion: reduce) {
    .decidir-card {
        animation: none;
        transform: translate3d(0, 0, 0);
    }
}
</style>
