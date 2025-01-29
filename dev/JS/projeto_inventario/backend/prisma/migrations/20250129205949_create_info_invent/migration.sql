/*
  Warnings:

  - You are about to drop the column `accuracy_percent` on the `invents` table. All the data in the column will be lost.
  - You are about to drop the column `accuracy_quanty` on the `invents` table. All the data in the column will be lost.
  - You are about to drop the column `accuracy_total` on the `invents` table. All the data in the column will be lost.
  - You are about to drop the column `accuracy_value` on the `invents` table. All the data in the column will be lost.
  - You are about to drop the column `total_inventory_quanty` on the `invents` table. All the data in the column will be lost.
  - You are about to drop the column `total_inventory_value` on the `invents` table. All the data in the column will be lost.
  - You are about to drop the column `total_stock_quanty` on the `invents` table. All the data in the column will be lost.
  - You are about to drop the column `total_stock_value` on the `invents` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "invents" DROP COLUMN "accuracy_percent",
DROP COLUMN "accuracy_quanty",
DROP COLUMN "accuracy_total",
DROP COLUMN "accuracy_value",
DROP COLUMN "total_inventory_quanty",
DROP COLUMN "total_inventory_value",
DROP COLUMN "total_stock_quanty",
DROP COLUMN "total_stock_value";

-- CreateTable
CREATE TABLE "info_invents" (
    "id" SERIAL NOT NULL,
    "document" INTEGER NOT NULL,
    "date_count" TEXT NOT NULL,
    "branch_code" TEXT NOT NULL,
    "storage_code" TEXT NOT NULL,
    "accuracy_quanty" DOUBLE PRECISION,
    "accuracy_value" DOUBLE PRECISION,
    "accuracy_percent" DOUBLE PRECISION,
    "accuracy_total" DOUBLE PRECISION,
    "total_stock_value" DOUBLE PRECISION,
    "total_inventory_value" DOUBLE PRECISION,
    "total_stock_quanty" INTEGER,
    "total_inventory_quanty" INTEGER,

    CONSTRAINT "info_invents_pkey" PRIMARY KEY ("id")
);
