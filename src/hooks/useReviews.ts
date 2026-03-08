import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

export function useReviews() {
  return useQuery({
    queryKey: ["reviews"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("reviews" as any)
        .select("*")
        .order("created_at", { ascending: false });

      if (error) throw error;

      return (data || []).map((r: any) => ({
        id: r.id,
        client_name: r.client_name || "Anônimo",
        stars: r.stars ?? 5,
        created_at: r.created_at,
      }));
    },
  });
}
