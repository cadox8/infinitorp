import moment from "moment/moment";

// -- Helpers --
const numbers: string = '0123456789';
const mayus: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const minus: string = 'abcdefghijklmnopqrstuvwxyz'
const simbols: string = '~!@-$'
// -- --

export const isEnvBrowser = (): boolean => !(window as any).invokeNative
export const noop = () => {}
export const capitalize = (msg: string): string => msg.charAt(0).toUpperCase() + msg.slice(1)
export const parseDate = (date: string | undefined, hours: boolean = false): Date => {
    if (!date) return new Date();
    const d: string[] = date.split(' ');
    const dateParts: string[] = d[0].split('/');
    let hoursParts: string[] = [];

    if (hours) hoursParts = d[1].split(':');

    return hours
        ? new Date(Number(dateParts[2]), Number(dateParts[1]) - 1, Number(dateParts[0]), Number(hoursParts[0]), Number(hoursParts[1]), Number(hoursParts[2] || '0'))
        : new Date(Number(dateParts[2]), Number(dateParts[1]) - 1, Number(dateParts[0]));
}
export const getAge = (date: Date): number => {
    return moment().locale('es').diff(date, 'y', false)
}
export const getTime = (date: Date, amount: number): string => {
    return moment(date, 'DD/MM/YYYY HH:mm:ss', 'es', true).add(amount, 'd').format('DD/MM/YYYY HH:mm:ss')
}

export const generateIDRegistro = (): string => {
    const part1 = Array(3).join().split(',').map(() => mayus.charAt(Math.floor(Math.random() * mayus.length))).join('');
    const part2 = Array(3).join().split(',').map(() => numbers.charAt(Math.floor(Math.random() * numbers.length))).join('');
    return part1 + '-' + part2;
}