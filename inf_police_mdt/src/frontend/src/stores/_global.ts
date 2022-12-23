import {writable} from "svelte/store";

export const _global = writable({
    page: 1
});
