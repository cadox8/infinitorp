"use strict";
const esbuild = require("esbuild");
const path = require("path");
const fs = require("fs");
const ts = require("typescript");

global.__dirname = path.resolve();

const isProduction = process.argv.findIndex((Item) => Item === "--production") >= 0;
const isWatch = process.argv.findIndex((Item) => Item === "--watch") >= 0;

(async function () {
    for (const module of ["backend", "client"]) {
        const entry = path.join(__dirname, "..", "src", module);

        const tsconfig = ts.readConfigFile(path.join(entry, "tsconfig.json"), (path) => fs.readFileSync(path, "utf8"));

        const tspaths = []

        for (const path of Object.keys(tsconfig.config.compilerOptions.paths) ?? []) {
            tspaths.push(path.split("/")[0])
        }

        const resp = await esbuild.build({
            entryPoints: [path.join(entry, "Auth.ts")],
            outfile: path.join(__dirname, "..", "build", module, "index.js"),
            platform: "browser",
            target: "ES2017",
            format: "iife",
            minify: isProduction,
            bundle: true,
            external: ["/node_modules/*"],
            metafile: true,
            watch: isWatch ? {
                onRebuild(error) {
                    if (error) console.error("watch build failed:", error);
                    else console.log("watch build succeeded");
                }
            } : false,
            plugins: [
                {
                    name: "node-resolve",
                    setup: (build) => {
                        build.onResolve({filter: /.*/}, args => {
                            if (!tspaths.some((Item) => args.path.startsWith(Item)) && !args.path.startsWith("./") && !args.path.includes("src")) {
                                let modulePath = require.resolve(args.path);

                                if (path.isAbsolute(modulePath)) {
                                    modulePath = path.join(...process.cwd().split(path.sep), "node_modules", args.path);
                                }

                                return {
                                    path: modulePath,
                                    external: true
                                }
                            }
                        })
                    }
                }
            ]
        })
        console.log(esbuild.analyzeMetafileSync(resp.metafile, {
            color: true,
            verbose: true,
        }))
    }
})().catch((error) => {
    console.error(error);
}).then((result) => {
    console.log("done");
});