/*
  Warnings:

  - You are about to drop the column `branch_code` on the `products` table. All the data in the column will be lost.
  - You are about to drop the column `branch_id` on the `products` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "products" DROP CONSTRAINT "products_branch_id_fkey";

-- DropForeignKey
ALTER TABLE "stocks" DROP CONSTRAINT "stocks_address_id_fkey";

-- AlterTable
ALTER TABLE "products" DROP COLUMN "branch_code",
DROP COLUMN "branch_id";

-- AlterTable
ALTER TABLE "stocks" ALTER COLUMN "address_id" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "stocks" ADD CONSTRAINT "stocks_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "addresses"("id") ON DELETE SET NULL ON UPDATE CASCADE;
