import ballerina/io;
import ballerina/test;

@test:Config {
    dataProvider: data
}
function transformTest(string inputFile, string expectedFile) returns error? {
    json inputJson = check io:fileReadJson(inputFile);
    Employee[] input = check inputJson.cloneWithType();
    OutputEmployee[] transformResult = transform(input);

    json expectedJson = check io:fileReadJson(expectedFile);
    OutputEmployee[] expected = check expectedJson.cloneWithType();
    test:assertEquals(transformResult, expected);
}
