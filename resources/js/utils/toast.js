import { reactive } from 'vue';

const toasts = reactive([]);
let seed = 0;

const remove = (id) => {
    const index = toasts.findIndex((toast) => toast.id === id);
    if (index !== -1) {
        toasts.splice(index, 1);
    }
};

const push = ({ message, title, variant = 'info', duration = 3000 }) => {
    const id = ++seed;
    toasts.push({ id, message, title, variant });

    if (duration !== Infinity) {
        const timeout = duration ?? 3000;
        window.setTimeout(() => remove(id), timeout);
    }

    return id;
};

export const toast = {
    show(options) {
        return push(options);
    },
    success(message, options = {}) {
        return push({ message, variant: 'success', ...options });
    },
    error(message, options = {}) {
        return push({ message, variant: 'error', ...options });
    },
    info(message, options = {}) {
        return push({ message, variant: 'info', ...options });
    },
};

export const useToastStore = () => ({
    toasts,
    dismiss: remove,
});
