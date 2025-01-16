/*
  Warnings:

  - You are about to drop the column `quantity` on the `counts` table. All the data in the column will be lost.
  - You are about to drop the column `address_code` on the `products` table. All the data in the column will be lost.
  - You are about to drop the column `address_id` on the `products` table. All the data in the column will be lost.
  - You are about to drop the column `address_id` on the `stocks` table. All the data in the column will be lost.
  - You are about to drop the column `quantity` on the `stocks` table. All the data in the column will be lost.
  - Added the required column `count_quantity` to the `counts` table without a default value. This is not possible if the table is not empty.
  - Added the required column `difference` to the `counts` table without a default value. This is not possible if the table is not empty.
  - Added the required column `status` to the `counts` table without a default value. This is not possible if the table is not empty.
  - Added the required column `user_name` to the `counts` table without a default value. This is not possible if the table is not empty.
  - Added the required column `addressed_quantity` to the `stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `branch_code` to the `stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `product_code` to the `stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `product_desc` to the `stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `storage_code` to the `stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_quantity` to the `stocks` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "products" DROP CONSTRAINT "products_address_id_fkey";

-- DropForeignKey
ALTER TABLE "stocks" DROP CONSTRAINT "stocks_address_id_fkey";

-- AlterTable
ALTER TABLE "counts" DROP COLUMN "quantity",
ADD COLUMN     "count_quantity" INTEGER NOT NULL,
ADD COLUMN     "difference" INTEGER NOT NULL,
ADD COLUMN     "status" TEXT NOT NULL,
ADD COLUMN     "user_name" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "products" DROP COLUMN "address_code",
DROP COLUMN "address_id";

-- AlterTable
ALTER TABLE "stocks" DROP COLUMN "address_id",
DROP COLUMN "quantity",
ADD COLUMN     "addressed_quantity" INTEGER NOT NULL,
ADD COLUMN     "branch_code" TEXT NOT NULL,
ADD COLUMN     "product_code" TEXT NOT NULL,
ADD COLUMN     "product_desc" TEXT NOT NULL,
ADD COLUMN     "storage_code" TEXT NOT NULL,
ADD COLUMN     "total_quantity" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "addressed_stocks" (
    "id" TEXT NOT NULL,
    "addressed_quantity" INTEGER NOT NULL,
    "product_code" TEXT NOT NULL,
    "product_desc" TEXT NOT NULL,
    "storage_code" TEXT NOT NULL,
    "branch_code" TEXT NOT NULL,
    "address_code" TEXT,
    "address_id" TEXT,
    "product_id" TEXT NOT NULL,
    "storage_id" TEXT NOT NULL,
    "branch_id" TEXT NOT NULL,

    CONSTRAINT "addressed_stocks_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "addressed_stocks" ADD CONSTRAINT "addressed_stocks_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "addresses"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "addressed_stocks" ADD CONSTRAINT "addressed_stocks_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "addressed_stocks" ADD CONSTRAINT "addressed_stocks_storage_id_fkey" FOREIGN KEY ("storage_id") REFERENCES "storages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "addressed_stocks" ADD CONSTRAINT "addressed_stocks_branch_id_fkey" FOREIGN KEY ("branch_id") REFERENCES "branches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
