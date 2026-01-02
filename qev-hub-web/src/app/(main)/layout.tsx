import { Navbar } from '@/components/Navbar'

export default function MainLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <>
      <Navbar />
      <main className="min-h-screen bg-background">
        {children}
      </main>
    </>
  )
}
