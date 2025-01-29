/*
  Warnings:

  - You are about to drop the `info_stoacks` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "info_stoacks";

-- CreateTable
CREATE TABLE "info_stocks" (
    "id" TEXT NOT NULL,
    "branch_code" TEXT NOT NULL,
    "storage_code" TEXT NOT NULL,
    "document" INTEGER NOT NULL,
    "total_stock_value" DOUBLE PRECISION,
    "total_stock_quantity" INTEGER,

    CONSTRAINT "info_stocks_pkey" PRIMARY KEY ("id")
);
