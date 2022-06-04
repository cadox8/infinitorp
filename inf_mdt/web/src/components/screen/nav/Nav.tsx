import React from "react";
import {useData} from "../../../providers/DataProvider";
import {Screens} from "../../../api/Screens";

const Nav: React.FC<{screen: Screens}> = ({screen}) => {
    const data = useData();

    return (
        <nav className="navbar is-dark is-spaced" role="navigation" aria-label="main navigation">
            <div id="navbarBasicExample" className="navbar-menu">
                <div className="navbar-start">
                    <div className="navbar-item mx-4">
                        <a className="button is-active is-dark" onClick={() => data.setScreen(Screens.MAIN)}>
                            <span className={'icon'}>
                                <i className={'fa-solid fa-house-chimney'}/>
                            </span>
                        </a>
                    </div>
                    <div className="navbar-item">
                        <a className="button is-active is-dark"  onClick={() => data.setScreen(screen)}>
                            <span className={'icon'}>
                                <i className={'fa-solid fa-arrow-left'}/>
                            </span>
                        </a>
                    </div>
                </div>
            </div>
        </nav>
    )
}

export default Nav;