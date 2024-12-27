import './globals.css'
import { Header } from '@/components/header'
import type { Metadata } from 'next'


export const metadata: Metadata = {
  title: 'Meu Site - Aprendendo NextJS',
  description: 'Site completo para praticar nextjs com sujeito programador',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <Header/>
        {children}
      </body>
    </html>
  )
}
