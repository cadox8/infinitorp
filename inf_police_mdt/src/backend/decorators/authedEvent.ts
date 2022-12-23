import MDT from "@/index";

export default function AuthedEvent(eventName?: string) {
    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
        let o_func = descriptor.value;

        onNet(eventName ?? propertyKey, async (...args: any[]) => {
            let src = global.source
            if (await MDT.getModule("Auth").isAuthorized(src)) {
                descriptor.value(src, ...args);
            } else {
                // prob kick the player
                console.log("Unauthorized attempt to call", propertyKey);
            }
        });
    }
}