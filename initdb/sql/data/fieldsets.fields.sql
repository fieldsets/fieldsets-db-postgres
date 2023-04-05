-- Core fields should be between 0 & 100.
INSERT INTO fieldsets.fields (id, token, label, type, store, default_value, parent, meta) VALUES
    (0, 'field', 'Default Field', 'string', 0, '') ON CONFLICT DO NOTHING;