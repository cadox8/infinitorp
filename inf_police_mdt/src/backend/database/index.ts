import {createPool, Pool} from "mysql2";
import IConfig from "../../typings/IConfig";

export default function startDatabase(config: IConfig): Pool {
    return createPool({
        host: config.mysql.host,
        port: config.mysql.port,
        user: config.mysql.username,
        password: config.mysql.password,
        database: config.mysql.database,
        waitForConnections: true,
        connectionLimit: 10,
        queueLimit: 0
    });
}