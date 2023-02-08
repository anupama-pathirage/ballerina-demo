import ballerina/xmldata;
import ballerinax/azure_storage_service.blobs;


configurable string accessKey = ?;
configurable string account = ?;

type Address record {
    string streetaddress;
    string city;
    string state;
    string postalcode;
};

type Roles record {
    string title;
    int level;
};

type OutputEmployee record {
    string empid;
    string name;
    int birth;
    string location;
    Roles[] roles;
};

type Personal record {
    string firstname;
    string lastname;
    string gender;
    int birthyear;
    Address address;
};

type Employee record {
    string empid;
    Personal personal;
    Roles[] roles;
};

public function main() returns error? {

    //Create a blob client
    blobs:ConnectionConfig blobConnectionConfig = {
        accessKeyOrSAS: accessKey,
        accountName: account,
        authorizationMethod: "accessKey"
    };
    blobs:BlobClient blobClient = check new (blobConnectionConfig);

    //Get the json fiile from the blob storage
    blobs:BlobResult blob = check blobClient->getBlob("employees", "EmployeeData.json");
    string jsonStr = check string:fromBytes(blob.blobContent);
    json inputData = check jsonStr.fromJsonString();

    //Transform the json data to different json format
    Employee[] inputEmployee = checkpanic inputData.cloneWithType();
    OutputEmployee[] outputData = transform(inputEmployee);

    //Convert the json data to xml and write the xml file back to the blob storage
    xml? xmlData = check xmldata:fromJson(outputData.toJson()); //Why nil is returned here?
    if xmlData is xml {
        _ = check blobClient->putBlob("employees", "EmployeeDataV2.xml", "BlockBlob", xmlData.toString().toBytes());
    }
}

function transform(Employee[] inputEmployeeItem) returns OutputEmployee[] => 
    from var inputEmployeeItemItem in inputEmployeeItem
    select {
        empid: inputEmployeeItemItem.empid,
        name: inputEmployeeItemItem.personal.firstname + inputEmployeeItemItem.personal.lastname,
        birth: inputEmployeeItemItem.personal.birthyear,
        location: inputEmployeeItemItem.personal.address.state,
        roles: inputEmployeeItemItem.roles
    };
