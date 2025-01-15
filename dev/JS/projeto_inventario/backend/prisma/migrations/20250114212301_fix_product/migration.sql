/*
  Warnings:

  - Added the required column `branch_code` to the `products` table without a default value. This is not possible if the table is not empty.
  - Added the required column `branch_id` to the `products` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "products" DROP CONSTRAINT "products_address_id_fkey";

-- AlterTable
ALTER TABLE "products" ADD COLUMN     "address_code" TEXT,
ADD COLUMN     "branch_code" TEXT NOT NULL,
ADD COLUMN     "branch_id" TEXT NOT NULL,
ALTER COLUMN "address_id" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "addresses"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_branch_id_fkey" FOREIGN KEY ("branch_id") REFERENCES "branches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
