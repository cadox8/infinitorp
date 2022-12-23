export default interface IConfig {
    mysql: {
        host: string
        port: number
        username: string
        password: string
        database: string
    }
    auth: {
        allowed_job_types: string[];
    };
    client: {
        keybind: string;
    };
}
