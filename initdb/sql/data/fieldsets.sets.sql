-- Core sets should be between 0 & 100.
INSERT INTO fieldsets.sets (id, token, label, parent, parent_token, meta) VALUES
    (0, 'none', '', 0,  'none', '{}'::JSONB),
    (1, 'fieldset', 'Default Fieldset', 0, 'none', '{}'::JSONB)
ON CONFLICT DO NOTHING;

-- Set starting set val at 100.
SELECT setval('fieldsets.set_id_seq', 100, false);
