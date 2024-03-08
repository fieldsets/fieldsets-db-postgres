/**
 * Fieldsets can be thought of as subsets with their own unique ID.
 * They defined what data is what and which fields belong together.
 * Partition by parent_token, field_parent_token, id % 5 (modulus)
 */
CREATE TABLE IF NOT EXISTS fieldsets.fieldsets (
    id                  BIGINT NOT NULL,
    token               TEXT NOT NULL,
    parent              BIGINT NOT NULL,
    parent_token        TEXT NOT NULL,
    set_id              BIGINT NOT NULL,
    set_token           TEXT NOT NULL,
    set_parent          BIGINT NOT NULL,
    set_parent_token    TEXT NOT NULL,
    field_id            BIGINT NOT NULL,
    field_token         TEXT NOT NULL,
    field_parent        BIGINT NOT NULL,
    field_parent_token  TEXT NOT NULL
) PARTITION BY LIST (parent_token)
TABLESPACE fieldsets;

-- Default if not defined.
CREATE TABLE IF NOT EXISTS fieldsets.__default_fieldsets PARTITION OF fieldsets.fieldsets DEFAULT TABLESPACE fieldsets;
