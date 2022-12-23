import {Client} from "qbcore.js";
import IConfig from "@typings/IConfig";
import loadConfig from "@utils/config";
import EEvents from "@typings/enums/events";
import UiController from "@/controllers/ui.controller";

export default class Index {
    protected qbcore: Client;
    protected config: IConfig;

    constructor(qbcore: Client) {
        console.log("MDT Loaded");
        this.qbcore = qbcore;
        this.config = loadConfig();

        RegisterCommand("mdt", () => {
            this.open();
        }, false)

        if (this.config.client.keybind !== "") {
            RegisterKeyMapping("mdt", "Open MDT", "keyboard", this.config.client.keybind);
        }
    }

    public open() {
        let plyData = this.qbcore.Functions.GetPlayerData();
        if (!plyData.metadata.isDead && !plyData.metadata.inlaststand && !plyData.metadata.ishandcuffed && !IsPauseMenuActive()) {
            console.log("Opening MDT");
            emitNet(EEvents.req_open)
            SetNuiFocus(true, true);
        }
    }

    @UiController.RegisterApiHandler(EEvents.mdt_close)
    public close() {
        SetNuiFocus(false, false);
    }
}