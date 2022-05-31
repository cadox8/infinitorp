import {fetchNui} from "../utils/fetchNui";
import {PRegistro} from "../api/Ciudadano";

const CiudadanoProvider = (): any => {

    const borrarRegistro = (registro: string): void => {
        fetchNui('borrarRegistro', {registro: registro}).then(r => {});
    }

    const añadirMulta = (registro: PRegistro): void => {
        fetchNui('añadirRegistro', { registro: registro }).then(r => {});
    }

    return { borrarRegistro, añadirMulta }
}

export default CiudadanoProvider