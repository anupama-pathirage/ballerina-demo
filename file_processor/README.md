# File content JSON/XML transformation

## Sample input json in the storage file

```json
[
    {
        "empid": "SJ011MS",
        "personal": {
            "firstname": "Smith",
            "lastname": "Jones",
            "gender": "Male",
            "birthyear": 1980,
            "address": {
                "streetaddress": "724th Street",
                "city": "New York",
                "state": "NY",
                "postalcode": "10038"
            }
        },
        "roles": [
            {
                "id": "AD",
                "title": "admin",
                "level": 3
            },
            {
                "id": "DEV",
                "title": "developer",
                "level": 2
            }
        ]
    },
    {
        "empid": "SJ012RA",
        "personal": {
            "firstname": "Anne",
            "lastname": "Thomas",
            "gender": "Female",
            "birthyear": 1988,
            "address": {
                "streetaddress": "12 Street",
                "city": "Texas",
                "state": "TX",
                "postalcode": "45395"
            }
        },
        "roles": [
            {
                "id": "QA",
                "title": "Quality Analyst",
                "level": 1
            }
        ]
    }
]
```


## Sample output JSON

```json
[
    {
        "empid": "SJ011MS",
        "name": "Smith Jones",
        "birth": 1980,
        "location": "NY",
        "roles": [
            {
                "title": "admin",
                "level": 3,
                "id": "AD"
            },
            {
                "title": "developer",
                "level": 2,
                "id": "DEV"
            }
        ]
    },
    {
        "empid": "SJ012RA",
        "name": "Anne Thomas",
        "birth": 1988,
        "location": "TX",
        "roles": [
            {
                "title": "Quality Analyst",
                "level": 1,
                "id": "QA"
            }
        ]
    }
]
```

## Sample output XML

```xml
<root>
    <item>
        <empid>SJ011MS</empid>
        <name>Smith Jones</name>
        <birth>1980</birth>
        <location>NY</location>
        <roles>
            <title>admin</title>
            <level>3</level>
            <id>AD</id>
        </roles>
        <roles>
            <title>developer</title>
            <level>2</level>
            <id>DEV</id>
        </roles>
    </item>
    <item>
        <empid>SJ012RA</empid>
        <name>Anne Thomas</name>
        <birth>1988</birth>
        <location>TX</location>
        <roles>
            <title>Quality Analyst</title>
            <level>1</level>
            <id>QA</id>
        </roles>
    </item>
</root>
```