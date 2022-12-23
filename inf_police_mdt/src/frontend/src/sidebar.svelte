<script lang="ts">
    import {onDestroy} from "svelte";
    import {_global} from "$stores/_global";

    export let pages: any = [];
    let _page: string;

    let current_page_unSubscribe = _global.subscribe(value => {
        _page = value.page;
    });

    onDestroy(() => {
        current_page_unSubscribe();
    });
</script>

<div class="sidebar">
    <ul>
        {#each pages as page, index}
            <li
                    on:click={() => _global.update(value => {value.page = index; return value})}
                    aria-hidden="true"
                    class:active={_page === index}
                    class="text-neutral-300 flex"
            >
                <div class="mdt_sidebar_icon">
                    <svelte:component
                            class="sidebar_button_icon"
                            this={page.icon}
                    />
                </div> {page.title}
            </li>
        {/each}
    </ul>
</div>

<style lang="scss">
  .sidebar {
    width: 100%;
    height: 100%;
    background: var(--mdt-color-primary);
    grid-row: 2;
    grid-column: 1;

    ul {
      height: 100%;
      list-style: none;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      padding: 0 !important;

      li {
        height: fit-content;
        align-items: center;
        width: 100%;
        padding: 15px;
        text-align: left;
        font-weight: 500;
        font-size: 1rem;
        text-transform: capitalize;
        margin: 0 !important;

        .mdt_sidebar_icon {
          width: 30px !important;
          height: 30px !important;
          margin-right: 10px;
        }

        &:hover,
        &.active {
          background: var(--mdt-color-dark);
          cursor: pointer;
        }

      }

      li:last-child {
        margin-top: auto !important;
        bottom: 0;
      }
    }
  }
</style>
