import {IProfile} from "./IProfile";
import {IPhoto} from "./IPhoto";
import {ISuspect} from "./ISuspect";

export const EReportTypes = [
    "Traffic Report",
    "Crime Report",
    "Administrative Report",
];

export interface IReport {
    id?: number;
    title: string;
    type: string;
    report: string;
    aOfficer: IProfile;
    officers: IProfile[];
    suspects: ISuspect[];
    photos: IPhoto[];
    timestamp: string;
}
