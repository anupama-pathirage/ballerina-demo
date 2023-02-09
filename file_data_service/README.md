# HTTP Service to access/update files in blob storage

## Sample Input file content

```json
[
    {
        "empid": "SJ011MS",
        "name": "Smith Jones",
        "birth": 1980,
        "location": "NY"
    },
    {
        "empid": "SJ012RA",
        "name": "Anne Thomas",
        "birth": 1988,
        "location": "TX"
    }
]
```

## Sample Requests

### HTTP POST to upload file content

curl http://localhost:8080/portal/employees/employeesV122.json -H "Content-type:application/json" -d "[{\"empid\": \"SJ011MS\",\"name\": \"Smith Jones\", \"birth\": 1980,\"location\": \"NY\"},{\"empid\": \"SJ012RA\",\"name\": \"Anne Thomas\", \"birth\": 1988,\"location\": \"TX\"}]"


### HTTP GET to return file content

curl "http://localhost:8080/portal/employees?fileName=employeesV122.json" -H "accept:application/json" | jq


