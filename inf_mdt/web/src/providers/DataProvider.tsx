import React, {Context, createContext, useContext, useState} from "react";
import {Ciudadano} from "../api/Ciudadano";
import {User} from "../api/User";
import ciudadanoBase from "../components/screen/ciudadano/CiudadanoPolicia";

const DataCtx = createContext<DataProviderValue | null>(null)

interface DataProviderValue {
    user: User | null
    setUser: (user: User) => void

    setScreen: (screen: number) => void
    screen: number

    ciudadanos: Ciudadano[]
    setCiudadanos: (ciudadanos: Ciudadano[]) => void

    ciudadano: string
    setCiudadano: (ciudadano: string) => void

    nombre: string
    setNombre: (nombre: string) => void
    apellido: string
    setApellido: (nombre: string) => void
    identificador: string
    setIdentificador: (identificador: string) => void

    matricula: string
    setMatricula: (matricula: string) => void
    cochesData: JSX.Element[]
    setCochesData: (coches: JSX.Element[]) => void

    ciudadanosData: JSX.Element[]
    setCiudadanosData: (ciudadanosData: JSX.Element[]) => void
}

export const DataProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    // El propio usuario
    const [user, setUser] = useState<User | null>(null)

    // La ID de la pantalla
    const [screen, setScreen] = useState<number>(0);

    // Todos los ciudadanos de la ciudad
    const [ciudadanos, setCiudadanos] = useState<Ciudadano[]>([])

    // El usuario seleccionado
    const [ciudadano, setCiudadano] = useState<string>('');

    // Busqueda (parámetros y resultado)
    const [nombre, setNombre] = useState<string>('')
    const [apellido, setApellido] = useState<string>('')
    const [identificador, setIdentificador] = useState<string>('')
    const [ciudadanosData, setCiudadanosData] = useState<JSX.Element[]>([])

    const [matricula, setMatricula] = useState<string>('')
    const [cochesData, setCochesData] = useState<JSX.Element[]>([])
    //

    return (
        <DataCtx.Provider value={{
            user, setUser,
            screen, setScreen,

            ciudadanos, setCiudadanos,
            ciudadano, setCiudadano,

            nombre, setNombre,
            apellido, setApellido,
            identificador, setIdentificador,
            ciudadanosData, setCiudadanosData,

            matricula, setMatricula,
            cochesData, setCochesData
        }}>
            { children }
        </DataCtx.Provider>
    )
}

export const useData = () => useContext<DataProviderValue>(DataCtx as Context<DataProviderValue>)