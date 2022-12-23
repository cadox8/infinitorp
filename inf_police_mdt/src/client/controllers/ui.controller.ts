import EEvents from "@typings/enums/events";

export default class UiController {
    static api_handlers: { [key: string]: Function } = {};

    static RegisterApiHandler(request: string) {
        return (
            target: any,
            propertyKey: string,
            descriptor: PropertyDescriptor
        ) => {
            UiController.api_handlers[request] = descriptor.value;
        };
    }

    static emit(event: string, data: any) {
        console.log(`[MDT] Emitting event ${event} with args: ${data}`);
        SendNUIMessage(
            JSON.stringify({
                type: "mdt_event",
                event,
                data,
            })
        );
    }
}

RegisterNuiCallbackType("api_request_s");
on("__cfx_nui:api_request_s", (data: any, cb: Function) => {
    const request = data.request;
    const params = data.params;

    console.log(
        `[UiController] Handling request_S "${request}" with params: ${JSON.stringify(
            params
        )}`
    );

    TriggerServerEvent(request, params);
});

RegisterNuiCallbackType("api_request");
on("__cfx_nui:api_request", (data: any, cb: Function) => {
    const request = data.request;
    const params = data.params;

    console.log(
        `[UiController] Handling request "${request}" with params: ${JSON.stringify(
            params
        )}`
    );

    if (UiController.api_handlers[request]) {
        UiController.api_handlers[request](params, cb);
    }
});

onNet(EEvents.mdt_s_c, (event: string, data: any) => {
    console.log("Received event from server: " + event);
    UiController.emit(event, data);
});
