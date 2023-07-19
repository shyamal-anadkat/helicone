CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE TABLE provider_keys (
    id bigint generated by default as identity not null primary key,
    org_id UUID NOT NULL REFERENCES public.organization(id),
    provider_name TEXT NOT NULL,
    provider_key TEXT NOT NULL,
    provider_key_name TEXT NOT NULL,
    helicone_proxy_key TEXT,
    helicone_key_name TEXT,
    key_id uuid not null DEFAULT 'e348034b-3f07-4878-aad6-000511d12826' :: uuid,
    nonce bytea default pgsodium.crypto_aead_det_noncegen(),
    CONSTRAINT org_provider_key_name_uniq UNIQUE (org_id, provider_key_name),
    CONSTRAINT org_provider_helicone_key_name_uniq UNIQUE (org_id, provider_name, helicone_key_name)
);

SECURITY LABEL FOR pgsodium ON COLUMN public.provider_keys.provider_key IS 'ENCRYPT WITH KEY COLUMN key_id ASSOCIATED (org_id) NONCE nonce';

ALTER TABLE
    public.provider_keys ENABLE ROW LEVEL SECURITY;