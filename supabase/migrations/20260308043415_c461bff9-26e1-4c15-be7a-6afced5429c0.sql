
CREATE OR REPLACE FUNCTION public.validate_appointment_date()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $function$
BEGIN
  IF NEW.appointment_date < CURRENT_DATE THEN
    RAISE EXCEPTION 'Não é possível agendar para uma data no passado.';
  END IF;
  IF NEW.appointment_date > CURRENT_DATE + INTERVAL '7 days' THEN
    RAISE EXCEPTION 'Agendamentos só podem ser feitos para os próximos 7 dias.';
  END IF;
  RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS check_appointment_date ON public.appointments;
CREATE TRIGGER check_appointment_date
  BEFORE INSERT ON public.appointments
  FOR EACH ROW
  EXECUTE FUNCTION public.validate_appointment_date();
