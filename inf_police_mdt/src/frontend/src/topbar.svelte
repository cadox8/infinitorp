<script lang="ts">
    import {user} from "$stores/user";
    import type IUser from "$typings/IClient";
    import {onDestroy} from "svelte";

    let _user: IUser;

    let user_unSubscribe = user.subscribe((value) => (_user = value));

    onDestroy(() => {
        user_unSubscribe();
    });
</script>

<div class="top-bar justify-between">
    <div class="mdt_title">MOBILE DATA LERMINAL</div>
    <div class="mdt_profile">
        <div class="text-neutral-300 border-neutral-400 border-r-2 pr-5">
            {_user.fn + " " + _user.ln}
            <div class="text-neutral-400" style="text-align: right">{_user.callsign}</div>
        </div>
        <img
                alt=""
                class="h-14 w-14 rounded-full ml-5 ring-offset-2 ring-2 ring-red-500"
                src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                style="--tw-ring-offset-color: #1f2937;"
        />
    </div>
</div>

<style lang="scss">
  .top-bar {
    width: 100%;
    height: 100%;
    background: var(--mdt-color-primary);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 15px 0 15px;
    grid-row: 1;
    grid-column: 1 / 3;

    z-index: 1;

    .mdt_title {
      font-size: 1.875rem;
      font-weight: 600;
      letter-spacing: 2px;
    }

    .mdt_profile {
      display: flex;
      align-items: center;
      font-size: 1.1rem;
      font-weight: 500;
      letter-spacing: 2px;
      cursor: pointer;
    }
  }
</style>
