import {Server} from "qbcore.js";
import {IProfile} from "@typings/IProfile";
import {BaseModule} from "./BaseModule";
import {Logger} from "winston";
import IConfig from "../../typings/IConfig";
import {Pool} from "mysql2";

export default class Profiles extends BaseModule {

    constructor(database: Pool, logger: Logger, qbcore: Server, config: IConfig) {
        super('Profiles', database, logger.child({module: 'Profiles'}), qbcore, config)

    }

    public getProfiles(): IProfile[] | boolean {
        try {
            const profiles: IProfile[] = [];

            this.database.query('SELECT * FROM mdt_profiles', (err, rows, fields) => {

            });

            return profiles;
        } catch (err) {
            this.logger.error(err);
            return false;
        }
    }

    public async getProfile(id: number): Promise<IProfile> {
        return (await this.database.manager.findOneBy(Profile, {id: id})) as IProfile
    }

    public createProfile(profile: IProfile): IProfile | boolean {
        try {
            this.database.execute(`INSERT INTO mdt_profile VALUES (${profile.id})`);
            return profile;
        } catch (err) {
            this.logger.error(err);
            return false;
        }
    }
}
