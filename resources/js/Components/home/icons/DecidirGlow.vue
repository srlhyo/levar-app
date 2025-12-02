<template>
    <div class="decidir-glow" aria-hidden="true">
        <span class="decidir-glow__core"></span>
        <span class="decidir-glow__ring decidir-glow__ring--one"></span>
        <span class="decidir-glow__ring decidir-glow__ring--two"></span>
    </div>
</template>

<script setup>
// purely decorative
</script>

<style scoped>
.decidir-glow {
    position: relative;
    width: 70px;
    height: 70px;
    border-radius: 1.5rem;
    display: grid;
    place-items: center;
    overflow: hidden;
}

.decidir-glow__core {
    width: 42px;
    height: 42px;
    border-radius: 999px;
    background: linear-gradient(135deg, #4f46e5, #22d3ee);
    box-shadow: 0 12px 24px rgba(79, 70, 229, 0.35);
    animation: rotate 18s linear infinite;
}

.decidir-glow__ring {
    position: absolute;
    border-radius: 999px;
    border: 1px solid rgba(255, 255, 255, 0.6);
    animation: spin 20s linear infinite;
}
.decidir-glow__ring--one {
    inset: 8px;
}
.decidir-glow__ring--two {
    inset: 16px;
    animation-duration: 28s;
    opacity: 0.7;
}

@keyframes rotate {
    from {
        transform: rotate(0deg);
    }
    to {
        transform: rotate(360deg);
    }
}

@keyframes spin {
    0% {
        transform: rotateX(25deg) rotateZ(0deg);
    }
    100% {
        transform: rotateX(25deg) rotateZ(360deg);
    }
}

@media (prefers-reduced-motion: reduce) {
    .decidir-glow__core,
    .decidir-glow__ring {
        animation: none;
    }
}
</style>
