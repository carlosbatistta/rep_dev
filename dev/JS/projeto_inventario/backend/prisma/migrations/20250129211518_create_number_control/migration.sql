-- CreateTable
CREATE TABLE "number_controls" (
    "id" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "service" TEXT NOT NULL,
    "storage_code" TEXT NOT NULL,
    "branch_code" TEXT NOT NULL,

    CONSTRAINT "number_controls_pkey" PRIMARY KEY ("id")
);
