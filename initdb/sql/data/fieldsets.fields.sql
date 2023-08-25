INSERT INTO fieldsets.fields (id, token, label, type, store, default_value, parent, parent_token, meta) VALUES
    (0, 'field', 'Default Field', 'any', 'none', NULL, 0, 'field', '{}'::JSONB),
    (10, 'filter', 'Filter Field', 'any', 'filter', NULL, 10, 'filter', '{}'::JSONB),
    (20, 'mapping', 'Mapping Field', 'any', 'mapping', NULL, 20, 'mapping', '{}'::JSONB),
    (30, 'record', 'Record Field', 'any', 'record', NULL, 30, 'record', '{}'::JSONB),
    (40, 'document', 'Document Field', 'any', 'document', NULL, 40, 'document', '{}'::JSONB),
    (50, 'message', 'Message Field', 'any', 'message', NULL, 50, 'message', '{}'::JSONB),
    (60, 'sequence', 'Sequence Field', 'any', 'sequence', NULL, 60, 'sequence', '{}'::JSONB),
    (70, 'enum', 'Enum Field', 'any', 'enum', NULL, 70, 'enum', '{}'::JSONB),
    (80, 'view', 'View Field', 'any', 'view', NULL, 80, 'view', '{}'::JSONB),
    (90, 'file', 'File Field', 'any', 'file', NULL, 90, 'file', '{}'::JSONB),
    (100, 'program', 'Program Field', 'any', 'program', NULL, 100, 'program', '{}'::JSONB),
    (110, 'custom', 'Custom Field', 'any', 'custom', NULL, 110, 'custom', '{}'::JSONB)
ON CONFLICT DO NOTHING;