import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/opciones/cambiar-password")({
  component: () => (
    <DashboardLayout title="Cambiar contraseña">
      <Placeholder />
    </DashboardLayout>
  ),
});