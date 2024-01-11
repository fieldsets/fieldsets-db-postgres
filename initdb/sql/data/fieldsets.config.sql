INSERT INTO fieldsets.config (config_token,config_data,created,updated) VALUES
    ('fieldsets_versions','{ "fieldsets": "0.0.0", "fieldsets-local": "0.0.0", "docker-postgres": "15", "docker-clickhouse": "23" }'::JSONB,NOW(),NOW()) ON CONFLICT DO NOTHING;
