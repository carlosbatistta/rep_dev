/*
  Warnings:

  - Changed the type of `document` on the `info_invents` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "info_invents" DROP COLUMN "document",
ADD COLUMN     "document" INTEGER NOT NULL;
