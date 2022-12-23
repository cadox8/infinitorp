import "carbon-components-svelte/css/g100.css";
import App from './App.svelte'
import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";
import relativeTime from "dayjs/plugin/relativeTime";

dayjs.extend(utc);
dayjs.extend(relativeTime);

const app = new App({
    target: document.getElementById('app')
})

// @ts-ignore
//if (true) {
document.body.style.background = 'transparent';
/*} else {
  document.body.style.background = 'black';
}*/

export default app
