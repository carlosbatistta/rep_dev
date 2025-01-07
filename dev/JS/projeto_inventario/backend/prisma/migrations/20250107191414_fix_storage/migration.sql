/*
  Warnings:

  - You are about to drop the column `branch_id` on the `storages` table. All the data in the column will be lost.
  - Added the required column `code` to the `storages` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "storages" DROP CONSTRAINT "storages_branch_id_fkey";

-- AlterTable
ALTER TABLE "storages" DROP COLUMN "branch_id",
ADD COLUMN     "code" INTEGER NOT NULL;
