/*
  Warnings:

  - You are about to drop the column `total_stock_quanty` on the `info_stoacks` table. All the data in the column will be lost.
  - Added the required column `total_stock_quantity` to the `info_stoacks` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "info_stoacks" DROP COLUMN "total_stock_quanty",
ADD COLUMN     "total_stock_quantity" INTEGER NOT NULL;
