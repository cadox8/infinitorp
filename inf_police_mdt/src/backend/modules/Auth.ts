import {Player, Server} from "qbcore.js";
import Event from "@/decorators/event";
import {Logger} from "winston";
import {BaseModule} from "./BaseModule";
import IConfig from "../../typings/IConfig";
import {Pool} from "mysql2";

export interface IAuthedUser {
    src: number;
    cid: number;
    callsign: string;
    state: boolean; // true = on duty, false = off duty
}

export default class Auth extends BaseModule {

    public authorizedClients: IAuthedUser[];

    constructor(database: Pool, logger: Logger, qbcore: Server, config: IConfig) {
        super('Auth', database, logger.child({module: 'Auth'}), qbcore, config)

        this.authorizedClients = [];

        Event(false, "QBCore:Server:PlayerLoaded", this.loadClient.bind(this));
        Event(false, "QBCore:Server:OnPlayerUnload", this.playerDropped.bind(this));
        Event(true, "playerDropped", this.playerDropped.bind(this));

        this.qbcore.Players.forEach((player) => this.loadClient(player));
    }

    async isAuthorized(src: number): Promise<boolean> {
        return this.authorizedClients.some((client) => client.src === src);
    }

    public loadClient(player: Player): void {
        // @ts-ignore
        if (this.config.auth.allowed_job_types.includes(player.PlayerData.job.name.toLowerCase())) {
            this.authorizedClients.push({
                src: player.PlayerData.source,
                cid: player.PlayerData.cid,
                callsign: player.PlayerData.metadata.callsign,
                state: player.PlayerData.job.onduty,
            })

            this.logger.info(`Loaded client ${player.PlayerData.source} as ${player.PlayerData.metadata.callsign}`);
        } else {
            this.logger.info(`Client ${player.PlayerData.source} is not authorized`);
        }
    }

    public unloadClient(source: string) {
        this.logger.info("Unloading client " + source);
        this.authorizedClients = this.authorizedClients.filter((client) => client.src !== parseInt(source));
    }

    playerDropped(reason: string) {
        this.unloadClient(String(global.source))
    }
}

