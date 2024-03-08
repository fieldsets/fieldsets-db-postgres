-- Core fieldsets should be between 0 & 100.
INSERT INTO fieldsets.fieldsets (id, token, parent, parent_token, set_id, field_id, type, store) VALUES
    (0, 'none', 0, 'none', 0, 0, 'none', 'none'),
    (1, 'fieldset', 1, 'fieldset', 1, 1, 'any', 'any')
ON CONFLICT DO NOTHING;

-- Set starting set val at 1000.
SELECT setval('fieldsets.fieldset_id_seq', 1000, false);