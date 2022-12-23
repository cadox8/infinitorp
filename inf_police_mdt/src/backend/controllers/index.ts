import "./api.controller";
import "./player.controller";

import MDT from "@/index";
import {Suspect} from "@/entities";
import {EReportTypes} from "@/../typings/IReport";

(async () => {
    let _new_profile = await MDT.getModule("Profiles").createProfile({
        citizenid: 123,
        notes: "test",
        mugshot_url:
            "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
        reports: [1 as unknown as Suspect],
    });

    console.log(_new_profile);

    let _new_report = await MDT.getModule("Reports").createReport({
        title: "A very cool report title",
        type: EReportTypes[0],
        report: "This is a very cool report",
        aOfficer: _new_profile,
        officers: [],
        suspects: [],
        photos: [],
        timestamp: new Date(),
    });

    console.log(_new_report);
})();
