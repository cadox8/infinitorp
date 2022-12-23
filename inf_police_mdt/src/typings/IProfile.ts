import {IReport} from "./IReport";

export interface IProfile {
    id?: number;
    citizenid: number;
    notes: string;
    mugshot_url: string;
    reports: Partial<IReport>[];
}
