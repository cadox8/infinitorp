import React from "react";
import {Screens} from "../../api/Screens";
import MainScreen from "./MainScreen";
import CiudadanoPolicia from "./ciudadano/CiudadanoPolicia";
import PCiudadanos from "./policia/PCiudadanos";
import {useData} from "../../providers/DataProvider";
import AñadirRegistroPolicial from "./ciudadano/policia/AñadirRegistroPolicial";
import {generateIDRegistro} from "../../utils/misc";
import PCoches from "./policia/PCoches";
import PCod9 from "./policia/PCod9";

const Screen: React.FC = () => {
    const data = useData();

    const render = (): any => {
        switch (data.screen) {
            case Screens.MAIN:
                return <MainScreen/>

            // -- Policia --
            case Screens.POLICIA_CIUDADANOS:
                return <PCiudadanos/>
            case Screens.POLICIA_CIUDADANO:
                return <CiudadanoPolicia/>
            case Screens.POLICIA_REGISTRO:
                return <AñadirRegistroPolicial id={generateIDRegistro()}/>
            case Screens.POLICIA_VEHICULOS:
                return <PCoches/>
            case Screens.POLICIA_COD9:
                return <PCod9/>
            // -- --
            default:
                return <MainScreen/>
        }
    }

    return (
        <>
            { render() }
            <footer className="footer has-background-dark"/>
        </>
    )
}

export default Screen;