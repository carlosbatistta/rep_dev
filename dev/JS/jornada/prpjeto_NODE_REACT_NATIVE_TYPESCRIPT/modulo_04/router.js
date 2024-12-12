import { BrowserRouter, Route, Routes } from 'react-router-dom';
import Home from './src/pages/Home'
import Sobre from './src/pages/Sobre'

function RouteApp() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path='/' element={<Home />} />
                <Route path='/sobre' element={<Sobre />} />
            </Routes>
        </BrowserRouter>
    )
}

export default RouteApp;