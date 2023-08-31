INSERT INTO fieldsets.fields (id, token, label, type, default_value, parent, parent_token, meta) VALUES
    (0, 'field', 'Default Field', 'any', NULL, 0, 'field', '{}'::JSONB)
ON CONFLICT DO NOTHING;