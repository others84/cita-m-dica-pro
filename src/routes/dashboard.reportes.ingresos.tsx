import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/reportes/ingresos")({
  component: () => (
    <DashboardLayout title="Reporte de ingresos">
      <Placeholder />
    </DashboardLayout>
  ),
});