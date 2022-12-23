import "reflect-metadata";

import {Server} from "qbcore.js";
import startDatabase from "./database";
import {logger} from "./logger";
import {BaseModule} from "./modules/BaseModule";
import Auth from "./modules/Auth";
import Profiles from "./modules/Profiles";
import Reports from "./modules/Reports";
import {Pool} from "mysql2";
import IConfig from "../typings/IConfig";
import loadConfig from "../utils/config";

class MDT {
    private readonly database: Pool;
    private readonly qbcore: Server;
    private readonly config: IConfig;
    private readonly modules: BaseModule[];

    constructor() {
        this.config = loadConfig();
        this.database = startDatabase(this.config);

        this.qbcore = global.exports["qb-core"].GetCoreObject() as Server;
        logger.child({module: "Database"}).info("Connected to database");

        this.modules = [];
        this.modules.push(new Auth(this.database, logger, this.qbcore, this.config));
        this.modules.push(new Profiles(this.database, logger, this.qbcore, this.config));
        this.modules.push(new Reports(this.database, logger, this.qbcore, this.config));

        import("./controllers");
    }

    public getModule(name: string): BaseModule | undefined {
        return this.modules.find((module: BaseModule) => module.name === name);
    }
}

export default new MDT();
