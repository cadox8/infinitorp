import React from "react";
import {Screens} from "../../api/Screens";
import {useData} from "../../providers/DataProvider";

const AplicacionesPolicia: React.FC = () => {
    const data = useData();

    return (
        <div className="columns is-variable is-8">
            <div className="column has-text-centered">
                <a className={'button is-large is-info'} onClick={() => data.setScreen(Screens.POLICIA_CIUDADANOS)}>
                    <span className="icon">
                        <i className="fa-solid fa-users fa-lg"></i>
                    </span>
                </a>
                <p>Ciudadanos</p>
            </div>
            <div className="column has-text-centered">
                <a className={'button is-large is-info'} onClick={() => data.setScreen(Screens.POLICIA_VEHICULOS)}>
                    <span className="icon">
                        <i className="fa-solid fa-car-rear fa-lg"></i>
                    </span>
                </a>
                <p>Vehiculos</p>
            </div>
            <div className="column has-text-centered">
                <a className={'button is-large is-info'} onClick={() => data.setScreen(Screens.POLICIA_COD9)}>
                    <span className="icon">
                        <i className="fa-solid fa-handcuffs fa-lg"></i>
                    </span>
                </a>
                <p>COD. 9</p>
            </div>
            <div className="column has-text-centered">
                <a className={'button is-large is-info'} onClick={() => data.setScreen(Screens.POLICIA_DOCS)}>
                    <span className="icon">
                        <i className="fa-solid fa-clipboard fa-lg"></i>
                    </span>
                </a>
                <p>Documentación</p>
            </div>
            <div className="column has-text-centered">
                <a className={'button is-large is-info'} onClick={() => data.setScreen(Screens.POLICIA_GESTION)}>
                    <span className="icon">
                        <i className="fa-solid fa-user-shield fa-lg"></i>
                    </span>
                </a>
                <p>Gestión</p>
            </div>
        </div>
    )
}

export default AplicacionesPolicia;