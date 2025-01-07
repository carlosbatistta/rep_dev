//import { connectToSqlServer } from "../../database/sqlServer";

interface ImportRequest {
    name: string;
    branch_id: string;
}

/*export class ImportStorageService {
    async execute({ name, branch_id }: ImportRequest) {
        if (!name) {
            throw new Error("Name is required");
        }

        if (!branch_id) {
            throw new Error("Branch ID is required");
        }

        try {
            // Conectar ao SQL Server
            const pool = await connectToSqlServer();

            // Query para buscar os dados da tabela no SQL Server
            const query = `
        SELECT * FROM [dbo].[YourTableName] 
        WHERE BranchId = @branch_id AND Name = @name
      `;

            // Executar a query no SQL Server
            const result = await pool
                .request()
                .input("branch_id", branch_id)
                .input("name", name)
                .query(query);

            // Verificar se há dados retornados
            if (result.recordset.length === 0) {
                throw new Error("Não há dados.");
            }

            // Retornar os dados importados
            return result.recordset;
        } catch (error) {
            console.error("Erro ao importar dados do SQL Server:", error);
            throw new Error("Failed to import data from SQL Server.");
        }
    }
        
}

*/
