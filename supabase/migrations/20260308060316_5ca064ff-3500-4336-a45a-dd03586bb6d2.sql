-- 1) Canonical bookings table for all scheduling flows
CREATE TABLE IF NOT EXISTS public.bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_name text NOT NULL,
  client_phone text NOT NULL,
  service_ids text[] NOT NULL,
  service_names text[] NOT NULL DEFAULT '{}'::text[],
  booking_date date NOT NULL,
  booking_time time without time zone NOT NULL,
  total_price numeric NOT NULL DEFAULT 0,
  total_duration integer NOT NULL DEFAULT 0,
  payment_method text,
  status text NOT NULL DEFAULT 'pendente',
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins can manage bookings" ON public.bookings;
DROP POLICY IF EXISTS "Anyone can create bookings" ON public.bookings;
DROP POLICY IF EXISTS "Anyone can view bookings" ON public.bookings;

CREATE POLICY "Admins can manage bookings"
ON public.bookings
FOR ALL
USING (public.has_role(auth.uid(), 'admin'::public.app_role));

CREATE POLICY "Anyone can create bookings"
ON public.bookings
FOR INSERT
WITH CHECK (true);

CREATE POLICY "Anyone can view bookings"
ON public.bookings
FOR SELECT
USING (true);

CREATE INDEX IF NOT EXISTS idx_bookings_date_time ON public.bookings (booking_date, booking_time);
CREATE INDEX IF NOT EXISTS idx_bookings_phone ON public.bookings (client_phone);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON public.bookings (status);

-- 2) Booking validation (date window + payment/status domain)
CREATE OR REPLACE FUNCTION public.validate_booking_data()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $$
BEGIN
  IF NEW.booking_date < CURRENT_DATE THEN
    RAISE EXCEPTION 'Não é possível agendar para uma data no passado.';
  END IF;

  IF NEW.booking_date > CURRENT_DATE + INTERVAL '7 days' THEN
    RAISE EXCEPTION 'Agendamentos só podem ser feitos para os próximos 7 dias.';
  END IF;

  IF NEW.payment_method IS NOT NULL
     AND NEW.payment_method NOT IN ('pix', 'dinheiro', 'cartao', 'plano') THEN
    RAISE EXCEPTION 'Método de pagamento inválido: %. Aceitos: pix, dinheiro, cartao, plano', NEW.payment_method;
  END IF;

  IF NEW.status IS NOT NULL
     AND NEW.status NOT IN ('pendente', 'confirmado', 'finalizado', 'cancelado', 'plano') THEN
    RAISE EXCEPTION 'Status inválido: %. Aceitos: pendente, confirmado, finalizado, cancelado, plano', NEW.status;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS check_booking_data ON public.bookings;
CREATE TRIGGER check_booking_data
BEFORE INSERT OR UPDATE ON public.bookings
FOR EACH ROW
EXECUTE FUNCTION public.validate_booking_data();

-- 3) Reviews table used by home "Avaliações" section
CREATE TABLE IF NOT EXISTS public.reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_name text NOT NULL,
  stars integer NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins can manage reviews" ON public.reviews;
DROP POLICY IF EXISTS "Anyone can view reviews" ON public.reviews;
DROP POLICY IF EXISTS "Anyone can create reviews" ON public.reviews;

CREATE POLICY "Admins can manage reviews"
ON public.reviews
FOR ALL
USING (public.has_role(auth.uid(), 'admin'::public.app_role));

CREATE POLICY "Anyone can view reviews"
ON public.reviews
FOR SELECT
USING (true);

CREATE POLICY "Anyone can create reviews"
ON public.reviews
FOR INSERT
WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON public.reviews (created_at DESC);