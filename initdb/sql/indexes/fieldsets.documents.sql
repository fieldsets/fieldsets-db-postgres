CREATE INDEX fieldsets_documents_document_idx ON fieldsets.documents USING gin (document);