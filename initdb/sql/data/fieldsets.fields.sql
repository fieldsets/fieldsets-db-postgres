-- Core fields should be between 0 & 100.
INSERT INTO fieldsets.fields (id, token, label, type, store, default_value.string, parent, meta) VALUES
    (0, 'field', 'Default Field', 'string', 'filter', '', 0, '{}'::JSONB) ON CONFLICT DO NOTHING;