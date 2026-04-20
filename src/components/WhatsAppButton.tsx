import { MessageCircle, Star } from "lucide-react";
import { useBusinessSettings } from "@/hooks/useBusinessSettings";
import { useReviews } from "@/hooks/useReviews";

export function WhatsAppButton() {
  const { data: settings } = useBusinessSettings();
  const { data: reviews } = useReviews();
  const phone = (settings?.phone_number || settings?.whatsapp || "").replace(/\D/g, "");

  if (!phone) return null;

  const count = reviews?.length || 0;
  const avg = count > 0 ? reviews!.reduce((s, r) => s + r.stars, 0) / count : 0;

  return (
    <div className="fixed bottom-6 right-6 z-50 flex flex-col items-end gap-2">
      {count > 0 && (
        <div className="flex items-center gap-1.5 rounded-full bg-black/85 px-3 py-1.5 shadow-lg backdrop-blur-sm border border-white/10">
          <Star className="h-3.5 w-3.5 fill-yellow-400 text-yellow-400" />
          <span className="text-xs font-black text-white">{avg.toFixed(0)}</span>
          <span className="text-[10px] font-semibold text-white/60">({count})</span>
        </div>
      )}
      <a
        href={`https://wa.me/${phone}`}
        target="_blank"
        rel="noopener noreferrer"
        className="flex h-14 w-14 items-center justify-center rounded-full bg-green-500 text-white shadow-lg transition-transform hover:scale-110"
        aria-label="WhatsApp"
      >
        <MessageCircle className="h-7 w-7" />
      </a>
    </div>
  );
}
