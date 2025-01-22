-- AlterTable
ALTER TABLE "addressed_stocks" ALTER COLUMN "reservation" DROP NOT NULL,
ALTER COLUMN "reserve_quanty" DROP NOT NULL,
ALTER COLUMN "transfer" DROP NOT NULL,
ALTER COLUMN "transfer_quanty" DROP NOT NULL;
