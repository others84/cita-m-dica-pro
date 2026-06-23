import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/restaurar")({
  component: () => (
    <DashboardLayout title="Restaurar sistema">
      <Placeholder />
    </DashboardLayout>
  ),
});