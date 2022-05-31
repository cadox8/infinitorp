import React, {useEffect} from "react";
import {fetchNui} from "../../../utils/fetchNui";
import {Ciudadano, Coche} from "../../../api/Ciudadano";
import {Screens} from "../../../api/Screens";
import {debugCiudadanos} from "../../../utils/DebugCiudadanos";
import {useData} from "../../../providers/DataProvider";

const PCoches: React.FC = () => {
    const data = useData()

    fetchNui<Ciudadano[]>('loadPlayers', {}, debugCiudadanos).then(players => data.setCiudadanos(players))

    useEffect(() => search(), [data.ciudadanos])

    const search = (): void => {
        const result: JSX.Element[] = [];
        const util: { id: string, coche: Coche }[] = [];

        if (data.matricula) {
            data.ciudadanos.forEach(ci => {
                ci.coches.filter(c => c.matricula.search(data.matricula) !== -1).forEach(coche => util.push({ id: ci.identificador, coche: coche }))
            })
            util.forEach(u => {
                const ci: Ciudadano = data.ciudadanos.filter(ci => ci.identificador === u.id)[0];
                result.push(parseCoche(u.id, ci.nombre + ' ' + ci.apellidos, u.coche))
            })
        } else {
            data.ciudadanos.forEach(ci => ci.coches.forEach(coche => result.push(parseCoche(ci.identificador, ci.nombre + ' ' + ci.apellidos, coche))))
        }
        data.setCochesData(result);
    }

    const parseCoche = (identificador: string, owner: string, coche: Coche): JSX.Element => {
        return (
            <div className={'column is-2'} key={coche.matricula + identificador}>
                <a onClick={() => {
                    data.setScreen(Screens.POLICIA_CIUDADANO)
                    data.setCiudadano(identificador)
                }}>
                    <div className={'box has-background-light'}>
                        <article className="media">
                            <div className="media-content">
                                <div className="content">
                                    <div>
                                        <strong>{ coche.nombre }</strong>
                                        <br/>
                                        <small>{ coche.matricula }</small>
                                        <br/>
                                        <small>{ owner }</small>
                                    </div>
                                </div>
                            </div>
                        </article>
                    </div>
                </a>
            </div>
        )
    }

    return (
        <>
            <section className={'section hero is-small is-dark'}>
                <div className={'container'}>
                    <div className="field is-grouped">
                        <div className={'field mr-5'}>
                            <p className="control">
                                <a className="button is-active is-dark" onClick={() => data.setScreen(Screens.MAIN)}>
                                    <span className={'icon'}>
                                        <i className={'fa-solid fa-house-chimney'}/>
                                    </span>
                                </a>
                            </p>
                        </div>
                        <div className={'field  mr-5'}>
                            <p className="control is-expanded">
                                <input className="input" id={'matricula'} type="text" placeholder="XXX 000" onChange={(e) => data.setMatricula(e.target.value)}/>
                            </p>
                            <p className="help">Matrícula</p>
                        </div>
                        <div className={'field'}>
                            <p className="control">
                                <a className="button is-info" onClick={() => search()}>Buscar</a>
                            </p>
                        </div>
                    </div>
                </div>
            </section>
            <section className={'section is-large has-background-black-ter'}>
                <div className={'container is-fluid'}>
                    <div className={'columns is-multiline'}>
                        { data.cochesData }
                    </div>
                </div>
            </section>
        </>
    )
}

export default PCoches;