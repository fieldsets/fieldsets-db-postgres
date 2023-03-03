-- public.human_transcript_results index
CREATE INDEX human_transcript_analysisid_idx ON public.human_transcript_results USING btree (analysis_id);
