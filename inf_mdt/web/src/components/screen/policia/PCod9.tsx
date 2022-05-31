import React, {useEffect} from "react";
import {fetchNui} from "../../../utils/fetchNui";
import {Ciudadano, Coche} from "../../../api/Ciudadano";
import {Screens} from "../../../api/Screens";
import {debugCiudadanos} from "../../../utils/DebugCiudadanos";
import {useData} from "../../../providers/DataProvider";
import {getTime, parseDate} from "../../../utils/misc";

const PCod9: React.FC = () => {
    const data = useData()

    fetchNui<Ciudadano[]>('loadPlayers', {}, debugCiudadanos).then(players => data.setCiudadanos(players))

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
                                        <strong>{ciudadano.nombre + ' ' + ciudadano.apellidos}</strong>
                                        <br/>
                                        <small>{ciudadano.identificador}</small>
                                        <br/>
                                        <div className={'notification is-warning is-light'}>
                                            <strong>[COD. 9] </strong>
                                            {ciudadano.delictivo.cod9?.motivo}
                                            <br/>
                                            <small>
                                                <strong>Oficial: {ciudadano.delictivo.cod9?.oficial}</strong>
                                                <br/>
                                                Puesta: {ciudadano.delictivo.cod9?.fecha} -
                                                Finaliza: {getTime(parseDate(ciudadano.delictivo.cod9?.fecha, true), 1)}
                                            </small>
                                        </div>
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
                    </div>
                </div>
            </section>
            <section className={'section is-large has-background-black-ter'}>
                <div className={'container is-fluid'}>
                    <div className={'columns is-multiline'}>
                        { data.ciudadanos.map(c => parseCiudadano(c)) }
                    </div>
                </div>
            </section>
        </>
    )
}

export default PCod9;