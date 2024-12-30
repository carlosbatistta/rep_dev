import prismaClient from "../../prisma";

interface OrderRequest {
  order_id: string;
}

class SendOrderService {
  async execute({ order_id }: OrderRequest) {
    const order = await prismaClient.order.update({
      where: {
        id: order_id
      },
      // o data faz uma alteração do item filtrado.
      data: {
        draft: false
      }
    })

    return order;

  }
}

export { SendOrderService }