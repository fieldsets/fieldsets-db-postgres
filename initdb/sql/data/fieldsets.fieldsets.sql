-- Core fieldsets should be between 0 & 100.
INSERT INTO fieldsets.fieldsets (id, token, parent, parent_token, set_id, set_token, set_parent, set_parent_token, field_id, field_token, field_parent, field_parent_token) VALUES
    (0, 'none', 0, 'none', 0, 'none', 0, 'none', 0, 'none', 0, 'none'),
    (1, 'fieldset', 0, 'none', 1, 'fieldset', 0, 'none', 0, 'none', 0, 'none')
ON CONFLICT DO NOTHING;

-- Set starting set val at 1000.
SELECT setval('fieldsets.fieldset_id_seq', 1000, false);