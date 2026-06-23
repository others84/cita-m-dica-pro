import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/citas/modificar")({
  component: () => (
    <DashboardLayout title="Modificar cita">
      <Placeholder />
    </DashboardLayout>
  ),
});