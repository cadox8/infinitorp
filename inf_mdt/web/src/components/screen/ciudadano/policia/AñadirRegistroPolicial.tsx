import React, {useEffect, useState} from "react";
import {useData} from "../../../../providers/DataProvider";
import {Ciudadano, Multa} from "../../../../api/Ciudadano";
import Nav from "../../nav/Nav";
import CiudadanoProvider from "../../../../providers/CiudadanoProvider";
import {Screens} from "../../../../api/Screens";
import {DataArt, DataMultas} from "../../../../api/Data";

const AñadirRegistroPolicial: React.FC<{ id: string }> = ({ id }) => {
    const data = useData()

    const loadArt: DataArt[] = require('../../../../data/multas.json').art;
    const loadMultas: DataMultas[] = require('../../../../data/multas.json').multas;

    // -- Use State
    const [multasLista, setMultasLista] = useState<DataMultas[]>([]);
    // -- --

    useEffect(() => setMultasLista([]), [])

    const calculateSancion = (): number => {
        let amount: number = 0;
        multasLista.forEach(m => amount += (m.sancion * m.cantidad));
        return amount;
    }
    const calculateCarcel = (): number => {
        let amount: number = 0;
        multasLista.forEach(m => amount += m.carcel);
        return amount;
    }

    const addMulta = (multa: DataMultas): void => {
        const dataNew: DataMultas[] = [...multasLista];
        if (multasLista.includes(multa)) {
            const index: number = multasLista.findIndex(m => m.nombre === multa.nombre);
            dataNew[index].cantidad++;
        } else {
            multa.cantidad = 1
            dataNew.push(multa)
        }
        setMultasLista(dataNew)
    }

    const borrarMulta = (multa: DataMultas): void => {
        const dataNew: DataMultas[] = [...multasLista];
        const index: number = multasLista.findIndex(m => m.nombre === multa.nombre);
        dataNew.splice(index, 1);
        setMultasLista(dataNew)
    }

    return (
        <>
            <Nav screen={Screens.POLICIA_CIUDADANO}/>
            <section className={'section has-background-dark has-text-white'}>
                <div className={'container'}>
                   <div className={'box'}>
                       <div className="field is-horizontal">
                           <div className="field-label is-normal">
                               <label className="label">Identificador</label>
                           </div>
                           <div className="field-body">
                               <div className="field">
                                   <p className="control">
                                       <input className="input is-static" type='text' value={id} readOnly={true}/>
                                   </p>
                               </div>
                           </div>
                       </div>
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
                               <label className="label">Descripción</label>
                           </div>
                           <div className="field-body">
                               <div className="field">
                                   <p className="control">
                                       <textarea className="textarea has-fixed-size" required={true} placeholder='Descripción de los hechos [Completa y detallada]'></textarea>
                                   </p>
                               </div>
                           </div>
                       </div>
                       <div className="field is-horizontal">
                           <div className="field-label is-normal">
                               <label className="label">Sanción</label>
                           </div>
                           <div className="field-body">
                               <div className="field">
                                   <p className="control">
                                       <input className="input is-static" type='text' value={'$' + calculateSancion()} readOnly={true}/>
                                   </p>
                               </div>
                           </div>
                       </div>
                       <div className="field is-horizontal">
                           <div className="field-label is-normal">
                               <label className="label">Carcel</label>
                           </div>
                           <div className="field-body">
                               <div className="field">
                                   <p className="control">
                                       <input className="input is-static" type='text' value={calculateCarcel() + ' meses'} readOnly={true}/>
                                   </p>
                               </div>
                           </div>
                       </div>
                       <div className={'columns'}>
                           <div className={'column'}>
                               <div className="field">
                                   <div className="control">
                                       <nav className="panel is-link">
                                           <p className="panel-heading">Lista de Multas</p>
                                           <div className="panel-block">
                                               <p className="control has-icons-left">
                                                   <input className="input" type="text" placeholder="Buscar"/>
                                                   <span className="icon is-left">
                                               <i className="fas fa-search" aria-hidden="true"></i>
                                           </span>
                                               </p>
                                           </div>
                                           <p className="panel-tabs">
                                               {
                                                   loadArt.map(a => <a key={a.id}>{a.nombre}</a>)
                                               }
                                           </p>
                                           {
                                               loadMultas.map(m => <a key={m.nombre} onClick={() => addMulta(m)} className="panel-block">
                                       <span className="panel-icon">
                                           <i className={'fa-solid ' + loadArt.find(a => a.id === m.art)?.icon} aria-hidden="true"></i>
                                       </span>
                                                   <span>{m.nombre}</span>
                                                   <div className={'tag is-info mx-2'}>${m.sancion}</div>
                                                   <div className={'tag is-danger'}>{m.carcel} meses</div>
                                               </a>)
                                           }
                                       </nav>
                                   </div>
                               </div>
                           </div>
                           <div className={'column'}>
                               <nav className="panel is-link">
                                   <p className="panel-heading">Multas</p>
                                   {
                                       multasLista.map(m => <a key={m.nombre} onClick={() => borrarMulta(m)} className="panel-block">
                                       <span className="panel-icon">
                                           <i className={'fa-solid ' + loadArt.find(a => a.id === m.art)?.icon} aria-hidden="true"></i>
                                       </span>
                                           <span>{m.nombre} x{m.cantidad || 1}</span>
                                           <div className={'tag is-info mx-2'}>${m.sancion * (m.cantidad || 1)}</div>
                                           <div className={'tag is-danger'}>{m.carcel} meses</div>
                                       </a>)
                                   }
                               </nav>
                           </div>
                       </div>
                       <div className="field is-grouped is-grouped-right">
                           <p className="control">
                               <a className="button is-primary">Añadir Registro</a>
                           </p>
                           <p className="control">
                               <a onClick={() => data.setScreen(Screens.POLICIA_CIUDADANO)} className="button is-light">
                                   Cancelar
                               </a>
                           </p>
                       </div>
                   </div>
                </div>
            </section>
        </>
    );
}

export default AñadirRegistroPolicial