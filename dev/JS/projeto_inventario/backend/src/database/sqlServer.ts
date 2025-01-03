import sql from 'mssql';
import dotenv from 'dotenv';

// Carregar variáveis de ambiente
dotenv.config();

const sqlServerConfig = {
    user: process.env.SQLSERVER_USER,
    password: process.env.SQLSERVER_PASSWORD,
    database: process.env.SQLSERVER_DATABASE,
    server: process.env.SQLSERVER_SERVER,
    port: parseInt(process.env.SQLSERVER_PORT || '1433', 10), // Conversão para número
    options: {
        encrypt: true, // Geralmente necessário para conexões remotas
        trustServerCertificate: true, // Ajuste para aceitar certificados não confiáveis
    },
};

async function connectToSqlServer() {
    try {
        const pool = await sql.connect(sqlServerConfig);
        console.log('Conectado ao SQL Server com sucesso!');
        return pool;
    } catch (error) {
        console.error('Erro ao conectar ao SQL Server:', error);
        throw error;
    }
}

export default connectToSqlServer;

// Testando a conexão
connectToSqlServer()
    .then(() => console.log('Teste de conexão bem-sucedido!'))
    .catch(err => console.error('Erro no teste de conexão:', err));
