import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { useState } from "react";

// Componente App
function App() {
    const [nome, setNome] = useState('')
    const [idade, setIdade] = useState()
    const [email, setEmail] = useState('')
    const [user, setUser] = useState({})

    function alterar(e) {
        e.preventDefauld();
        alert("Usuário Registrado!!")
        setUser({
            userNome: nome,
            userIdade: idade,
            userEmail: email
        });
    }

    return (
        <div>
            <h1>Cadastro de Funcionário</h1>

            <form onSubmit="alterar">
                <label>Nome: </label><br />
                <input type="text" placeholder="Nome?" onChange={(e) => alterar(e.target.value)} /> <br />

                <label>idade: </label><br />
                <input type="text" placeholder="Nome?" onChange={(e) => alterar(e.target.value)} /> <br />

                <label>email: </label><br />
                <input type="text" placeholder="Nome?" onChange={(e) => alterar(e.target.value)} /> <br />
            </form>
        </div>
    );
}

// Renderizar o componente App
createRoot(document.getElementById('root')).render(
    <StrictMode>
        <App />
    </StrictMode>
);


