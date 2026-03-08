import { cn } from "@/lib/utils";

interface FooterSignatureProps {
  className?: string;
}

export function FooterSignature({ className }: FooterSignatureProps) {
  return (
    <div className={cn("fixed bottom-2 left-0 right-0 z-10 text-center pointer-events-none select-none opacity-35", className)}>
      <span className="text-[9px] text-foreground/70 font-medium tracking-[0.18em] uppercase">
        Desenvolvido por Michael Pithon
      </span>
    </div>
  );
}
