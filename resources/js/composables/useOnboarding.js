import axios from 'axios';
import { computed, reactive } from 'vue';

const state = reactive({
    ready: false,
    historySeen: false,
    tourSeen: false,
});

const initialize = () => {
    if (state.ready) return;

    if (typeof window !== 'undefined' && window?.Inertia?.page?.props?.auth?.onboarding) {
        const onboarding = window.Inertia.page.props.auth.onboarding;
        state.historySeen = Boolean(onboarding?.history);
        state.tourSeen = Boolean(onboarding?.tour);
    }

    state.ready = true;
};

const persist = async () => {
    try {
        await axios.post('/api/onboarding', {
            history: state.historySeen,
            tour: state.tourSeen,
        });
        if (typeof window !== 'undefined' && window?.Inertia?.page?.props?.auth) {
            window.Inertia.page.props.auth.onboarding = {
                history: state.historySeen,
                tour: state.tourSeen,
            };
        }
    } catch (error) {
        console.error('Unable to persist onboarding state', error);
    }
};

export const useOnboarding = () => {
    initialize();

    const shouldShowHistory = computed(() => state.ready && !state.historySeen);
    const shouldShowTour = computed(() => state.ready && state.historySeen && !state.tourSeen);

    const dismissHistory = async () => {
        state.historySeen = true;
        await persist();
    };

    const dismissTour = async () => {
        state.tourSeen = true;
        await persist();
    };

    const reset = async () => {
        state.historySeen = false;
        state.tourSeen = false;
        await persist();
    };

    return {
        ready: computed(() => state.ready),
        shouldShowHistory,
        shouldShowTour,
        historySeen: computed(() => state.historySeen),
        tourSeen: computed(() => state.tourSeen),
        dismissHistory,
        dismissTour,
        reset,
    };
};
