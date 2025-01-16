/*
  Warnings:

  - Made the column `address_code` on table `addressed_stocks` required. This step will fail if there are existing NULL values in that column.
  - Made the column `address_id` on table `addressed_stocks` required. This step will fail if there are existing NULL values in that column.
  - Added the required column `address_code` to the `counts` table without a default value. This is not possible if the table is not empty.
  - Added the required column `branch_code` to the `counts` table without a default value. This is not possible if the table is not empty.
  - Added the required column `product_code` to the `counts` table without a default value. This is not possible if the table is not empty.
  - Added the required column `product_desc` to the `counts` table without a default value. This is not possible if the table is not empty.
  - Added the required column `storage_code` to the `counts` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "addressed_stocks" DROP CONSTRAINT "addressed_stocks_address_id_fkey";

-- AlterTable
ALTER TABLE "addressed_stocks" ALTER COLUMN "address_code" SET NOT NULL,
ALTER COLUMN "address_id" SET NOT NULL;

-- AlterTable
ALTER TABLE "counts" ADD COLUMN     "address_code" TEXT NOT NULL,
ADD COLUMN     "branch_code" TEXT NOT NULL,
ADD COLUMN     "product_code" TEXT NOT NULL,
ADD COLUMN     "product_desc" TEXT NOT NULL,
ADD COLUMN     "storage_code" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "addressed_stocks" ADD CONSTRAINT "addressed_stocks_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "addresses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
