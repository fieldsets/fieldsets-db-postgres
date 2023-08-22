INSERT INTO pipeline.config (config_token,config_data,created,updated) VALUES
    ('pipeline_versions','{}'::JSONB,NOW(),NOW()) ON CONFLICT DO NOTHING;
