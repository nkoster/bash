#!/bin/bash

# Bugs by Niels, enjoy!

function jql {

url=https://$2/rest/api/2/search?jql=${1// /%20}
curl -s -u $3:$4 \
  -X GET -H "Content-Type: application/json" $url | \
awk '/^\{/' | \
jq '.' | \
awk 'BEGIN{count=0}/^      "key":/{count++;printf("%s ", substr($2,2,length($2)-3))}END{print"("count")"}' 
}

if [ $# -lt 4 ]
then
  echo "Usage: $0 '\'<jql query>\' <fqdn[:port]> <user> <password>"
  echo "Remark: only https calls are supported."
  exit 1
fi

jql "$1" "$2" "$3" "$4"
