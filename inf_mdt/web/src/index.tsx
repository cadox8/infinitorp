import React from 'react';
import './index.css';
import App from './components/App';
import { VisibilityProvider } from './providers/VisibilityProvider';
import { createRoot } from 'react-dom/client';
import {DataProvider} from "./providers/DataProvider";

const root = createRoot(document.getElementById('root')!);

root.render(
    <React.StrictMode>
        <DataProvider>
            <VisibilityProvider>
                <App />
            </VisibilityProvider>
        </DataProvider>
    </React.StrictMode>
);