import AuthedEvent from "@/decorators/authedEvent";
import EEvents from "@typings/enums/events";

export default class {
    @AuthedEvent(EEvents.req_open)
    static request_open(src: number) {
        console.log(`Player ${src} requested to open the MDT`);
        emitNet(EEvents.mdt_s_c, src, EEvents.mdt_show, true);
    }
}