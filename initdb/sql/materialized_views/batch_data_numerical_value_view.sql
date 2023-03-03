-- public.batch_data_numerical_value_view source

CREATE MATERIALIZED VIEW public.batch_data_numerical_value_view
TABLESPACE pg_default
AS WITH qry AS (
         SELECT s.batch_id,
            '2'::text AS batch_data_id,
            s.execution_id,
            count(s.sample_data_value) AS batch_data_value
           FROM ( SELECT sample.sample_id,
                    sample.sample_name,
                    sample.plate_position,
                    sample.batch_id,
                    sample.flowcell_id,
                    sample_data_string_value.sample_data_id,
                    sample_data_string_value.execution_id,
                    sample_data_string_value.sample_data_value
                   FROM sample
                     JOIN sample_data_string_value USING (sample_id)
                  WHERE sample_data_string_value.sample_data_id = 7 AND sample_data_string_value.sample_data_value::text = 'customer'::text) s
          GROUP BY s.batch_id, s.flowcell_id, s.execution_id
        )
 SELECT qry.batch_id,
    qry.batch_data_id,
    qry.execution_id,
    qry.batch_data_value
   FROM qry
UNION
 SELECT b.batch_id,
    '1'::text AS batch_data_id,
    b.execution_id,
    sum(b.sample_data_value) AS batch_data_value
   FROM ( SELECT sample.sample_id,
            sample.sample_name,
            sample.plate_position,
            sample.batch_id,
            sample.flowcell_id,
            sample_data_numerical_value.sample_data_id,
            sample_data_numerical_value.execution_id,
            sample_data_numerical_value.sample_data_value
           FROM sample
             JOIN sample_data_numerical_value USING (sample_id)
          WHERE sample_data_numerical_value.sample_data_id = 1) b
  GROUP BY b.batch_id, b.flowcell_id, b.execution_id
UNION
 SELECT b.batch_id,
    '3'::text AS batch_data_id,
    b.execution_id,
    avg(b.sample_data_value) AS batch_data_value
   FROM ( SELECT sample.sample_id,
            sample.sample_name,
            sample.plate_position,
            sample.batch_id,
            sample.flowcell_id,
            sample_data_numerical_value.sample_data_id,
            sample_data_numerical_value.execution_id,
            sample_data_numerical_value.sample_data_value
           FROM sample
             JOIN sample_data_numerical_value USING (sample_id)
          WHERE sample_data_numerical_value.sample_data_id = 4) b
  GROUP BY b.batch_id, b.flowcell_id, b.execution_id
WITH DATA;