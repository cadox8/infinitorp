import {Logger} from "winston";
import {Server} from "qbcore.js";
import IConfig from "../../typings/IConfig";
import {Pool} from "mysql2";

export abstract class BaseModule {

    public readonly name: string;
    protected database: Pool;
    protected logger: Logger;
    protected qbcore: Server;
    protected config: IConfig;

    protected constructor(name: string, database: Pool, logger: Logger, qbcore: Server, config: IConfig) {
        this.name = name;
        this.database = database;
        this.logger = logger;
        this.qbcore = qbcore;
        this.config = config;

        this.logger.info(`Module ${this.name} loaded!`)
    }
}