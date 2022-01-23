# Nested and repeated Columns

Info (Details): 
- https://github.com/GoogleCloudPlatform/training-data-analyst/blob/master/courses/data-engineering/demos/nested.md

## Nested Columns

### Normal Join
```sql
SELECT 
  block_id, 
  MAX(i.input_sequence_number) AS max_seq_number,
  COUNT(t.transaction_id) as num_transactions_in_block
FROM `cloud-training-demos.bitcoin_blockchain.blocks` AS b
  -- Join on the separate table which stores transaction info
  JOIN `cloud-training-demos.bitcoin_blockchain.transactions` AS t USING(block_id)
  , t.inputs as i 
GROUP BY block_id;
```

### Nested Join

```sql
  , = CROSS JOIN
  , b.transactions AS t = CROSS JOIN b.transactions AS t
```

```sql
SELECT 
  block_id, 
  MAX(i.input_sequence_number) AS max_seq_number,
  COUNT(t.transaction_id) as num_transactions_in_block
FROM `cloud-training-demos.bitcoin_blockchain.blocks` AS b
  -- Use the nested STRUCT within BLOCKS table for transactions instead of a separate JOIN
  , b.transactions AS t
  , t.inputs as i
GROUP BY block_id;
```

Note that the total amount of data ingested is much smaller. The slot time consumed is minutes rather than hours, and there are many fewer bytes shuffled because no join was necessary.

## Repeated Columns (arrays)


### Fix the query: Top 10 Bitcoin blocks by BTC transaction value

```sql
SELECT DISTINCT
  block_id, 
  TIMESTAMP_MILLIS(timestamp) AS timestamp,
  t.transaction_id,
  t.outputs.output_satoshis AS satoshi_value,
  t.outputs.output_satoshis * 0.00000001 AS btc_value
FROM `cloud-training-demos.bitcoin_blockchain.blocks` AS b
  , b.transactions AS t 
  , t.inputs as i
ORDER BY btc_value DESC
LIMIT 10;
```

You should get this error. 

`Error: Cannot access field output_satoshis on a value with type ARRAY<STRUCT<output_satoshis INT64, output_script_bytes BYTES, output_script_string STRING, ...>> at [5:13]`

__What happened?__
The `output_satoshis` field is an array and we need to unpack it first before analyzing it or else we'll have data at differing levels of granularity. 


Solution: Use UNNEST() When you need to break apart ARRAY values for analysis. 
Here the transactions.outputs.output_satoshis field is an array that needs to be unnested before we can analyze it:

```sql
SELECT DISTINCT
  block_id, 
  TIMESTAMP_MILLIS(timestamp) AS timestamp,
  t.transaction_id,
  t_outputs.output_satoshis AS satoshi_value,
  t_outputs.output_satoshis * 0.00000001 AS btc_value
FROM `cloud-training-demos.bitcoin_blockchain.blocks` AS b
  , b.transactions AS t 
  , t.inputs as i
  , UNNEST(t.outputs) AS t_outputs
ORDER BY btc_value DESC
LIMIT 10;
```

Tip: Be extra cautious when giving aliases to your tables and structs. Try to make them clear for the reader like `t_outputs` clearly comes from the `transactions` struct and the child `outputs` struct within. 