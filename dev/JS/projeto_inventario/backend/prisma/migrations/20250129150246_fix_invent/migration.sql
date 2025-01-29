/*
  Warnings:

  - Added the required column `storage_code` to the `invents` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "invents" ADD COLUMN     "storage_code" TEXT NOT NULL;
