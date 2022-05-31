import React from "react";
import {Trabajo, User} from "../../api/User";
import AplicacionesPolicia from "./AplicacionesPolicia";

const Aplicaciones: React.FC<{ user: User | null }> = ({ user }) => {

    const noApps = (): JSX.Element => <div className={'notification is-danger is-light'}>No hay aplicaciones para ti!</div>

    const loadApps = (): JSX.Element => {
        if (!user) return noApps();

        switch (user.trabajo) {
            case Trabajo.POLICIA:
                return <AplicacionesPolicia/>

            default:
                return noApps();
        }
    }

    return (
        <section className={'section hero is-dark'}>
            <div className={'container'}>
                { loadApps() }
            </div>
        </section>
    )
}

export default Aplicaciones;