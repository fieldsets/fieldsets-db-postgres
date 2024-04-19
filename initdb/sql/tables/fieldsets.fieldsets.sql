/**
 * Fieldsets can be thought of as subsets with their own unique ID.
 * They defined what data is what and which fields belong together.
 * Partition by set_id, store, type, id % 5 (modulus)
 */
CREATE TABLE IF NOT EXISTS fieldsets.fieldsets (
    id                  BIGINT NOT NULL,
    token               TEXT NOT NULL,
    label               TEXT NOT NULL,
    parent              BIGINT NOT NULL,
    parent_token        TEXT NOT NULL,
    set_id              BIGINT NOT NULL,
    set_token           TEXT NOT NULL,
    field_id            BIGINT NOT NULL,
    field_token         TEXT NOT NULL,
    type                FIELD_TYPE NOT NULL DEFAULT 'string'::FIELD_TYPE,
    store               STORE_TYPE NULL DEFAULT 'filter'::STORE_TYPE
) PARTITION BY LIST (set_id)
TABLESPACE fieldsets;

