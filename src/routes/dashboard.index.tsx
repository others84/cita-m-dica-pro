import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/")({
  component: () => (
    <DashboardLayout title="Inicio">
      <Placeholder note="Selecciona una opción del menú" />
    </DashboardLayout>
  ),
});