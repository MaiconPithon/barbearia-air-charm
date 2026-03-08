import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

export function useReviews() {
    return useQuery({
        queryKey: ["reviews"],
        queryFn: async () => {
            // Try reviews table first (user's actual table)
            const { data: reviewsData, error: reviewsError } = await supabase
                .from("reviews" as any)
                .select("*")
                .order("created_at", { ascending: false });

            if (!reviewsError && reviewsData && reviewsData.length >= 0) {
                return (reviewsData as any[]).map((r: any) => ({
                    id: r.id,
                    client_name: r.client_name || r.nome_cliente || "Anônimo",
                    stars: r.stars ?? r.estrelas ?? 5,
                    created_at: r.created_at,
                }));
            }

            // Fallback to avaliacoes
            const { data, error } = await supabase
                .from("avaliacoes")
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
