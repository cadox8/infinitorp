export interface Ciudadano {
    identificador: string
    nombre: string
    apellidos: string
    telefono: string
    imagen?: string
    nacimiento: string
    coches: Coche[]
    propiedades: Propiedad[]
    delictivo: Policia
}

export interface Coche {
    nombre: string
    matricula: string
}

export interface Propiedad {
    direccion: string
    calle: string
}

// -- Policial --
export interface Policia {
    peligroso: boolean
    cod9?: Cod9
    notas: string
    registros: PRegistro[]
}

export interface Cod9 {
    oficial: string
    motivo: string
    fecha: string
}

export interface PRegistro {
    identificador: string
    oficial: string
    detalles: string
    fecha: string
    multas: Multa[]
    atenuante: number
    pagada: boolean
}

export interface Multa {
    nombre: string
    dinero: number
    carcel: number
    cantidad: number
}
// -- --