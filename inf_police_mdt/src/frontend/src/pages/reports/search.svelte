<script lang="ts">
    import {FilePlus, MagnifyingGlass} from "radix-icons-svelte";
    import {Button, Loading, Search} from "carbon-components-svelte";
    import type {IReportResult} from "./reports.controller";
    import ReportsController from "./reports.controller";
    import {onDestroy} from "svelte";
    import dayjs from "dayjs";

    let _reports: IReportResult[] = ReportsController.load();
    let _loading: boolean;

    let _reports_unSub = ReportsController.searchResults.subscribe((reports) => _reports = reports);
    let _loading_unSub = ReportsController.searchLoading.subscribe((loading) => _loading = loading);

    onDestroy(() => {
        _reports_unSub();
        _loading_unSub();
    });
</script>

<div style="display: grid; grid-template-rows: auto 1fr;height: 100%;">
    <form class="mb-1" on:submit|preventDefault={() => ReportsController.query_searchValue()}>
        <div class="flex gap-x-1.5">
            <Button class="green" kind="ghost" style="outline: none !important; border:none !important;color: white;">
                <FilePlus/>
            </Button>
            <Search
                    bind:value={ReportsController.$searchValue}
                    class="hover"
                    placeholder="Search..."
                    size="xl"
                    style="background: var(--mdt-color-primary);outline:none;border: none !important;"
            />
            <Button class="red" kind="ghost"
                    on:click={() => ReportsController.searchResults.set([])} style="outline: none !important; border:none !important;color: white;">Clear
            </Button>
        </div>
        <div>
            Supported Filters [id, officer, citizen] | Ex: id:123
        </div>
    </form>
    {#if _loading}
        <div style="width: 100%;height: 100%;display: grid;place-content: center;align-items: center">
            <div style="display: flex;flex-direction: column;align-items: center;justify-content: center;row-gap:30px;font-size: 20px">
                <Loading active={_loading} withOverlay={false}/>
                Searching For Reports...
            </div>
        </div>
    {/if}
    {#if !_loading}
        {#if _reports.length > 0}
            <div class="min-h-max overflow-scroll">
                <ul class="flex flex-col flex-col-reverse gap-y-1 min-h-fit">
                    {#each _reports as report}
                        <li on:click={() => ReportsController.viewReport(report.id)}
                            style="background: var(--mdt-color-primary)" class="border-gray-400 flex flex-row">
                            <div class="transition duration-250 shadow ease-in-out transform hover:shadow-xl select-none cursor-pointer rounded-md flex flex-1 items-center p-4">
                                <div class="flex flex-col min-w-fit h-10 justify-center items-center mr-3 text-lg proportional-nums font-medium">
                                    {report.id}
                                </div>
                                <div class="flex-1 pl-1 md:mr-16">
                                    <div class="font-medium dark:text-white">
                                        {report.title}
                                    </div>
                                    <div class="text-gray-600 dark:text-gray-200 text-sm">
                                        {report.aOfficer}
                                    </div>
                                </div>
                                <div class="capitalize">
                                    {dayjs.utc(report.timestamp).fromNow()}
                                    | {dayjs.utc(report.timestamp).format("MM/DD/YYYY")}
                                </div>
                                <button class="w-24 text-right flex justify-end">
                                    <svg width="12" fill="currentColor" height="12"
                                         class="hover:text-gray-800 dark:hover:text-white dark:text-gray-200 text-gray-500"
                                         viewBox="0 0 1792 1792" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M1363 877l-742 742q-19 19-45 19t-45-19l-166-166q-19-19-19-45t19-45l531-531-531-531q-19-19-19-45t19-45l166-166q19-19 45-19t45 19l742 742q19 19 19 45t-19 45z">
                                        </path>
                                    </svg>
                                </button>
                            </div>
                        <li>
                    {/each}
                </ul>
            </div>
        {:else}
            <div style="width: 100%;height: 100%;display: grid;place-content: center;align-items: center">
                <div style="display: flex;flex-direction: column;align-items: center;justify-content: center;row-gap:30px;font-size: 20px">
                    <MagnifyingGlass size="64"/>
                    No Reports Found
                </div>
            </div>
        {/if}
    {/if}
</div>

<style global lang="scss">
  .bx--loading__stroke {
    stroke: #fff;
  }

  .bx--search-close {
    background: var(--mdt-color-primary) !important;
    outline: none;
    border: none !important;

    svg {
      fill: #878787 !important;
    }

    &::before {
      content: none;
    }

    &:hover {
      background: var(--mdt-color-primary) !important;
      outline: none !important;
      border: none !important;

      svg {
        fill: #fff !important;
      }
    }
  }
</style>
