import React, {useState} from "react";
import {useData} from "../../../providers/DataProvider";
import {Ciudadano, Multa} from "../../../api/Ciudadano";
import Nav from "../nav/Nav";
import {getAge, getTime, parseDate} from "../../../utils/misc";
import {RangoPolicia} from "../../../api/User";
import {Screens} from "../../../api/Screens";
import CiudadanoProvider from "../../../providers/CiudadanoProvider";
import moment from "moment/moment";

const CiudadanoPolicia: React.FC = () => {
    const data = useData()
    const ciudadanoProvider = CiudadanoProvider();
    // -- --

    const [editC9, setEditC9] = useState<boolean>(false)
    const [modal, setModal] = useState<boolean>(false)
    const [cod9Motivo, setCod9Motivo] = useState<string>('')

    const [photo, setPhoto] = useState<string>('/web/build/img/user_large.png')
    const [modalPhoto, setModalPhoto] = useState<boolean>(false)

    let ciudadano: Ciudadano = data.ciudadanos.find(c => c.identificador == data.ciudadano) as Ciudadano;

    // -- Métodos --
    const cambiarPeligroso = (): void => {
        ciudadano.delictivo.peligroso = !ciudadano.delictivo.peligroso
        _updateCiudadano(ciudadano);
    }

    const cambiarNota = (value: string): void => {
        ciudadano.delictivo.notas = value === '' ? ' ' : value;
    }

    const borrarC9 = (): void => {
        ciudadano.delictivo.cod9 = undefined;
        setCod9Motivo('')
        _updateCiudadano(ciudadano)
    }

    const borrarRegistro = (identificador: string): void => {
        const index: number = ciudadano.delictivo.registros.findIndex(r => r.identificador === identificador);
        ciudadano.delictivo.registros.splice(index, 1);
        ciudadanoProvider.borrarRegistro(identificador)
        _updateCiudadano(ciudadano)
    }

    const _updateCiudadano = (c: Ciudadano): void => {
        const ciudadanosNew: Ciudadano[] = [...data.ciudadanos];
        const index: number = ciudadanosNew.findIndex(m => m.identificador === c?.identificador);
        ciudadanosNew[index] = c
        data.setCiudadanos(ciudadanosNew)
    }
    // -- --

    const vehiculos = (): JSX.Element[] => {
        const vehiculos: JSX.Element[] = []

        ciudadano.coches.forEach(c => {
            vehiculos.push( <div key={c.matricula} style={{ width: '200px' }} className={'box has-background-grey-lighter mx-2 my-0'}>
                <article className="media">
                    <div className="media-content">
                        <div className="content">
                            <div>
                                <strong>{ c.nombre }</strong>
                                <br/>
                                <small>{ c.matricula }</small>
                            </div>
                        </div>
                    </div>
                </article>
            </div>)
        })
        return vehiculos
    }
    const propiedades = (): JSX.Element[] => {
        const propiedades: JSX.Element[] = []

        ciudadano.propiedades.forEach(c => {
            propiedades.push( <div key={`${c.calle} ${c.direccion} ${ciudadano.identificador}`} style={{ width: '200px' }} className={'box has-background-grey-lighter mx-2 my-0'}>
                <article className="media">
                    <div className="media-content">
                        <div className="content">
                            <div>
                                <strong>{ c.direccion }</strong>
                                <br/>
                                <small>{ c.calle }</small>
                            </div>
                        </div>
                    </div>
                </article>
            </div>)
        })
        return propiedades
    }
    const multas = (pagadas: boolean = false): JSX.Element[] => {
        const multas: JSX.Element[] = []

        ciudadano.delictivo.registros.filter(m => m.pagada === pagadas).forEach(r => {
            multas.push(
                <article key={r.identificador} className="message is-dark mx-2">
                    <div className="message-header">
                        <p>Registo {r.identificador}</p>
                        { (data.user?.rango || 0 >= RangoPolicia.SUBCOMISARIO) && <button onClick={() => borrarRegistro(r.identificador)} className="delete ml-1"></button> }
                    </div>
                    <div className="message-body">
                        <table className={'table is-striped is-fullwidth'}>
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Dinero</th>
                                    <th>Carcel</th>
                                </tr>
                            </thead>
                            <tbody>
                            { r.multas.map((m, i) => (
                                <tr key={`${m.nombre}${i}`}>
                                    <td>{m.nombre} x{m.cantidad}</td>
                                    <td>${(m.dinero * m.cantidad)}</td>
                                    <td>{(m.carcel * m.cantidad)} meses</td>
                                </tr>
                            )) }
                            </tbody>
                        </table>
                    </div>
                </article>
            )
        })
        return multas
    }

    return (
        <>
            <Nav screen={Screens.POLICIA_CIUDADANOS}/>

            <div className={'modal ' + (modalPhoto ? 'is-active' : null)}>
                <div className="modal-background"></div>
                    <div className="modal-card">
                        <header className="modal-card-head">
                            <p className="modal-card-title">Actualizar foto para {ciudadano.nombre} {ciudadano.apellidos}</p>
                        </header>
                        <section className="modal-card-body">
                            <div className="field">
                                <p className="control">
                                    <input onChange={e => setPhoto(e.target.value)} className="input" required={true} type='url' defaultValue={''} placeholder={'https://i.gyazo.com/c95e64c35a753f08baadd05da016e3f5.png'}/>
                                </p>
                            </div>
                        </section>
                        <footer className="modal-card-foot">
                            <button onClick={() => {
                                ciudadano.imagen = photo === '' ? undefined : photo;
                                setModalPhoto(false)
                                _updateCiudadano(ciudadano)
                            }} className="button is-warning">Actualizar Foto</button>
                            <button onClick={() => { setModalPhoto(false); setPhoto('/web/build/img/user_large.png') }} className="button">Cancelar</button>
                        </footer>
                    </div>
                </div>

            <div className={'modal ' + (modal ? 'is-active' : null)}>
                <div className="modal-background"></div>
                <div className="modal-card">
                    <header className="modal-card-head">
                        <p className="modal-card-title">COD. 9 para {ciudadano.nombre} {ciudadano.apellidos}</p>
                        <button onClick={() => { setModal(false); setCod9Motivo('') }} className="delete" aria-label="close"></button>
                    </header>
                    <section className="modal-card-body">
                        <div className="field is-horizontal">
                            <div className="field-label is-normal">
                                <label className="label">Oficial</label>
                            </div>
                            <div className="field-body">
                                <div className="field">
                                    <p className="control">
                                        <input className="input is-static" type='text' value={data.user?.nombre} readOnly={true}/>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div className="field is-horizontal">
                            <div className="field-label is-normal">
                                <label className="label">Inicio</label>
                            </div>
                            <div className="field-body">
                                <div className="field">
                                    <p className="control">
                                        <input className="input is-static" type='text' value={moment().format('DD/MM/YYYY HH:mm')} readOnly={true}/>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div className="field is-horizontal">
                            <div className="field-label is-normal">
                                <label className="label">Fin</label>
                            </div>
                            <div className="field-body">
                                <div className="field">
                                    <p className="control">
                                        <input className="input is-static" type='text' value={moment().add(1, 'd').format('DD/MM/YYYY HH:mm')} readOnly={true}/>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div className="field is-horizontal">
                            <div className="field-label is-normal">
                                <label className="label">Motivo</label>
                            </div>
                            <div className="field-body">
                                <div className="field">
                                    <p className="control">
                                        <textarea onChange={e => setCod9Motivo(e.target.value)} value={cod9Motivo} className="textarea has-fixed-size" required={true} placeholder='Descripción del motivo [Completa y detallada]'></textarea>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </section>
                    <footer className="modal-card-foot">
                        <button onClick={() => {
                            ciudadano.delictivo.cod9 = {
                                oficial: data.user?.nombre || '',
                                fecha: moment().format('DD/MM/YYYY HH:mm'),
                                motivo: cod9Motivo
                            }
                            setModal(false)
                        }} className="button is-warning">Poner en COD. 9</button>
                        <button onClick={() => { setModal(false); setCod9Motivo('') }} className="button">Cancelar</button>
                    </footer>
                </div>
            </div>

            <section className={'section has-background-dark has-text-white'}>
                <div className={'container is-fluid'}>
                    <div className={'columns'}>
                        <div className={'column is-narrow'}>
                            <div className={'box has-background-grey-light'} onClick={() => setModalPhoto(true)}>
                                <figure className={'image is-128x128 is-rounded is-clickable'}>
                                    <img src={ciudadano.imagen || '/web/build/img/user_large.png'} alt={ciudadano.nombre}/>
                                </figure>
                            </div>

                            { !ciudadano.delictivo.cod9 ? <button onClick={() => setModal(true)} className={'button is-fullwidth is-warning mb-1'}>Poner en COD. 9</button> : null }
                            { ciudadano.delictivo.peligroso ? <button onClick={() => cambiarPeligroso()} className={'button is-fullwidth is-success mb-1'}>No peligroso</button> : <button onClick={() => cambiarPeligroso()} className={'button is-fullwidth is-danger mb-1'}>Peligroso</button> }
                            <button onClick={() => data.setScreen(Screens.POLICIA_REGISTRO)} className={'button is-fullwidth is-info'}>Añadir Registro</button>
                        </div>
                        <div className={'column'}>
                            <div className={`box ${ciudadano.delictivo.peligroso ? 'has-background-danger' : (ciudadano.delictivo.cod9 ? 'has-background-warning' : 'has-background-grey-light')}`}>
                                <h1 className={'title has-text-black'}>{ ciudadano.nombre + ' ' + ciudadano.apellidos }</h1>
                                <h2 className={'subtitle has-text-black mb-2'}>{ ciudadano.identificador }</h2>
                                <hr className={'has-background-black my-1'}/>
                                <h2 className={'has-text-black'}>Teléfono: { ciudadano.identificador } - Fecha nacimiento { ciudadano.nacimiento } ({getAge(parseDate(ciudadano.nacimiento))} años)</h2>
                            </div>
                            { ciudadano.delictivo.cod9 && <div className={'notification is-warning is-light'}>
                                <button className="delete" onClick={() => borrarC9()}></button>
                                <strong>[COD. 9] </strong>
                                {ciudadano.delictivo.cod9.motivo}
                                <br/>
                                <small>
                                    <strong>Oficial: {ciudadano.delictivo.cod9.oficial}</strong>
                                    <br/>
                                    Puesta: {ciudadano.delictivo.cod9.fecha} - Finaliza: {getTime(parseDate(ciudadano.delictivo.cod9.fecha, true), 1)}
                                </small>
                            </div> }

                            { ciudadano.delictivo.notas && <div className={'notification is-link is-light'}>

                                { !editC9 && <span className="icon-text">
                                  <span>{ciudadano.delictivo.notas}</span>
                                  <span onClick={() => setEditC9(!editC9)} className="icon is-clickable">
                                    <i className="fa-solid fa-pen-to-square"/>
                                  </span>
                                </span> }

                                { editC9 &&
                                    <>
                                        <div className={'field'}>
                                            <div className="control">
                                                <textarea onChange={e => cambiarNota(e.target.value)} className="textarea has-fixed-size">{ciudadano.delictivo.notas}</textarea>
                                            </div>
                                        </div>
                                        <div className="field is-grouped is-grouped-right">
                                            <p className="control">
                                                <a onClick={() => {
                                                    setEditC9(false)
                                                    _updateCiudadano(ciudadano)
                                                }} className="button is-primary">Guardar Nota</a>
                                            </p>
                                        </div>
                                    </>
                                }

                            </div> }

                            <div className={'columns'}>
                                <div className={'column'}>
                                    <article className="message">
                                        <div className="message-header">
                                            <p>Vehículos</p>
                                        </div>
                                        <div className="message-body is-flex ">
                                            { vehiculos() }
                                        </div>
                                    </article>
                                </div>
                                <div className={'column'}>
                                    <article className="message">
                                        <div className="message-header">
                                            <p>Propiedades</p>
                                        </div>
                                        <div className="message-body is-flex ">
                                            { propiedades() }
                                        </div>
                                    </article>
                                </div>
                            </div>

                            <div className={'columns'}>
                                <div className={'column'}>
                                    <article className="message is-danger">
                                        <div className="message-header">
                                            <p>Multas impagadas</p>
                                        </div>
                                        <div className="message-body ">
                                            { multas(false) }
                                        </div>
                                    </article>
                                </div>
                                <div className={'column'}>
                                    <article className="message is-success">
                                        <div className="message-header">
                                            <p>Multas pagadas</p>
                                        </div>
                                        <div className="message-body ">
                                            { multas(true) }
                                        </div>
                                    </article>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </>
    );
}

export default CiudadanoPolicia