/*
  Warnings:

  - You are about to drop the column `data_valid` on the `invents` table. All the data in the column will be lost.
  - Added the required column `date_valid` to the `invents` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "invents" DROP COLUMN "data_valid",
ADD COLUMN     "date_valid" TIMESTAMP(3) NOT NULL;
