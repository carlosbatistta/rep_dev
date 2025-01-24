/*
  Warnings:

  - The `address_control` column on the `stocks` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "stocks" DROP COLUMN "address_control",
ADD COLUMN     "address_control" INTEGER;
