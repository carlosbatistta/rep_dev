/*
  Warnings:

  - Made the column `address_control` on table `stocks` required. This step will fail if there are existing NULL values in that column.
  - Made the column `localiz_control` on table `stocks` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "stocks" ALTER COLUMN "address_control" SET NOT NULL,
ALTER COLUMN "localiz_control" SET NOT NULL;
