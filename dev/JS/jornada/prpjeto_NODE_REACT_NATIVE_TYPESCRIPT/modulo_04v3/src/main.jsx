import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import RoutesApp from '../router.jsx'
//import App from "./App.jsx"

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <RoutesApp />
  </StrictMode>,
)
