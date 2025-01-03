/*
  Warnings:

  - You are about to drop the column `access` on the `accesses` table. All the data in the column will be lost.
  - Added the required column `permission` to the `accesses` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "accesses" DROP COLUMN "access",
ADD COLUMN     "permission" TEXT NOT NULL;
