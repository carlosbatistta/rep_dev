
import { BrowserRouter, Routes, Route } from 'react-router-dom';

import Home from './pages/Home/index.jsx'
import Filmes from './pages/Filme/index.jsx'

function RoutesApp() {
    return (
        <BrowserRouter>
            <Header />
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/filmes/" element={<Filmes />} />
            </Routes>
        </BrowserRouter>
    )
}

export default RoutesApp;