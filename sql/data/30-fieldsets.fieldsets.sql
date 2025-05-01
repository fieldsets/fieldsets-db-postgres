-- Core fieldsets should be between 0 & 100.
INSERT INTO fieldsets.fieldsets (id, token, label, parent, parent_token, set_id, set_token, field_id, field_token, type, store) VALUES
    (0, 'none', 'Non Fieldset Grouping', 0, 'none', 0, 'none', 0, 'none', 'fieldset', 'fieldset'),
    (1, 'fieldset', 'Fieldset', 1, 'fieldset', 1, 'fieldset', 1, 'fieldset', 'fieldset', 'fieldset')
ON CONFLICT DO NOTHING;

-- Set starting fieldset id val at 1000.
SELECT setval('fieldsets.fieldset_id_seq', 1000, false);