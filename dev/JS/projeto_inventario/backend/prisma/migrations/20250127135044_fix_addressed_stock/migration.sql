/*
  Warnings:

  - Changed the type of `address_control` on the `addressed_stocks` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "addressed_stocks" DROP COLUMN "address_control",
ADD COLUMN     "address_control" INTEGER NOT NULL;
