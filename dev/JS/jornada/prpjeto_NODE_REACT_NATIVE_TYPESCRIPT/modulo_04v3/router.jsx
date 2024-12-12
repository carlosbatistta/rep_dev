import { BrowserRouter, Route, Routes } from 'react-router-dom';
import Home from './src/pages/Home/index.jsx'
import Sobre from './src/pages/Sobre/index.jsx'
import Contato from './src/pages/Contato/index.jsx'
import Header from './components/Header/index.jsx';


function RoutesApp() {
    return (
        <BrowserRouter>
            <Header />
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/sobre" element={<Sobre />} />
                <Route path="/contato" element={<Contato />} />
            </Routes>
        </BrowserRouter>
    )
}

export default RoutesApp;