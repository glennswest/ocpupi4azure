az role assignment create --role "User Access Administrator" --assignee-object-id $(az ad sp list --filter "appId eq 'spgsw43'" | jq '.[0].objectId' -r)

