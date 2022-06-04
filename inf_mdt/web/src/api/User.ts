import {capitalize} from "../utils/misc";

export class User {

    public nombre: string;
    public trabajo: Trabajo;
    public rango: number;

    constructor(nombre: string) {
        this.nombre = nombre;
        this.trabajo = Trabajo.NINGUNO
        this.rango = 0
    }

    public getRango = (): string => {
        switch (this.trabajo) {
            case Trabajo.POLICIA:
                return capitalize(RangoPolicia[this.rango]);
            case Trabajo.EMS:
                return capitalize(RangoEMS[this.rango]);
            case Trabajo.MECANICO:
                return capitalize(RangoMecanico[this.rango]);
            default:
                return 'Desempleado';
        }
    }
}

export enum Trabajo {
    NINGUNO = 'Ninguno', POLICIA = 'Policia', EMS = 'EMS', MECANICO = 'Mecánico'
}

export enum RangoPolicia {
    CADETE, OFICIAL, INSPECTOR, SUBCOMISARIO, COMISARIO
}
export enum RangoEMS {
    DES
}
export enum RangoMecanico {
    DES
}