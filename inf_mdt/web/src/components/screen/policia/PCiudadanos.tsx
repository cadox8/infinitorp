import React, {useEffect} from "react";
import {fetchNui} from "../../../utils/fetchNui";
import {Ciudadano} from "../../../api/Ciudadano";
import {Screens} from "../../../api/Screens";
import {debugCiudadanos} from "../../../utils/DebugCiudadanos";
import {useData} from "../../../providers/DataProvider";

const PCiudadanos: React.FC = () => {
    const data = useData()

    fetchNui<Ciudadano[]>('loadPlayers', {}, debugCiudadanos).then(players => data.setCiudadanos(players))

    useEffect(() => search(), [data.ciudadanos])

    const search = (): void => {
        const result: JSX.Element[] = [];

        if (data.nombre) {
            let c: Ciudadano[] = data.ciudadanos.filter(c => c.nombre.search(data.nombre) !== -1);
            if (data.apellido) c = c.filter(ci => ci.apellidos.search(data.apellido) !== -1);
            c.forEach(ci => result.push(parseCiudadano(ci)))
        } else if (data.apellido) {
            data.ciudadanos.filter(ci => ci.apellidos.search(data.apellido) !== -1).forEach(c => result.push(parseCiudadano(c)))
        } else if (data.identificador) {
            data.ciudadanos.filter(ci => ci.identificador.search(data.identificador) !== -1).forEach(c => result.push(parseCiudadano(c)))
        } else {
            data.ciudadanos.forEach(c => result.push(parseCiudadano(c)))
        }
        data.setCiudadanosData(result);
    }

    const parseCiudadano = (ciudadano: Ciudadano): JSX.Element => {
        return (
            <div className={'column is-3'} key={ciudadano.identificador}>
                <a onClick={() => {
                    data.setScreen(Screens.POLICIA_CIUDADANO)
                    data.setCiudadano(ciudadano.identificador)
                }}>
                    <div className={'box has-background-light'}>
                        <article className="media">
                            <div className="media-left">
                                <figure className="image is-64x64 is-rounded">
                                    <img src={ciudadano.imagen || '/web/build/img/user.png'} alt={ciudadano.nombre}/>
                                </figure>
                            </div>
                            <div className="media-content">
                                <div className="content">
                                    <div>
                                        <strong>{ ciudadano.nombre + ' ' + ciudadano.apellidos }</strong>
                                        <br/>
                                        <small>{ ciudadano.identificador }</small>
                                        <br/>
                                        { ciudadano.delictivo.peligroso ? <div className={'tag is-danger mr-2'}>Peligroso</div> : null }
                                        { ciudadano.delictivo.cod9 ? <div className={'tag is-warning'}>COD. 9</div> : null }
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
                        <div className={'field'}>
                            <p className="control is-expanded">
                                <input className="input" id={'nombre'} type="text" placeholder="Nombre" onChange={(e) => data.setNombre(e.target.value)}/>
                            </p>
                            <p className="help">Nombre</p>
                        </div>
                        <div className={'field mx-5'}>
                            <p className="control is-expanded">
                                <input className="input" id={'apellidos'} type="text" placeholder="Apellidos" onChange={(e) => data.setApellido(e.target.value)}/>
                            </p>
                            <p className="help">Apellidos</p>
                        </div>
                        <div className={'field mr-5'}>
                            <p className="control is-expanded">
                                <input className="input" id={'identificador'} type="text" placeholder="Identificador" onChange={(e) => data.setIdentificador(e.target.value)}/>
                            </p>
                            <p className="help">Identificador</p>
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
                        { data.ciudadanosData }
                    </div>
                </div>
            </section>
        </>
    )
}

export default PCiudadanos;