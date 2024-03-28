-- Core fieldsets should be between 0 & 100.
INSERT INTO fieldsets.tokens (id, token) VALUES
    (0, 'none'),
    (1, 'fieldset')
ON CONFLICT DO NOTHING;
