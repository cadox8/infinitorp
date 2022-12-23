<script lang="ts">
    import Search from "./reports/search.svelte";
    import Report from "./reports/report.svelte";
    import ReportsController from "./reports/reports.controller";
    import {onDestroy} from "svelte";

    let viewingReport = false;
    let _viewingReport_unSub = ReportsController.viewingReport.subscribe((viewing) => {
        viewingReport = !!viewing;
    })

    onDestroy(() => {
        _viewingReport_unSub();
    })
</script>

<div class="mdt_page">
    {#if viewingReport}
        <Report/>
    {:else}
        <Search/>
    {/if}
</div>

<style lang="scss">

</style>