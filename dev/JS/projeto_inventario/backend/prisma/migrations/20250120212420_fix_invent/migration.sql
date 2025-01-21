/*
  Warnings:

  - You are about to drop the column `filial` on the `invents` table. All the data in the column will be lost.
  - Added the required column `branch_code` to the `invents` table without a default value. This is not possible if the table is not empty.
  - Added the required column `branch_code` to the `products` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "invents" DROP COLUMN "filial",
ADD COLUMN     "branch_code" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "products" ADD COLUMN     "branch_code" TEXT NOT NULL;
