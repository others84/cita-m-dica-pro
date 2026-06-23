import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useRef } from "react";
import { DashboardLayout } from "@/components/dashboard-layout";

function addDays(daysFromToday: number, hour: number) {
  const d = new Date();
  d.setDate(d.getDate() + daysFromToday);
  d.setHours(hour, 0, 0, 0);
  return d;
}

const sampleEvents = [
  { id: "1", title: "Consulta — Juan Pérez", start: addDays(0, 9), end: addDays(0, 10) },
  { id: "2", title: "Revisión — María López", start: addDays(1, 11), end: addDays(1, 12) },
  { id: "3", title: "Control — Pedro Ruiz", start: addDays(2, 16), end: addDays(2, 17) },
];

function CalendarView() {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    let ec: unknown;
    let cancelled = false;

    (async () => {
      const mod = await import("@event-calendar/core");
      await import("@event-calendar/core/index.css");
      if (cancelled || !ref.current) return;

      ec = mod.createCalendar(ref.current, [mod.DayGrid, mod.TimeGrid, mod.Interaction], {
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
      });
    })();

    return () => {
      cancelled = true;
      if (ec) {
        void import("@event-calendar/core").then((m) => m.destroyCalendar(ec));
      }
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