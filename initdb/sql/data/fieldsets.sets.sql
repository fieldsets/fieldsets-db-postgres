-- Core sets should be between 0 & 100.
INSERT INTO fieldsets.sets (id, token, label, parent, parent_token, store, meta) VALUES
    (0, 'fieldset', 'Default Fieldset', 0,  'fieldset', 'filter', '{}'::JSONB) ON CONFLICT DO NOTHING;
