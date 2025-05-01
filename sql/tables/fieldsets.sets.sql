/**
 * Sets can be thought of as labeled groups.
 * They defined what data is what and which fields belong together.
 * A set can exist without being mapped to fields. This is useful for tagging individual fields alongside their fieldset grouping.
 */
CREATE TABLE IF NOT EXISTS fieldsets.sets (
    id         	    BIGINT NOT NULL,
    token     	    VARCHAR(255) NOT NULL,
    label      	    TEXT NULL,
    parent     	    BIGINT NOT NULL DEFAULT 1,
    parent_token    VARCHAR(255) NOT NULL DEFAULT 'fieldset',
    meta_data  		    JSONB NULL DEFAULT '{}'::JSONB
) TABLESPACE fieldsets;
