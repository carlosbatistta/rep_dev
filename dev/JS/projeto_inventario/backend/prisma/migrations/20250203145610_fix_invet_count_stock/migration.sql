/*
  Warnings:

  - You are about to drop the column `document` on the `info_stocks` table. All the data in the column will be lost.
  - You are about to drop the column `difference_quanty` on the `invents` table. All the data in the column will be lost.
  - You are about to drop the column `difference_value` on the `invents` table. All the data in the column will be lost.
  - Made the column `document` on table `invents` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "counts" ALTER COLUMN "address_code" DROP NOT NULL;

-- AlterTable
ALTER TABLE "info_stocks" DROP COLUMN "document";

-- AlterTable
ALTER TABLE "invents" DROP COLUMN "difference_quanty",
DROP COLUMN "difference_value",
ALTER COLUMN "document" SET NOT NULL;
