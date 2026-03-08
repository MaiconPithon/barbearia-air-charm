-- Tighten INSERT policies introduced for public write endpoints
DROP POLICY IF EXISTS "Anyone can create bookings" ON public.bookings;
CREATE POLICY "Anyone can create bookings"
ON public.bookings
FOR INSERT
WITH CHECK (
  length(trim(client_name)) > 0
  AND length(regexp_replace(client_phone, '\\D', '', 'g')) >= 8
  AND booking_date >= CURRENT_DATE
  AND booking_date <= CURRENT_DATE + INTERVAL '7 days'
  AND status IN ('pendente', 'confirmado', 'finalizado', 'cancelado', 'plano')
  AND (payment_method IS NULL OR payment_method IN ('pix', 'dinheiro', 'cartao', 'plano'))
);

DROP POLICY IF EXISTS "Anyone can create reviews" ON public.reviews;
CREATE POLICY "Anyone can create reviews"
ON public.reviews
FOR INSERT
WITH CHECK (
  length(trim(client_name)) > 0
  AND stars BETWEEN 1 AND 5
);