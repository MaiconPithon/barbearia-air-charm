import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

interface ReviewsOptions {
  includeHidden?: boolean;
}

export function useReviews(opts: ReviewsOptions = {}) {
  const { includeHidden = false } = opts;
  return useQuery({
    queryKey: ["reviews", { includeHidden }],
    queryFn: async () => {
      let query = supabase
        .from("reviews" as any)
        .select("*")
        .order("created_at", { ascending: false });

      const { data, error } = await query;
      if (error) throw error;

      const all = (data || []).map((r: any) => ({
        id: r.id,
        client_name: r.client_name || "Anônimo",
        stars: r.stars ?? 5,
        created_at: r.created_at,
        hidden: r.hidden ?? false,
      }));

      return includeHidden ? all : all.filter((r) => !r.hidden);
    },
  });
}
