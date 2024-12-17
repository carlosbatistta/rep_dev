import express, { Request, Response, NextFunction } from 'express'
import 'express-async-errors';
import cors from 'cors';
import path from 'path'

import { router } from './routes'
/**Cada app.use é um verificador, um middleware */

const app = express();
app.use(express.json());
app.use(cors()); //libera para qualquer IP possa fazer requisição, pode fazer bloqueios aqui também

app.use(router); //Envia para as rotas

app.use(
  '/files',
  express.static(path.resolve(__dirname, '..', 'tmp'))
)

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  if(err instanceof Error){
    //Se for uma instancia do tipo error
    return res.status(400).json({
      error: err.message
    })
  }

  return res.status(500).json({
    status: 'error',
    message: 'Internal server error.'
  })

})

app.listen(3333, () => console.log('Servidor online!!!!'))