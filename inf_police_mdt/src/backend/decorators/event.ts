export default function Event(net: boolean, eventName?: string, callback?: Function): any {
    if (eventName && callback) {
        (net ? onNet : on)(eventName, callback);
    }

    return (target: any, propertyKey: string, descriptor: PropertyDescriptor) => {
        (net ? onNet : on)(eventName ?? propertyKey, descriptor.value.bind(target));
    }
}