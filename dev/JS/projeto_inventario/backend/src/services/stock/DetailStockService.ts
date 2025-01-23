import prismaClient from "../../prisma";

interface StockRequest{
    product_code: string
}

export class DetailStockService{
    async execute({product_code}: StockRequest){
        const stock = await prismaClient.stock.findFirst({
            where:{
                product_code: product_code
            }
        })
        console.log(stock)

        return stock;

    }
}