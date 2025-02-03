/*
  Warnings:

  - Added the required column `status` to the `invent_addresses` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "invent_addresses" ADD COLUMN     "product_code" TEXT,
ADD COLUMN     "product_desc" TEXT,
ADD COLUMN     "status" TEXT NOT NULL,
ALTER COLUMN "address_code" DROP NOT NULL;

-- AlterTable
ALTER TABLE "invent_products" ADD COLUMN     "address_code" TEXT,
ALTER COLUMN "product_code" DROP NOT NULL,
ALTER COLUMN "product_desc" DROP NOT NULL;
