import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/opciones/actualizar-datos")({
  component: () => (
    <DashboardLayout title="Actualizar datos del usuario">
      <Placeholder />
    </DashboardLayout>
  ),
});