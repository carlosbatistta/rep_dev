/*
  Warnings:

  - Added the required column `virtual_location` to the `addresses` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "addresses" ADD COLUMN     "virtual_location" TEXT NOT NULL;
