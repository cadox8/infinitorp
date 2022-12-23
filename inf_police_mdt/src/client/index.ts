import {Client} from "qbcore.js";
import './controllers/ui.controller'

import modules from "./modules"

class MDT {
    protected modules: any;
    protected qbcore: Client;

    constructor() {
        this.qbcore = (global.exports['qb-core'].GetCoreObject() as Client);

        this.modules = modules.map((module: any) => {
            return new module(this.qbcore);
        })
    }

    public getModule(name: string) {
        return this.modules.find((module: any) => module.constructor.name === name);
    }
}

export default new MDT();