export default class API {
    static api_handlers: { [key: string]: Function } = {};

    static init() {
        // loop through api handlers
        for (const [key, value] of Object.entries(API.api_handlers)) {
            // register event
            onNet(key, async (src: number, ...args: any[]) => {
                value(src, ...args);
            });
        }
    }
}

API.init();