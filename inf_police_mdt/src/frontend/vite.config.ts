import {defineConfig} from 'vite'
import {svelte} from '@sveltejs/vite-plugin-svelte'
import * as path from "path"
import * as dns from 'dns'
import {minify} from 'html-minifier';

dns.setDefaultResultOrder('verbatim')

const minifyHTML = () => {
    return {
        name: 'html-transform',
        transformIndexHtml(html) {
            return minify(html, {
                collapseWhitespace: true,
            });
        },
    };
}

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [svelte(), minifyHTML()],
    base: '',
    build: {
        outDir: "../../build/frontend",
        emptyOutDir: true,
        rollupOptions: {
            output: {
                // By not having hashes in the name, you don't have to update the manifest, yay!
                entryFileNames: `[name].js`,
                chunkFileNames: `[name].js`,
                assetFileNames: `[name].[ext]`
            }
        }
    },
    resolve: {
        alias: {
            $lib: path.resolve("./src/lib"),
            $components: path.resolve("./src/components"),
            $stores: path.resolve("./src/stores"),
            $typings: path.resolve("../typings")
        }
    }
})
