import React from 'react';
import {debugData} from "../utils/debugData";
import {useNuiEvent} from "../hooks/useNuiEvent";
import {Trabajo, User} from "../api/User";
import './css/Loader.css'
import screen from "./screen/Screen";
import {useData} from "../providers/DataProvider";
import Screen from "./screen/Screen";

// This will set the NUI to visible if we are
// developing in browser

const u: User = new User('Floyd Parker');
u.trabajo = Trabajo.POLICIA;
u.rango = 4;
debugData([
    {
        action: 'updatePlayer',
        data: u,
    }])
debugData([
    {
        action: 'setVisible',
        data: true,
    }])


const App: React.FC = () => {
    const data = useData();
    useNuiEvent<User>('updatePlayer', (user: User) => data.setUser(user))

    const loader = (): JSX.Element => <div className={'loader-wrapper is-active'}><div className="loader is-loading"></div></div>

    return (
        <>
            { !data.user ? loader() : <Screen/> }
        </>
    );
}

export default App;