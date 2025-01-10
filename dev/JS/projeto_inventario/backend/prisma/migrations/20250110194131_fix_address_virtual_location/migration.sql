/*
  Warnings:

  - You are about to drop the column `virtual_location` on the `addresses` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "addresses" DROP COLUMN "virtual_location";

-- CreateTable
CREATE TABLE "virtual_locations" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" INTEGER NOT NULL,
    "storage_id" TEXT NOT NULL,

    CONSTRAINT "virtual_locations_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "virtual_locations" ADD CONSTRAINT "virtual_locations_storage_id_fkey" FOREIGN KEY ("storage_id") REFERENCES "storages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
