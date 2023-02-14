import ballerina/http;
import ballerina/xmldata;
import ballerinax/azure_storage_service.blobs;

configurable string accessKeyOrSAS = ?;
configurable string accountName = ?;
configurable string container = ?;

type Address record {
    string streetaddress;
    string city;
    string state;
    string postalcode;
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
};

type Location record {
    string street;
    string zip;
};

type OutputEmployee record {
    string empid;
    string name;
    int birth;
    string city;
    Location location;
};

final blobs:BlobClient blobClient = check createStorageClient();

# A service representing a network-accessible API
# bound to port `9090`.
service /portal on new http:Listener(9090) {

    resource function post employees/[string file](@http:Payload Employee[] employees) returns json|error {
        return blobClient->putBlob(container, file, "BlockBlob", employees.toJsonString().toBytes());
    }

    resource function get employees(string file) returns json|error {
        blobs:BlobResult result = check blobClient->getBlob(container, file);
        string jsonStr = check string:fromBytes(result.blobContent);
        return jsonStr.fromJsonString();
    }

    resource function patch employees(string jsonfile, string xmlfile) returns json|error {
        blobs:BlobResult result = check blobClient->getBlob(container, jsonfile);
        string jsonStr = check string:fromBytes(result.blobContent);
        xml? xmlData = check xmldata:fromJson(check jsonStr.fromJsonString());
        if xmlData is () {
            return error("Error while converting json to xml, xml is null");
        }
        return check blobClient->putBlob(container, xmlfile, "BlockBlob", xmlData.toString().toBytes());
    }

    resource function get employees\-reduced(string file) returns OutputEmployee[]|error {
        blobs:BlobResult result = check blobClient->getBlob(container, file);
        string jsonStr = check string:fromBytes(result.blobContent);
        json jsonData = check jsonStr.fromJsonString();
        Employee[] inputEmployee = check jsonData.cloneWithType();
        return transform(inputEmployee);
    }
}

function transform(Employee[] employee) returns OutputEmployee[] => from var employeeItem in employee
    select {
        empid: employeeItem.empid,
        name: employeeItem.personal.firstname + " " + employeeItem.personal.lastname,
        birth: employeeItem.personal.birthyear,
        city: employeeItem.personal.address.city,
        location: {
            street: employeeItem.personal.address.streetaddress,
            zip: employeeItem.personal.address.postalcode
        }
    };

function createStorageClient() returns blobs:BlobClient|error =>
    new ({accessKeyOrSAS, accountName, authorizationMethod: "accessKey"});



