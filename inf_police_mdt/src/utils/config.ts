import IConfig from "@typings/IConfig";

let cache: IConfig | null = null

export default function loadConfig(): IConfig {
    try {
        if (cache) return cache;

        // @ts-ignore
        cache = JSON.parse(LoadResourceFile(GetCurrentResourceName(), "config.json"));

        return cache as IConfig;
    } catch (error) {
        console.log("Failed to load config.json");
    }

    return {} as IConfig;
}