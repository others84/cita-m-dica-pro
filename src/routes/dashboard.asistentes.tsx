import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/asistentes")({
  component: () => (
    <DashboardLayout title="Asistentes">
      <Placeholder />
    </DashboardLayout>
  ),
});