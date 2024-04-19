INSERT INTO fieldsets.fields (id, token, label, type, default_value, store, parent, parent_token, meta) VALUES
    (0, 'none', 'Fieldless', 'none', NULL, 'none', 0, 'none', '{}'::JSONB),
    (1, 'field', 'Field', 'any', NULL, 'any', 1, 'field', '{}'::JSONB),
    (2, 'fieldset', 'FieldSet Field', 'fieldset', NULL, 'any', 1, 'field', '{}'::JSONB),
    (3, 'string', 'String Field', 'string', NULL, 'any', 1, 'field', '{}'::JSONB),
    (4, 'number', 'Number Field', 'number', NULL, 'any', 1, 'field', '{}'::JSONB),
    (5, 'decimal', 'Decimal Field', 'decimal', NULL, 'any', 1, 'field', '{}'::JSONB),
    (6, 'object', 'Object Field', 'object', NULL, 'any', 1, 'field', '{}'::JSONB),
    (7, 'list', 'String List Field', 'list', NULL, 'any', 1, 'field', '{}'::JSONB),
    (8, 'array', 'Integer Array Field', 'array', NULL, 'any', 1, 'field', '{}'::JSONB),
    (9, 'vector', 'Vector Field', 'vector', NULL, 'any', 1, 'field', '{}'::JSONB),
    (10, 'bool', 'Boolean Field', 'bool', NULL, 'any', 1, 'field', '{}'::JSONB),
    (11, 'date', 'Date Field', 'date', NULL, 'any', 1, 'field', '{}'::JSONB),
    (12, 'ts', 'Timestamp Field', 'ts', NULL, 'any', 1, 'field', '{}'::JSONB),
    (13, 'search', 'Search Field', 'search', NULL, 'any', 1, 'field', '{}'::JSONB),
    (14, 'uuid', 'UUID Field', 'uuid', NULL, 'any', 1, 'field', '{}'::JSONB),
    (15, 'function', 'Function Field', 'function', NULL, 'any', 1, 'field', '{}'::JSONB),
    (16, 'alias', 'Alias Field', 'alias', NULL, 'any', 1, 'field', '{}'::JSONB),
    (17, 'enum', 'Enumerated Field', 'enum', NULL, 'any', 1, 'field', '{}'::JSONB),
    (18, 'custom', 'Custom Field', 'any', NULL, 'any', 1, 'field', '{}'::JSONB),
    (19, 'any', 'Any Field', 'any', NULL, 'any', 1, 'field', '{}'::JSONB)
ON CONFLICT DO NOTHING;

-- Set starting fields id val at 100.
SELECT setval('fieldsets.field_id_seq', 100, false);