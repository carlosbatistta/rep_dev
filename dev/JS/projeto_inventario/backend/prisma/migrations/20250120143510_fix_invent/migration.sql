/*
  Warnings:

  - Added the required column `filial` to the `invents` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "invents" ADD COLUMN     "filial" TEXT NOT NULL;
