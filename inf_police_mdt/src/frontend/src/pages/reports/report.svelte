<script lang="ts">
    import ReportsController from "./reports.controller";
    import {
        Accordion,
        AccordionItem,
        Button,
        Dropdown,
        OverflowMenu,
        OverflowMenuItem,
        TextArea,
        TextInput
    } from "carbon-components-svelte";
    import {onDestroy} from "svelte";
    import {ArrowLeft} from "radix-icons-svelte"
    import {EReportTypes} from "$typings/IReport.js";

    let report;
    let _report_unSub = ReportsController.viewingReport.subscribe((_report) => {
        report = _report;
    })

    onDestroy(() => {
        _report_unSub();
    })

    let selected: string = "1"
</script>

<div class="report">
    <div class="mdt_header">
        <Button class="red" kind="ghost"
                on:click={() => ReportsController.viewingReport.set(false)} style="outline: none !important; border:none !important;color: white;">
            <ArrowLeft size={20}/>
        </Button>
        <OverflowMenu size="xl">
            <OverflowMenuItem text="Manage credentials"/>
            <OverflowMenuItem
                    href="https://cloud.ibm.com/docs/api-gateway/"
                    text="API documentation"
            />
            <OverflowMenuItem danger text="Delete service"/>
        </OverflowMenu>
        <div class="title">{report.title}</div>
        <div class="context">REPORT NO. {report.id}</div>
    </div>
    <div class="content">
        <div class="p-3 flex flex-col" style="background: var(--mdt-color-primary); gap: 5px; height: fit-content;">
            <TextInput labelText="Report Title" placeholder="Enter Report Title..." value={report.title}/>
            <Dropdown items={
                    Object.keys(EReportTypes).map((type) => {
                        return {id: String(type), text: EReportTypes[type]}
                    })
                } placeholder="Select Report Type..." selectedId={String(report.type)}
                      titleText="Report Type"/>
            <TextArea labelText="Report Description" placeholder="Enter Report Description..."
                      style="resize: none; height: max-content !important;"
                      value={report.description}/>
        </div>
        <div class="flex flex-col">
            <Accordion>
                {#each report.suspects as suspect}
                    <AccordionItem style="background: var(--mdt-color-primary); border: none;" bind:title={suspect.name}
                                   class="p-3">
                        Charges
                    </AccordionItem>
                {/each}
            </Accordion>
        </div>
    </div>
</div>

<style global lang="scss">
  .bx--accordion {
    display: flex;
    flex-direction: column;
    gap: 5px;

    :first-child {
      margin-top: 0 !important;
    }

    :last-child {
      margin-bottom: 0 !important;
    }
  }

  .bx--accordion__item--active {
    margin: 10px 0 10px 0;
    transition: 0.1s ease-in-out;

    .bx--accordion__heading {
      border-bottom: 2.5px solid var(--mdt-color-dark-light);
    }

    .bx--accordion__content {
      padding-top: .5rem !important;
      padding-bottom: .5rem !important;
    }
  }

  .report {
    display: grid;
    grid-template-rows: auto 1fr;
    height: 100%;

    .mdt_header {
      display: flex;
      align-items: center;
      color: white;
      font-size: 1.25rem;
      font-weight: 600;
      gap: 5px;
      margin-bottom: 5px;

      .title {
        margin-left: 10px;
        font-size: 1.5rem;
        text-transform: uppercase;
        font-weight: 500;
        letter-spacing: 1px;
        padding: 0;
      }

      .context {
        font-size: 0.75rem;
        font-weight: 400;
        letter-spacing: .75px;
        align-self: start;
        margin-left: auto;
        right: 0;
      }
    }

    .content {
      display: grid;
      grid-template-columns: 50% 50%;
      grid-template-rows: 100%;
      gap: 5px;
      overflow: hidden;

      .mdt_suspects {
        li {
          display: flex;
          align-items: center;
          justify-content: space-between;

          &:hover {
            cursor: pointer;
            background: var(--mdt-color-dark-light) !important;
          }
        }
      }
    }
  }
</style>