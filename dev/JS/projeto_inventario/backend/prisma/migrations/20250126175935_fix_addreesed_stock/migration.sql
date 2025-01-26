/*
  Warnings:

  - You are about to drop the column `reservation` on the `addressed_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `transfer` on the `addressed_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `address_control` on the `stocks` table. All the data in the column will be lost.
  - You are about to drop the column `localiz_control` on the `stocks` table. All the data in the column will be lost.
  - Added the required column `address_control` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `localiz_control` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.
  - Made the column `reserve_quanty` on table `addressed_stocks` required. This step will fail if there are existing NULL values in that column.
  - Made the column `transfer_quanty` on table `addressed_stocks` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "addressed_stocks" DROP COLUMN "reservation",
DROP COLUMN "transfer",
ADD COLUMN     "address_control" TEXT NOT NULL,
ADD COLUMN     "localiz_control" TEXT NOT NULL,
ALTER COLUMN "reserve_quanty" SET NOT NULL,
ALTER COLUMN "transfer_quanty" SET NOT NULL;

-- AlterTable
ALTER TABLE "stocks" DROP COLUMN "address_control",
DROP COLUMN "localiz_control";
