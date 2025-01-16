/*
  Warnings:

  - You are about to drop the column `address_id` on the `addressed_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `branch_id` on the `addressed_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `product_id` on the `addressed_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `storage_id` on the `addressed_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `storage_id` on the `addresses` table. All the data in the column will be lost.
  - You are about to drop the column `address_id` on the `counts` table. All the data in the column will be lost.
  - You are about to drop the column `branch_id` on the `counts` table. All the data in the column will be lost.
  - You are about to drop the column `stock_id` on the `counts` table. All the data in the column will be lost.
  - You are about to drop the column `storage_id` on the `counts` table. All the data in the column will be lost.
  - You are about to drop the column `branch_id` on the `stocks` table. All the data in the column will be lost.
  - You are about to drop the column `product_id` on the `stocks` table. All the data in the column will be lost.
  - You are about to drop the column `storage_id` on the `stocks` table. All the data in the column will be lost.
  - You are about to drop the column `storage_id` on the `virtual_locations` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "addressed_stocks" DROP CONSTRAINT "addressed_stocks_address_id_fkey";

-- DropForeignKey
ALTER TABLE "addressed_stocks" DROP CONSTRAINT "addressed_stocks_branch_id_fkey";

-- DropForeignKey
ALTER TABLE "addressed_stocks" DROP CONSTRAINT "addressed_stocks_product_id_fkey";

-- DropForeignKey
ALTER TABLE "addressed_stocks" DROP CONSTRAINT "addressed_stocks_storage_id_fkey";

-- DropForeignKey
ALTER TABLE "addresses" DROP CONSTRAINT "addresses_storage_id_fkey";

-- DropForeignKey
ALTER TABLE "counts" DROP CONSTRAINT "counts_address_id_fkey";

-- DropForeignKey
ALTER TABLE "counts" DROP CONSTRAINT "counts_branch_id_fkey";

-- DropForeignKey
ALTER TABLE "counts" DROP CONSTRAINT "counts_product_id_fkey";

-- DropForeignKey
ALTER TABLE "counts" DROP CONSTRAINT "counts_stock_id_fkey";

-- DropForeignKey
ALTER TABLE "counts" DROP CONSTRAINT "counts_storage_id_fkey";

-- DropForeignKey
ALTER TABLE "stocks" DROP CONSTRAINT "stocks_branch_id_fkey";

-- DropForeignKey
ALTER TABLE "stocks" DROP CONSTRAINT "stocks_product_id_fkey";

-- DropForeignKey
ALTER TABLE "stocks" DROP CONSTRAINT "stocks_storage_id_fkey";

-- DropForeignKey
ALTER TABLE "virtual_locations" DROP CONSTRAINT "virtual_locations_storage_id_fkey";

-- AlterTable
ALTER TABLE "addressed_stocks" DROP COLUMN "address_id",
DROP COLUMN "branch_id",
DROP COLUMN "product_id",
DROP COLUMN "storage_id";

-- AlterTable
ALTER TABLE "addresses" DROP COLUMN "storage_id";

-- AlterTable
ALTER TABLE "counts" DROP COLUMN "address_id",
DROP COLUMN "branch_id",
DROP COLUMN "stock_id",
DROP COLUMN "storage_id";

-- AlterTable
ALTER TABLE "stocks" DROP COLUMN "branch_id",
DROP COLUMN "product_id",
DROP COLUMN "storage_id";

-- AlterTable
ALTER TABLE "virtual_locations" DROP COLUMN "storage_id";
