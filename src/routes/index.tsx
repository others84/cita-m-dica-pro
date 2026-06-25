import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/")({
  component: () => (
    <main className="min-h-screen flex items-center justify-center p-8">
      <div className="text-center space-y-2">
        <h1 className="text-2xl font-semibold">Workspace limpio</h1>
        <p className="text-muted-foreground">Listo para nuevas instrucciones.</p>
      </div>
    </main>
  ),
});