/*
  Warnings:

  - Made the column `cost` on table `stocks` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "stocks" ALTER COLUMN "cost" SET NOT NULL;

-- CreateTable
CREATE TABLE "info_stoacks" (
    "id" TEXT NOT NULL,
    "branch_code" TEXT NOT NULL,
    "storage_code" TEXT NOT NULL,
    "total_stock_value" DOUBLE PRECISION NOT NULL,
    "total_stock_quanty" INTEGER NOT NULL,

    CONSTRAINT "info_stoacks_pkey" PRIMARY KEY ("id")
);
