# Usage: jq -M -f filter.jq data.json
# FIXME: Does not handle NULLs yet

def unmarshal_dynamodb:
  # DynamoDB string type
  (objects | .S)

  # DynamoDB blob type
  // (objects | .B)

  # DynamoDB number type
  // (objects | .N | strings | tonumber)

  # DynamoDB boolean type
  // (objects | .BOOL)

  # DynamoDB map type, recursion on each item
  // (objects | .M | objects | with_entries(.value |= unmarshal_dynamodb))

  # DynamoDB list type, recursion on each item
  // (objects | .L | arrays | map(unmarshal_dynamodb))

  # DynamoDB typed list type SS, string set
  // (objects | .SS | arrays | map(unmarshal_dynamodb))

  # DynamoDB typed list type NS, number set
  // (objects | .NS | arrays | map(tonumber))

  # DynamoDB typed list type BS, blob set
  // (objects | .BS | arrays | map(unmarshal_dynamodb))

  # managing others DynamoDB output entries: "Count", "Items", "ScannedCount" and "ConsumedCapcity"
  // (objects | with_entries(.value |= unmarshal_dynamodb))
  // (arrays | map(unmarshal_dynamodb))

  # leaves values
  // .
  ;
unmarshal_dynamodb

