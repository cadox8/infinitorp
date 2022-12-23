import API from "../controllers/api.controller";

export function Handler(name: string) {
    return function (
        target: any,
        propertyKey: string,
        descriptor: PropertyDescriptor
    ) {
        API.api_handlers[name] = descriptor.value;
    };
}
