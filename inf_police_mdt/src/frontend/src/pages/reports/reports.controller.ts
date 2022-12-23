import {writable, type Writable} from "svelte/store";
import type {IReport} from "$typings/IReport";

export interface IReportResult {
    id: number;
    title: string;
    aOfficer: string;
    timestamp: string;
}

export default class ReportsController {
    public static searchValue: Writable<string> = writable("");
    public static searchResults: Writable<IReportResult[]> = writable([]);
    public static searchLoading: Writable<boolean> = writable(false);
    public static viewingReport: Writable<IReport | boolean> = writable(false)

    public static async query_searchValue() {
        ReportsController.searchResults.set([]);
        ReportsController.searchLoading.set(true);
        // @ts-ignore
        console.log(ReportsController.$searchValue);
        setTimeout(() => {
            setTimeout(() => {
                ReportsController.searchResults.set([
                    {
                        id: 812,
                        title: "Test Report",
                        aOfficer: "Test Officer",
                        timestamp: "Sat Oct 21 2022 23:07:53 GMT-0700 (Pacific Daylight Time)",
                    },
                    {
                        id: 2203,
                        title: "Test Report",
                        aOfficer: "Test Officer",
                        timestamp: "Sat Oct 22 2022 23:07:53 GMT-0700 (Pacific Daylight Time)",
                    },
                ])
                ReportsController.searchLoading.set(false);
            }, 1500)
        }, 500);
    }

    public static async viewReport(id: number) {
    }

    public static load(): IReportResult[] {
        return [
            {
                id: 812,
                title: "Test Report",
                aOfficer: "Test Officer",
                timestamp: "Sat Oct 21 2022 23:07:53 GMT-0700 (Pacific Daylight Time)",
            },
            {
                id: 2203,
                title: "Test Report",
                aOfficer: "Test Officer",
                timestamp: "Sat Oct 22 2022 23:07:53 GMT-0700 (Pacific Daylight Time)",
            },
        ]
    }
}