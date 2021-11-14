# Description: Remove DynamoDB types from JSON export
# Usage: jq -M -f filter.jq data.json
# Usage: jq 'ddb_decode' ddb_export.json
# FIXME: Doesn't handle NULLs yet

def unwanted:    ["B","BOOL","M","S","L","BS","SS"];
def fixpath(p):  [ p[] | select( unwanted[[.]]==[] ) ];
def fixnum(p;v):
    if   p[-2]=="NS" then [p[:-2]+p[-1:],(v|tonumber)]
    elif p[-1]=="N" then [p[:-1], (v|tonumber)]
    else [p,v] end;

reduce (tostream|select(length==2)) as [$p,$v] (
    {}
  ; fixnum(fixpath($p);$v) as [$fp,$fv]
  | setpath($fp;$fv)
)

