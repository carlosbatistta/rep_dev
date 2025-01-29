/*
  Warnings:

  - The primary key for the `number_controls` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `number_controls` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "invents" ALTER COLUMN "document" DROP NOT NULL;

-- AlterTable
ALTER TABLE "number_controls" DROP CONSTRAINT "number_controls_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "number_controls_pkey" PRIMARY KEY ("id");
