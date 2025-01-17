-- CreateTable
CREATE TABLE "info_invents" (
    "id" TEXT NOT NULL,
    "tp_material" TEXT NOT NULL,
    "document" TEXT NOT NULL,
    "date_count" TIMESTAMP(3) NOT NULL,
    "data_valid" TIMESTAMP(3) NOT NULL,
    "origin" TEXT NOT NULL,
    "accuracy_quanty" DOUBLE PRECISION NOT NULL,
    "accuracy_value" DOUBLE PRECISION NOT NULL,
    "accuracy_percent" DOUBLE PRECISION NOT NULL,
    "accuracy_total" DOUBLE PRECISION NOT NULL,
    "total_stock_value" DOUBLE PRECISION NOT NULL,
    "total_inventory_value" DOUBLE PRECISION NOT NULL,
    "total_stock_quanty" INTEGER NOT NULL,
    "total_inventory_quanty" INTEGER NOT NULL,
    "difference_value" DOUBLE PRECISION NOT NULL,
    "difference_quanty" INTEGER NOT NULL,

    CONSTRAINT "info_invents_pkey" PRIMARY KEY ("id")
);
