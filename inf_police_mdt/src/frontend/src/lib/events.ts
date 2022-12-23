let events: { [key: string]: (...args: any[]) => void } = {};

window.addEventListener('message', (event: any) => {
    let _event = JSON.parse(event.data);

    if (_event.type !== 'mdt_event') return;

    if (events[_event.event]) {
        events[_event.event](_event.data);
    }
})

export function onEvent(event: string, callback: (...args: any[]) => void) {
    events[event] = callback;
}

export function emit<T = any>(event: string, data: any): Promise<T | null> {
    return new Promise((resolve, reject) => {
        // @ts-ignore
        fetch(`https://${GetParentResourceName()}/api_request`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                request: event,
                params: data,
            })
        }).then(res => {
            resolve(res.json());
        }).catch(err => {
            reject(err);
        })
    })
}
