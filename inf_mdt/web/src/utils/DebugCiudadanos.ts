import {Ciudadano} from "../api/Ciudadano";

export const debugCiudadanos: Ciudadano[] = [
    {
        identificador: '15765X',
        nombre: 'Floyd',
        apellidos: 'Parker',
        telefono: '626847315',
        nacimiento: '23/04/1999',
        coches: [
            {
                nombre: 'Tempesta',
                matricula: 'XXX 000'
            }
        ],
        propiedades: [],
        delictivo: {
            peligroso: true,
            notas: 'El sujeto tiene que pagar multas',
            registros: [
                {
                    oficial: 'Ronald Dacey',
                    fecha: '26/05/2022 17:30',
                    atenuante: 0,
                    detalles: 'Prueba de Multa',
                    identificador: 'XXX-000',
                    pagada: false,
                    multas: [
                        {
                            nombre: 'Art. 0 - Prueba',
                            cantidad: 1,
                            carcel: 150,
                            dinero: 1000,
                        }
                    ]
                }
            ]
        }
    },
    {
        identificador: '15764X',
        nombre: 'Kelsier',
        apellidos: 'Damora',
        telefono: '626947320',
        nacimiento: '23/04/1999',
        coches: [
            {
                nombre: 'Tempesta',
                matricula: 'XXX 000'
            },
            {
                nombre: 'Tempesta',
                matricula: 'XXX 001'
            }
        ],
        propiedades: [
            {
                direccion: 'Apartamento 4',
                calle: 'Mission Row'
            }
        ],
        delictivo: {
            peligroso: true,
            cod9: {
                oficial: 'Ronald Dacey',
                fecha: '28/05/2022 01:00',
                motivo: 'El sujeto se ha dado a la fuga tras un 10.06'
            },
            notas: 'El sujeto tiene que pagar multas',
            registros: [
                {
                    oficial: 'Ronald Dacey',
                    fecha: '26/05/2022 17:30',
                    atenuante: 0,
                    detalles: 'Prueba de Multa',
                    identificador: 'XXX-000',
                    pagada: false,
                    multas: [
                        {
                            nombre: 'Art. 0 - Prueba',
                            cantidad: 1,
                            carcel: 150,
                            dinero: 1000,
                        }
                    ]
                },
                {
                    oficial: 'Ronald Dacey',
                    fecha: '26/05/2022 17:30',
                    atenuante: 0,
                    detalles: 'Prueba de Multa',
                    identificador: 'XXX-001',
                    pagada: true,
                    multas: [
                        {
                            nombre: 'Art. 0 - Prueba',
                            cantidad: 1,
                            carcel: 150,
                            dinero: 1000,
                        }
                    ]
                }
            ]
        }
    }
]