CREATE TABLE items (
  id uuid default gen_random_uuid() PRIMARY KEY,
  name TEXT not null,
  description text,
  price DECIMAL(10, 2),
  created_at timestamptz DEFAULT now()
)