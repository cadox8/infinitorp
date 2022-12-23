import winston from "winston";

const colorize = (str: string): string => `\x1b[36m${str}\x1b[0m]`;

const formatLogs = (log: winston.Logform.TransformableInfo): string => {
    if (log.module) return `${log.label} @ ${colorize(log.module)}: ${log.message}`;

    return `${log.label}: ${log.message}`;
}

export const logger = winston.createLogger({
    level: "debug",
    transports: [
        new winston.transports.Console({
            format: winston.format.combine(
                winston.format.label({label: "[\x1b[33mMDT\x1b[0m"}),
                winston.format.colorize({all: true}),
                winston.format.printf(formatLogs)
            )
        })
    ]
})