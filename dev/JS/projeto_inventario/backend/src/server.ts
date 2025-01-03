import express, { Request, Response, NextFunction } from 'express'
import connectSqlServer from './database/sqlServer';
import disconnectSqlServer from './database/sqlServer';
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

app.use((err: Error, req: Request, res: Response, next: NextFunction): void => {
  if (err instanceof Error) {
    // Se for uma instância do tipo Error
    res.status(400).json({
      error: err.message,
    });
  }

  res.status(500).json({
    status: 'error',
    message: 'Internal server error.',
  });
});

async function fetchProfiles() {
  try {
    const pool = await connectSqlServer();
    console.log('SQL server Conectado');
  } catch (error) {
    console.error('Erro ao buscar dados do SQL Server:', error);
  } finally {
    await disconnectSqlServer();
  }
}

fetchProfiles();


app.listen(3333, () => console.log('Servidor online!!!!'))