import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/citas/agendar")({
  component: () => (
    <DashboardLayout title="Agendar cita">
      <Placeholder />
    </DashboardLayout>
  ),
});