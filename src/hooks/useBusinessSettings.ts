import { useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useEffect } from "react";

export function useBusinessSettings() {
  const queryClient = useQueryClient();

  // Subscribe to realtime changes for auto-refresh
  useEffect(() => {
    const channel = supabase
      .channel("business_settings_changes")
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "business_settings" },
        () => {
          queryClient.invalidateQueries({ queryKey: ["business_settings"] });
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [queryClient]);

  return useQuery({
    queryKey: ["business_settings"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("business_settings")
        .select("*");
      if (error) throw error;
      const map: Record<string, string> = {};
      data?.forEach((row) => {
        map[row.key] = row.value;
      });
      return map;
    },
  });
}
