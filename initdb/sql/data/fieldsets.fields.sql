INSERT INTO fieldsets.fields (id, token, label, type, default_value, parent, parent_token, meta) VALUES
    (0, 'field', 'Default Field', 'any', NULL, 0, 'field', '{}'::JSONB),
    (1, 'fieldset', 'FieldSet Field', 'fieldset', NULL, 0, 'field', '{}'::JSONB),
    (2, 'string', 'String Field', 'string', NULL, 0, 'field', '{}'::JSONB),
    (3, 'number', 'Number Field', 'number', NULL, 0, 'field', '{}'::JSONB),
    (4, 'decimal', 'Decimal Field', 'decimal', NULL, 0, 'field', '{}'::JSONB),
    (5, 'object', 'Object Field', 'object', NULL, 0, 'field', '{}'::JSONB),
    (6, 'list', 'String List Field', 'list', NULL, 0, 'field', '{}'::JSONB),
    (7, 'array', 'Integer Array Field', 'array', NULL, 0, 'field', '{}'::JSONB),
    (8, 'vector', 'Vector Field', 'vector', NULL, 0, 'field', '{}'::JSONB),
    (9, 'bool', 'Boolean Field', 'bool', NULL, 0, 'field', '{}'::JSONB),
    (10, 'date', 'Date Field', 'date', NULL, 0, 'field', '{}'::JSONB),
    (11, 'ts', 'Timestamp Field', 'ts', NULL, 0, 'field', '{}'::JSONB),
    (12, 'search', 'Search Field', 'search', NULL, 0, 'field', '{}'::JSONB),
    (13, 'uuid', 'UUID Field', 'uuid', NULL, 0, 'field', '{}'::JSONB),
    (14, 'function', 'Function Field', 'function', NULL, 0, 'field', '{}'::JSONB),
    (15, 'custom', 'Custom Field', 'any', NULL, 0, 'field', '{}'::JSONB),
    (16, 'any', 'Any Field', 'any', NULL, 0, 'field', '{}'::JSONB)
ON CONFLICT DO NOTHING;