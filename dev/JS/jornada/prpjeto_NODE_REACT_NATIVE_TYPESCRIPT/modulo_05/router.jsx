
import { BrowserRouter, Routes, Route } from 'react-router-dom';

import Home from './src/pages/Home/index.jsx'
import Filmes from './src/pages/Filme/index.jsx'
import Header from './src/componets/Header/index.jsx'

function RoutesApp() {
    return (
        <BrowserRouter>
            <Header />
                <Routes>
                    <Route path="/" element={<Home />} />
                    <Route path="/filmes/:id" element={<Filmes />} />
                </Routes>
        </BrowserRouter>
    )
}

export default RoutesApp;