import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/medicos")({
  component: () => (
    <DashboardLayout title="Médicos">
      <Placeholder />
    </DashboardLayout>
  ),
});