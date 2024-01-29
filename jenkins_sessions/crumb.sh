#/bin/bash

CRUMB=$(curl --user admin:11eb1a8f9bc0f24e427978215a6ae77c45 http://192.168.1.106:8080/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
curl --user "admin:11eb1a8f9bc0f24e427978215a6ae77c45" -H "$CRUMB" -X POST http://192.168.1.106:8080/job/first-job/build
