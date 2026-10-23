import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/")({
  head: () => ({ meta: [
    { title: 'SGCO Citas — Espacio de trabajo' },
    { name: 'description', content: 'Espacio de trabajo del sistema multiclínica SGCO Citas.' },
    { property: 'og:title', content: 'SGCO Citas — Espacio de trabajo' },
    { property: 'og:description', content: 'Sistema de citas médicas para clínicas, médicos y asistentes.' },
    { property: 'og:type', content: 'website' },
    { name: 'twitter:card', content: 'summary' },
  ] }),
  component: () => (
    <main className="min-h-screen flex items-center justify-center p-8">
      <div className="text-center space-y-2">
        <h1 className="text-2xl font-semibold">Workspace limpio</h1>
        <p className="text-muted-foreground">Listo para nuevas instrucciones.</p>
      </div>
    </main>
  ),
});