/*
  Warnings:

  - Added the required column `reservation` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `reserve_quanty` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transfer` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transfer_quanty` to the `addressed_stocks` table without a default value. This is not possible if the table is not empty.
  - Added the required column `negative_cost` to the `products` table without a default value. This is not possible if the table is not empty.
  - Added the required column `zero_cost` to the `products` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "addressed_stocks" ADD COLUMN     "reservation" BOOLEAN NOT NULL,
ADD COLUMN     "reserve_quanty" INTEGER NOT NULL,
ADD COLUMN     "transfer" BOOLEAN NOT NULL,
ADD COLUMN     "transfer_quanty" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "products" ADD COLUMN     "negative_cost" BOOLEAN NOT NULL,
ADD COLUMN     "zero_cost" BOOLEAN NOT NULL,
ALTER COLUMN "cost" DROP NOT NULL,
ALTER COLUMN "branch_code" DROP NOT NULL;
