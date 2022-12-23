import {Server} from "qbcore.js";
import {IReport} from "@typings/IReport";
import {BaseModule} from "./BaseModule";
import {Logger} from "winston";
import {IProfile} from "../../typings/IProfile";
import {IPhoto} from "../../typings/IPhoto";
import {ISuspect} from "../../typings/ISuspect";
import IConfig from "../../typings/IConfig";
import {Pool} from "mysql2";

export default class Reports extends BaseModule {

    constructor(database: Pool, logger: Logger, qbcore: Server, config: IConfig) {
        super('Reports', database, logger.child({module: 'Reports'}), qbcore, config)
    }

    public async getReports(): Promise<IReport[] | boolean> {
        try {
            const report: Report[] = await this.database.manager.find(Report);
            const resReport: IReport[] = [];

            report.forEach((r) => resReport.push({
                report: r.report,
                id: r.id,
                aOfficer: r.aOfficer as IProfile,
                officers: r.officers as IProfile[],
                photos: r.photos as IPhoto[],
                suspects: r.suspects as ISuspect[],
                timestamp: r.timestamp,
                title: r.title,
                type: r.type
            }));


            return resReport;
        } catch (err) {
            this.logger.error(err);
            return false;
        }
    }

    public async getReport(id: number): Promise<IReport> {
        return {} as IReport;
    }

    public async createReport(report: Report): Promise<Report | boolean> {
        try {
            let _report = new Report();
            _report.title = report.title;
            _report.type = report.type;
            _report.report = report.report;
            _report.aOfficer = report.aOfficer;
            _report.officers = report.officers;
            _report.suspects = report.suspects;
            _report.photos = report.photos;
            _report.timestamp = report.timestamp;

            return await this.database.manager.save(_report);
        } catch (err) {
            this.logger.error(err);
            return false;
        }
    }
}
