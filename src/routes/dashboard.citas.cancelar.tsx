import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/citas/cancelar")({
  component: () => (
    <DashboardLayout title="Cancelar cita">
      <Placeholder />
    </DashboardLayout>
  ),
});