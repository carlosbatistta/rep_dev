/*
  Warnings:

  - You are about to drop the column `address_control` on the `addressed_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `localiz_control` on the `addressed_stocks` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "addressed_stocks" DROP COLUMN "address_control",
DROP COLUMN "localiz_control";

-- AlterTable
ALTER TABLE "stocks" ADD COLUMN     "address_control" INTEGER,
ADD COLUMN     "localiz_control" TEXT;
