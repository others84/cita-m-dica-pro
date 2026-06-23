import { Link, useNavigate } from "@tanstack/react-router";
import { type ReactNode } from "react";
import { useAuth, type Role } from "@/lib/auth";
import { Button } from "@/components/ui/button";
import {
  Calendar,
  CalendarPlus,
  CalendarX,
  CalendarClock,
  Users,
  UserCog,
  FileBarChart,
  Stethoscope,
  ShieldCheck,
  DatabaseBackup,
  Settings,
  KeyRound,
  LogOut,
} from "lucide-react";

type NavItem = {
  to: string;
  label: string;
  icon: React.ComponentType<{ className?: string }>;
  roles: Role[];
};

type NavGroup = {
  label: string;
  roles: Role[];
  items: NavItem[];
};

const groups: NavGroup[] = [
  {
    label: "Citas",
    roles: ["asistente", "medico", "admin"],
    items: [
      { to: "/dashboard/citas/agendar", label: "Agendar cita", icon: CalendarPlus, roles: ["asistente", "medico", "admin"] },
      { to: "/dashboard/citas/modificar", label: "Modificar cita", icon: CalendarClock, roles: ["asistente", "medico", "admin"] },
      { to: "/dashboard/citas/cancelar", label: "Cancelar cita", icon: CalendarX, roles: ["asistente", "medico", "admin"] },
    ],
  },
  {
    label: "Calendario",
    roles: ["asistente", "medico", "admin"],
    items: [
      { to: "/dashboard/calendario", label: "Ver calendario", icon: Calendar, roles: ["asistente", "medico", "admin"] },
    ],
  },
  {
    label: "Gestión",
    roles: ["medico", "admin"],
    items: [
      { to: "/dashboard/asistentes", label: "Asistentes", icon: Users, roles: ["medico", "admin"] },
      { to: "/dashboard/medicos", label: "Médicos", icon: Stethoscope, roles: ["admin"] },
      { to: "/dashboard/roles", label: "Roles", icon: ShieldCheck, roles: ["admin"] },
    ],
  },
  {
    label: "Reportes",
    roles: ["medico", "admin"],
    items: [
      { to: "/dashboard/reportes/ingresos", label: "Ingresos", icon: FileBarChart, roles: ["medico", "admin"] },
    ],
  },
  {
    label: "Sistema",
    roles: ["admin"],
    items: [
      { to: "/dashboard/restaurar", label: "Restaurar sistema", icon: DatabaseBackup, roles: ["admin"] },
    ],
  },
  {
    label: "Opciones",
    roles: ["asistente", "medico", "admin"],
    items: [
      { to: "/dashboard/opciones/cambiar-password", label: "Cambiar contraseña", icon: KeyRound, roles: ["asistente", "medico", "admin"] },
      { to: "/dashboard/opciones/actualizar-datos", label: "Actualizar datos", icon: UserCog, roles: ["asistente", "medico", "admin"] },
    ],
  },
];

export function DashboardLayout({ title, children }: { title: string; children: ReactNode }) {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  if (!user) {
    if (typeof window !== "undefined") navigate({ to: "/login" });
    return null;
  }

  const handleLogout = () => {
    logout();
    navigate({ to: "/login" });
  };

  const visibleGroups = groups
    .filter((g) => g.roles.includes(user.role))
    .map((g) => ({ ...g, items: g.items.filter((i) => i.roles.includes(user.role)) }))
    .filter((g) => g.items.length > 0);

  return (
    <div className="flex min-h-screen bg-muted">
      <aside className="hidden w-64 flex-col border-r bg-card md:flex">
        <div className="border-b p-4">
          <h2 className="text-lg font-semibold">Citas Médicas</h2>
          <p className="text-xs text-muted-foreground capitalize">{user.role} · {user.username}</p>
        </div>
        <nav className="flex-1 space-y-4 overflow-y-auto p-4">
          {visibleGroups.map((g) => (
            <div key={g.label}>
              <p className="mb-2 px-2 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                {g.label}
              </p>
              <ul className="space-y-1">
                {g.items.map((item) => {
                  const Icon = item.icon;
                  return (
                    <li key={item.to}>
                      <Link
                        to={item.to}
                        className="flex items-center gap-2 rounded-md px-2 py-1.5 text-sm hover:bg-accent"
                        activeProps={{ className: "flex items-center gap-2 rounded-md px-2 py-1.5 text-sm bg-accent font-medium" }}
                      >
                        <Icon className="h-4 w-4" />
                        {item.label}
                      </Link>
                    </li>
                  );
                })}
              </ul>
            </div>
          ))}
        </nav>
        <div className="border-t p-4">
          <Button variant="outline" size="sm" className="w-full justify-start" onClick={handleLogout}>
            <LogOut className="mr-2 h-4 w-4" />
            Cerrar sesión
          </Button>
        </div>
      </aside>
      <main className="flex-1">
        <header className="flex items-center justify-between border-b bg-card px-6 py-4">
          <h1 className="text-xl font-semibold">{title}</h1>
          <Button variant="ghost" size="sm" className="md:hidden" onClick={handleLogout}>
            <LogOut className="h-4 w-4" />
          </Button>
        </header>
        <div className="p-6">{children}</div>
      </main>
    </div>
  );
}

export function Placeholder({ note = "Sección en construcción" }: { note?: string }) {
  return (
    <div className="rounded-lg border border-dashed bg-card p-12 text-center text-muted-foreground">
      {note}
    </div>
  );
}