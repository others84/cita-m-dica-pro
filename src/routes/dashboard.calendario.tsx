import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useRef } from "react";
import { DashboardLayout } from "@/components/dashboard-layout";

const sampleEvents = [
  { id: "1", title: "Consulta — Juan Pérez", start: addDays(0, 9), end: addDays(0, 10) },
  { id: "2", title: "Revisión — María López", start: addDays(1, 11), end: addDays(1, 12) },
  { id: "3", title: "Control — Pedro Ruiz", start: addDays(2, 16), end: addDays(2, 17) },
];

function addDays(daysFromToday: number, hour: number) {
  const d = new Date();
  d.setDate(d.getDate() + daysFromToday);
  d.setHours(hour, 0, 0, 0);
  return d;
}

function CalendarView() {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    let calendar: { destroy?: () => void } | undefined;
    let cancelled = false;

    (async () => {
      const [{ Calendar }, dayGrid, timeGrid, interaction] = await Promise.all([
        import("@event-calendar/core"),
        import("@event-calendar/day-grid"),
        import("@event-calendar/time-grid"),
        import("@event-calendar/interaction"),
      ]);
      await import("@event-calendar/core/index.css");
      if (cancelled || !ref.current) return;

      calendar = new Calendar({
        target: ref.current,
        props: {
          plugins: [dayGrid.default, timeGrid.default, interaction.default],
          options: {
            view: "timeGridWeek",
            headerToolbar: {
              start: "prev,next today",
              center: "title",
              end: "dayGridMonth,timeGridWeek,timeGridDay",
            },
            events: sampleEvents,
            height: "100%",
            locale: "es",
            firstDay: 1,
            buttonText: {
              today: "Hoy",
              dayGridMonth: "Mes",
              timeGridWeek: "Semana",
              timeGridDay: "Día",
            },
          },
        },
      });
    })();

    return () => {
      cancelled = true;
      calendar?.destroy?.();
    };
  }, []);

  return <div ref={ref} className="h-[700px] rounded-lg border bg-card p-2" />;
}

export const Route = createFileRoute("/dashboard/calendario")({
  component: () => (
    <DashboardLayout title="Calendario de citas">
      <CalendarView />
    </DashboardLayout>
  ),
});