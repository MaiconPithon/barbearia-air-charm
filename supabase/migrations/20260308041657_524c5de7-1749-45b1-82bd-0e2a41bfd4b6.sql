
CREATE OR REPLACE FUNCTION public.validate_payment_method()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $function$
BEGIN
  IF NEW.payment_method IS NOT NULL AND NEW.payment_method NOT IN ('pix', 'dinheiro', 'cartao', 'plano') THEN
    RAISE EXCEPTION 'Método de pagamento inválido: %. Aceitos: pix, dinheiro, cartao, plano', NEW.payment_method;
  END IF;
  RETURN NEW;
END;
$function$;
