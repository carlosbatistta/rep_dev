/*
  Warnings:

  - Added the required column `access_nivel` to the `accesses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nivel` to the `profiles` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "accesses" ADD COLUMN     "access_nivel" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "profiles" ADD COLUMN     "nivel" INTEGER NOT NULL;
