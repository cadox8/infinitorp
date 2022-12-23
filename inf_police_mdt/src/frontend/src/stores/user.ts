import {writable} from "svelte/store";
import type IUser from "$typings/IClient";

export const user = writable<IUser>({
    cid: "",
    fn: "Carter",
    ln: "Zamgato",
    callsign: "192",
    pLevel: 0,
    profile_picture: "",
});
