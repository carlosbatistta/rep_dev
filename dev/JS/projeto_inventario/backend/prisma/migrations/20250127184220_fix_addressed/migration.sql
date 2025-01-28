/*
  Warnings:

  - Added the required column `total_addressed_quantity` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "addressed_stocks" ADD COLUMN     "total_addressed_quantity" INTEGER NOT NULL;
