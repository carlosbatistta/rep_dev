import prismaClient from '../../prisma'

interface ProfileRequest {
  name: string;
  access_id: string;
}

export class CreateProfileService {
    async execute({ name, access_id }: ProfileRequest) {
        if (!name) {
            throw new Error("Name is required");
        }

        const accessAlreadyExists = await prismaClient.access.findFirst({
            where: { id: access_id },
        });

        if (accessAlreadyExists) {
            throw new Error("Acessos não existem");
        }

        const profile = await prismaClient.profile.create({
            data: {
                name,
                access: { connect: { id: access_id } },
            },
            select: {
                id: true,
                name: true,
                access: true,
            },
        });

        return profile;
    }
}