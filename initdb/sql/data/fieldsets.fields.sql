INSERT INTO fieldsets.fields (id, token, label, type, store, default_value, parent, parent_token, meta) VALUES
    (0, 'field', 'Default Field', 'any', 'none', NULL, 0, 'field', '{}'::JSONB),
    (10, 'filter', 'Filter Field', 'any', 'filter', NULL, 0, 'field', '{}'::JSONB),
    (20, 'mapping', 'Mapping Field', 'any', 'mapping', NULL, 0, 'field', '{}'::JSONB),
    (30, 'record', 'Record Field', 'any', 'record', NULL, 0, 'field', '{}'::JSONB),
    (40, 'document', 'Document Field', 'any', 'document', NULL, 0, 'field', '{}'::JSONB),
    (50, 'message', 'Message Field', 'any', 'message', NULL, 0, 'field', '{}'::JSONB),
    (60, 'sequence', 'Sequence Field', 'any', 'sequence', NULL, 0, 'field', '{}'::JSONB),
    (70, 'enum', 'Enum Field', 'any', 'enum', NULL, 0, 'field', '{}'::JSONB),
    (80, 'view', 'View Field', 'any', 'view', NULL, 0, 'field', '{}'::JSONB),
    (90, 'file', 'File Field', 'any', 'file', NULL, 0, 'field', '{}'::JSONB),
    (100, 'program', 'Program Field', 'any', 'program', NULL, 0, 'field', '{}'::JSONB),
    (110, 'custom', 'Custom Field', 'any', 'custom', NULL, 0, 'field', '{}'::JSONB)
ON CONFLICT DO NOTHING;