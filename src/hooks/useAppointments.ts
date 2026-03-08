import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

export function useAppointments(date?: string) {
  return useQuery({
    queryKey: ["bookings", date],
    queryFn: async () => {
      let q = supabase
        .from("bookings" as any)
        .select("*")
        .order("booking_date")
        .order("booking_time");
      if (date) q = (q as any).eq("booking_date", date);
      const { data, error } = await q;
      if (error) throw error;
      // Normalize field names to work with existing components
      return (data || []).map((row: any) => ({
        ...row,
        appointment_date: row.booking_date ?? row.appointment_date,
        appointment_time: row.booking_time ?? row.appointment_time,
      }));
    },
  });
}
