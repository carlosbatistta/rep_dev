/*
  Warnings:

  - Added the required column `storage_code` to the `addresses` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "addresses" ADD COLUMN     "storage_code" INTEGER NOT NULL;
