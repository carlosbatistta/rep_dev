/*
  Warnings:

  - You are about to drop the column `negative_cost` on the `products` table. All the data in the column will be lost.
  - You are about to drop the column `zero_cost` on the `products` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "products" DROP COLUMN "negative_cost",
DROP COLUMN "zero_cost";
