CREATE TYPE fieldsets.result_status AS ENUM (
	'Incomplete-unresolved',
	'Incomplete-resolved',
	'Finalized-requires-attention-waiting',
	'Finalized-requires-attention-done',
	'Finalized-waiting-review',
	'Finalized-review-accepted',
	'Finalized-review-rejected',
	'Finalized-ready-to-publish',
	'Incomplete-recruiting',
	'Finalized-status-hidden'
);

COMMENT ON TYPE fieldsets.result_status IS 'This type will be used to show the status of each AI execution for each user. More explanation can be found in "Avoid resolution/Indulge foods 2017-07-19" by Jaymes.';