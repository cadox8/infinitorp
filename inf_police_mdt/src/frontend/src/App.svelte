<script lang="ts">
    import {fly} from "svelte/transition";
    import pages from "./pages";
    import Sidebar from "./sidebar.svelte";
    import Topbar from "./topbar.svelte";
    import {onDestroy} from "svelte";
    import {_global} from "$stores/_global";
    import EEvents from "$typings/enums/events";
    import {emit, onEvent} from "$lib/events";

    let visible = true
    let _page: number = 0;

    let current_page_subscribe = _global.subscribe(value => {
        _page = value.page;
    });

    onEvent(EEvents.mdt_show, (_visible: any) => {
        console.log(`[MDT] MDT is now ${_visible ? "visible" : "hidden"}`);
        visible = _visible
    })

    let handler = (e: KeyboardEvent) => {
        if (e.code === "Escape") {
            visible = false;
            emit(EEvents.mdt_close, {});
        }
    }

    window.addEventListener("keydown", handler)

    onDestroy(() => {
        current_page_subscribe();
        window.removeEventListener("keydown", handler);
    });
</script>

{#if visible}
    <div
            transition:fly={{ y: 500, duration: 300 }}
            class="_container_ bg-neutral-900"
    >
        <Topbar/>
        <Sidebar {pages}/>
        <svelte:component
                this={pages[_page].component}
        />
    </div>
{/if}

<style global lang="scss">
  @tailwind base;
  @tailwind components;
  @tailwind utilities;

  #app {
    width: 100vw !important;
    height: 100vh !important;
    background: transparent !important;
  }

  * {
    box-sizing: border-box;
  }

  :root {
    --mdt-color-primary: #171717;
    --mdt-color-primary-light: #292b33;
    --mdt-color-dark: #0C0C0C;
    --mdt-color-dark-light: #2c2c2c;
    --mdt-color-red: #2d2025;
    --mdt-color-red-light: #3d2025;
    --mdt-color-green: #202d25;
    --mdt-color-green-light: #2d4025;
  }

  ::-webkit-scrollbar {
    display: none !important;
  }

  .mdt_dev_button {
    padding: 5px;
    background: #3c3c3c;
  }

  .bx--label {
    font-size: 0.8rem !important;
  }

  .bx--btn {
    &.red {
      background: var(--mdt-color-red);

      &:hover {
        background: var(--mdt-color-red-light);
      }
    }

    &.green {
      background: var(--mdt-color-green);

      &:hover {
        background: var(--mdt-color-green-light);
      }
    }
  }

  .bx--search-input {
    &.hover:hover, &.hover:focus {
      background: var(--mdt-color-primary-light) !important;
    }
  }

  ._container_ {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 87.5%;
    max-width: 1500px;
    height: 80%;
    max-height: 790px;
    border-radius: 10px;
    border: 4px solid #646464;
    padding: 10px;
    display: grid;
    grid-template-columns: 12.5% 1fr;
    grid-template-rows: 10% 1fr;
    background: var(--mdt-color-dark);

    .mdt_page {
      width: calc(100% - 5px);
      height: calc(100% - 5px);
      grid-row: 2;
      grid-column: 2;
      margin: 5px 0 0 5px;
      overflow: hidden;
    }
  }
</style>
