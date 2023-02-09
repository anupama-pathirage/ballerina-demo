import ballerina/http;
import ballerina/xmldata;
import ballerinax/azure_storage_service.blobs;
import ballerina/mime;

configurable string accessKey = ?;
configurable string account = ?;
configurable string container = ?;

type Employee record {|
    string empid;
    string name;
    int birth;
    string location;
|};

service /portal on new http:Listener(8080) {

    resource function post employees/[string fileName](@http:Payload Employee[] employees) returns json|error {
        //Create the blob client
        blobs:BlobClient blobClient = check createBlobClient();
        return blobClient->putBlob(container, fileName, "BlockBlob", employees.toJsonString().toBytes());
    }

    resource function get employees(@http:Header string accept, string fileName) returns json|xml|http:NotAcceptable|error {
        //Create the blob client
        blobs:BlobClient blobClient = check createBlobClient();

        //Get the json fiile from the blob storage
        blobs:BlobResult blob = check blobClient->getBlob(container, fileName);
        string jsonStr = check string:fromBytes(blob.blobContent);
        json inputData = check jsonStr.fromJsonString();

        //Send the response based on the accept header
        match string:toLowerAscii(accept) {
            mime:APPLICATION_JSON => {
                return inputData;
            }
            mime:APPLICATION_XML => {
                return check xmldata:fromJson(inputData);
            }
            _ => {
                return http:NOT_ACCEPTABLE;
            }
        }
    }
}

function createBlobClient() returns blobs:BlobClient|error {
    //Create the blob client
    blobs:ConnectionConfig blobConnectionConfig = {
        accessKeyOrSAS: accessKey,
        accountName: account,
        authorizationMethod: "accessKey"
    };
    return check new (blobConnectionConfig);
}

