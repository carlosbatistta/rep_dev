/*
  Warnings:

  - You are about to drop the column `address_code` on the `counts` table. All the data in the column will be lost.
  - You are about to drop the column `difference` on the `counts` table. All the data in the column will be lost.
  - You are about to drop the `invents` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `date_valid` to the `info_invents` table without a default value. This is not possible if the table is not empty.
  - Added the required column `origin` to the `info_invents` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tp_material` to the `info_invents` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "counts" DROP COLUMN "address_code",
DROP COLUMN "difference";

-- AlterTable
ALTER TABLE "info_invents" ADD COLUMN     "date_valid" TEXT NOT NULL,
ADD COLUMN     "origin" TEXT NOT NULL,
ADD COLUMN     "tp_material" TEXT NOT NULL;

-- DropTable
DROP TABLE "invents";

-- CreateTable
CREATE TABLE "invent_addresses" (
    "id" TEXT NOT NULL,
    "document" INTEGER NOT NULL,
    "difference_quantity" INTEGER,
    "original_quantity" INTEGER,
    "count_quantity" INTEGER,
    "value_diferece" DOUBLE PRECISION,
    "address_code" TEXT,

    CONSTRAINT "invent_addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invent_products" (
    "id" TEXT NOT NULL,
    "document" INTEGER NOT NULL,
    "difference_quantity" INTEGER,
    "original_quantity" INTEGER,
    "count_quantity" INTEGER,
    "value_diferece" DOUBLE PRECISION,
    "product_code" TEXT NOT NULL,
    "product_desc" TEXT NOT NULL,

    CONSTRAINT "invent_products_pkey" PRIMARY KEY ("id")
);
