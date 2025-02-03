/*
  Warnings:

  - Added the required column `date_count` to the `counts` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "counts" ADD COLUMN     "date_count" TEXT NOT NULL;
