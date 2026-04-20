ALTER TABLE public.reviews ADD COLUMN IF NOT EXISTS hidden boolean NOT NULL DEFAULT false;
ALTER TABLE public.blocked_slots ADD COLUMN IF NOT EXISTS open_time time without time zone;
ALTER TABLE public.blocked_slots ADD COLUMN IF NOT EXISTS close_time time without time zone;
ALTER TABLE public.blocked_slots ADD COLUMN IF NOT EXISTS lunch_start time without time zone;
ALTER TABLE public.blocked_slots ADD COLUMN IF NOT EXISTS lunch_end time without time zone;