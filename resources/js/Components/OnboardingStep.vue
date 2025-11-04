<template>
    <div class="rounded-3xl bg-white/85 p-5 shadow-lg/30 ring-1 ring-black/5 transition hover:-translate-y-0.5 hover:shadow-xl">
        <div class="flex items-start gap-4">
            <div class="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full bg-emerald-100 text-emerald-600">
                <slot name="icon">✨</slot>
            </div>
            <div class="space-y-2 text-left">
                <h3 class="text-base font-semibold text-slate-800 sm:text-lg">
                    <slot name="title" />
                </h3>
                <p class="text-sm leading-relaxed text-slate-600 sm:text-base">
                    <slot />
                </p>
            </div>
        </div>
    </div>
</template>
