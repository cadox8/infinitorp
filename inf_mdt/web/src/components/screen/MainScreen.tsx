import React from "react";
import Aplicaciones from "../aplicaciones/Aplicaciones";
import {useData} from "../../providers/DataProvider";

const MainScreen: React.FC = () => {
    const data = useData()

    return (
        <>
            <Aplicaciones user={data.user}/>
            <section className={'hero is-dark is-large'}>
                <div className={'hero-body'}>
                    <div className={'has-text-centered'}>
                        <figure className={'image is-inline-block'}>
                            <img className={'is-rounded'} src={'/web/build/img/inf.jpg'}/>
                        </figure>
                    </div>
                </div>
            </section>
        </>
    )
}

export default MainScreen;