import { createFileRoute } from "@tanstack/react-router";
import { DashboardLayout, Placeholder } from "@/components/dashboard-layout";

export const Route = createFileRoute("/dashboard/roles")({
  component: () => (
    <DashboardLayout title="Roles">
      <Placeholder />
    </DashboardLayout>
  ),
});