-- Core sets should be between 0 & 100.
INSERT INTO fieldsets.sets (id,token,label,parent,meta) VALUES
    (0, 'fieldset', 'Default Fieldset', 0, '{}'::JSONB) ON CONFLICT DO NOTHING;
