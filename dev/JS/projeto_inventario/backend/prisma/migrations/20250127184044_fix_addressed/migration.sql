/*
  Warnings:

  - You are about to drop the column `reserve_quanty` on the `addressed_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `transfer_quanty` on the `addressed_stocks` table. All the data in the column will be lost.
  - Added the required column `reserve_quantity` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transfer_quantity` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "addressed_stocks" DROP COLUMN "reserve_quanty",
DROP COLUMN "transfer_quanty",
ADD COLUMN     "reserve_quantity" INTEGER NOT NULL,
ADD COLUMN     "transfer_quantity" INTEGER NOT NULL;
