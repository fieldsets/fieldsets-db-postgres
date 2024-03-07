/**
 * Fieldsets can be thought of as subsets with their own unique ID.
 * They defined what data is what and which fields belong together.
 * A set can exist without being mapped to fields. This is useful for tagging individual fields alongside their fieldset grouping.
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
) PARTITION BY LIST (parent)
TABLESPACE fieldsets;

-- Partition by parent, field_parent, id % 5 (modulus)

-- Default if not defined.
CREATE TABLE IF NOT EXISTS fieldsets.__default_fieldsets PARTITION OF fieldsets.fieldsets DEFAULT TABLESPACE fieldsets;
