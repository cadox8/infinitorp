import DashboardPage from './dashboard.svelte';
import ProfilesPage from "./profiles.svelte";
import ReportsPage from "./reports.svelte";
import DMV from "./dmv.svelte";
import Administration from "./administration.svelte";
import SettingsPage from "./settings.svelte";

import MdDashboard from 'svelte-icons/md/MdDashboard.svelte'
import GoListUnordered from 'svelte-icons/go/GoListUnordered.svelte'
import MdPeople from 'svelte-icons/md/MdPeople.svelte'
import MdDirectionsCar from 'svelte-icons/md/MdDirectionsCar.svelte'
import MdSettings from 'svelte-icons/md/MdSettings.svelte'

export default [
    {
        component: DashboardPage,
        title: "Dashboard",
        icon: MdDashboard,
    },
    {
        component: ReportsPage,
        title: "Reports",
        icon: GoListUnordered,
    },
    {
        component: ProfilesPage,
        title: "Profiles",
        icon: MdPeople,
    },
    {
        component: DMV,
        title: "DMV",
        icon: MdDirectionsCar,
    },
    {
        component: Administration,
        title: "Administration",
        icon: MdPeople,
    },
    {
        component: SettingsPage,
        title: "Settings",
        icon: MdSettings,
    }
]