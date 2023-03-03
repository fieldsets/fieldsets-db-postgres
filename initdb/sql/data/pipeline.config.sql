INSERT INTO pipeline.config (config_token,config_data,created,updated) VALUES
    ('current_analysis_pipeline_version_ids','{ "genie": 38, "fieldsetsga": 40 }'::JSONB,NOW(),NOW()),
    ('current_catalog_ids','{ "human_gene_catalog_id": 4, "microbe_function_catalog_id": 7, "microbe_gene_catalog_id": 4, "microbe_genome_catalog_id": 7 }'::JSONB,NOW(),NOW()),
    ('current_taxonomy_tree_id','{ "taxonomy_tree_id": 7 }'::JSONB,NOW(),NOW()),
    ('current_fieldsets_regime','{ "fieldsets_regime_id": 3, "fieldsets_regime_version_id": 15 }'::JSONB,NOW(),NOW()) ON CONFLICT DO NOTHING;