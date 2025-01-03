/*
  Warnings:

  - Added the required column `code` to the `branches` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "branches" ADD COLUMN     "code" INTEGER NOT NULL;
