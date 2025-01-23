/*
  Warnings:

  - You are about to drop the column `branch_code` on the `products` table. All the data in the column will be lost.
  - You are about to drop the column `storage_code` on the `products` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "products" DROP COLUMN "branch_code",
DROP COLUMN "storage_code";
