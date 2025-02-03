/*
  Warnings:

  - Added the required column `branch_code` to the `invent_addresses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `date_count` to the `invent_addresses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `storage_code` to the `invent_addresses` table without a default value. This is not possible if the table is not empty.
  - Made the column `address_code` on table `invent_addresses` required. This step will fail if there are existing NULL values in that column.
  - Added the required column `branch_code` to the `invent_products` table without a default value. This is not possible if the table is not empty.
  - Added the required column `date_count` to the `invent_products` table without a default value. This is not possible if the table is not empty.
  - Added the required column `storage_code` to the `invent_products` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "counts" ADD COLUMN     "address_code" TEXT;

-- AlterTable
ALTER TABLE "invent_addresses" ADD COLUMN     "branch_code" TEXT NOT NULL,
ADD COLUMN     "date_count" TEXT NOT NULL,
ADD COLUMN     "storage_code" TEXT NOT NULL,
ALTER COLUMN "address_code" SET NOT NULL;

-- AlterTable
ALTER TABLE "invent_products" ADD COLUMN     "branch_code" TEXT NOT NULL,
ADD COLUMN     "date_count" TEXT NOT NULL,
ADD COLUMN     "storage_code" TEXT NOT NULL;
