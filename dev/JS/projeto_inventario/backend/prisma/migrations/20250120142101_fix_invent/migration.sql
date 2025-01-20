/*
  Warnings:

  - You are about to drop the `info_invents` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "info_invents";

-- CreateTable
CREATE TABLE "invents" (
    "id" TEXT NOT NULL,
    "tp_material" TEXT NOT NULL,
    "document" INTEGER NOT NULL,
    "date_count" TIMESTAMP(3) NOT NULL,
    "data_valid" TIMESTAMP(3) NOT NULL,
    "origin" TEXT NOT NULL,
    "accuracy_quanty" DOUBLE PRECISION,
    "accuracy_value" DOUBLE PRECISION,
    "accuracy_percent" DOUBLE PRECISION,
    "accuracy_total" DOUBLE PRECISION,
    "total_stock_value" DOUBLE PRECISION,
    "total_inventory_value" DOUBLE PRECISION,
    "total_stock_quanty" INTEGER,
    "total_inventory_quanty" INTEGER,
    "difference_value" DOUBLE PRECISION,
    "difference_quanty" INTEGER,

    CONSTRAINT "invents_pkey" PRIMARY KEY ("id")
);
