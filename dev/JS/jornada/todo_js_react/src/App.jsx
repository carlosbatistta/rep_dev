import { useState } from 'react'

import './App.css'

function App() {
  const [todos, setTodos] = useState([
    {
      id: 1,
      text: "Criar funcionalidade X no sistema",
      category: "Trabalho",
      isCompletec: false,
    },
    {
      id: 2,
      text: "CIr para academia",
      category: "Pessoal",
      isCompletec: false,
    },
    {
      id: 3,
      text: "Estudar React",
      category: "Estudos",
      isCompletec: false,
    }
    ])

  return <div className="app"></div> //comando .app cria a <div>

}

export default App
