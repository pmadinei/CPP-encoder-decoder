#include <iostream>
#include <sstream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;
#define ENCRYPT_ORDER "encrypt"
#define DECRYPT_ORDER "decrypt"
#define SIMPLE_ORDER "simple"
#define COMPLICATED_ORDER "complicated"
#define END_OF_LINE "\n"
#define ZERO 0
#define INPUT_SIZE 5
#define RANDOM_DEVIDER 11
#define PROGRAM_MODE 0
#define SIMPLE_COMPLICATED 1
#define PASSWORD_KEY 2
#define INPUT_PATH 3
#define OUTPUT_PATH 4

void makeOutputFile();
vector<string> getInputs();
void launchEncryptTasks(vector<string> allInputs);
void launchDecryptTasks(vector<string> allInputs);
void makeDecryptedMessageFile(string outputPath, vector<int> decryptedMessage);
void makeEncryptedMessageFile(string outputPath, string encryptedMessage);
string makeComplicatedDecrypt(vector<int> message, string passwordKey);
string makeSimpleDecrypt(vector<int> message, string passwordKey);
int findSigma(string passwordKey);
vector<int> makeComplicatedEncrypt(string message, string passwordKey);
vector<int> makeSimpleEncrypt(string message, string passwordKey);
vector<int> getDecryptMessage(string inputPath);
int makeNumberFromString(string stringedNumber);
string getEncryptMessage(string inputPath);

int main()
{
    makeOutputFile();
    return ZERO;
}

vector<string> getInputs()
{
    string input;
    vector<string> allInputs;
    for (int counter = ZERO; counter < INPUT_SIZE; counter++)
    {
        cin >> input;
        allInputs.push_back(input);
    }
    return allInputs;
}

int makeNumberFromString(string stringedNumber)
{
    stringstream numberStream;
    numberStream << stringedNumber;
    int integeredNumber;
    numberStream >> integeredNumber;
    return integeredNumber;
}

string getEncryptMessage(string inputPath)
{
    string message, oneLine;
    ifstream inputFile;
    inputFile.open(inputPath);
    while(getline(inputFile, oneLine))
        message.append(oneLine);
    inputFile.close();
    return message;
}

vector<int> getDecryptMessage(string inputPath)
{
    vector<int> message;
    ifstream inputFile;
    inputFile.open(inputPath);
    string oneLine;
    while(getline(inputFile, oneLine))
        message.push_back(makeNumberFromString(oneLine));
    inputFile.close();
    return message;
}

int findSigma(string passwordKey)
{
    int sigma = ZERO;
    for(int counter = ZERO; counter < passwordKey.size(); counter++)
        sigma += int(passwordKey[counter]);
    return sigma;
}

vector<int> makeComplicatedEncrypt(string message, string passwordKey)
{
    vector<int> complicatedEncrypt;
    srand(findSigma(passwordKey));
    for(int counter = ZERO; counter < message.size(); counter++)
        complicatedEncrypt.push_back((rand() % RANDOM_DEVIDER) + int(message[counter]));
    return complicatedEncrypt;
}

vector<int> makeSimpleEncrypt(string message, string passwordKey)
{
    vector<int> simpleEncrypt;
    for (int counter = ZERO; counter < message.size(); counter++)
        simpleEncrypt.push_back(int(passwordKey[counter % (passwordKey.size())]) + int(message[counter]));
    return simpleEncrypt;
}

string makeComplicatedDecrypt(vector<int> message, string passwordKey)
{
    string complicatedDecrypt;
    srand(findSigma(passwordKey));
    for(int counter = ZERO; counter < message.size(); counter++)
        complicatedDecrypt += char(message[counter] - (rand() % RANDOM_DEVIDER));
    return complicatedDecrypt;
}

string makeSimpleDecrypt(vector<int> message, string passwordKey)
{
    string simpleDecrypt;
    for (int counter = ZERO; counter < message.size(); counter++)
        simpleDecrypt += char(message[counter] - passwordKey[counter % (passwordKey.size())]);
    return simpleDecrypt;
}

void makeDecryptedMessageFile(string outputPath, vector<int> decryptedMessage)
{
    ofstream outputFile;
    outputFile.open(outputPath);
    for(int counter = ZERO; counter < decryptedMessage.size(); counter++)
        outputFile << decryptedMessage[counter] << END_OF_LINE;
    outputFile.close();
}

void makeEncryptedMessageFile(string outputPath, string encryptedMessage)
{
    ofstream outputFile;
    outputFile.open(outputPath);
    outputFile << encryptedMessage;
    outputFile.close();
}

void launchEncryptTasks(vector<string> allInputs)
{
    string message = getEncryptMessage(allInputs[INPUT_PATH]);
    if (allInputs[SIMPLE_COMPLICATED] == SIMPLE_ORDER)
        makeDecryptedMessageFile(allInputs[OUTPUT_PATH], makeSimpleEncrypt(message, allInputs[PASSWORD_KEY]));
    else if (allInputs[SIMPLE_COMPLICATED] == COMPLICATED_ORDER)
        makeDecryptedMessageFile(allInputs[OUTPUT_PATH], makeComplicatedEncrypt(message, allInputs[PASSWORD_KEY]));
}

void launchDecryptTasks(vector<string> allInputs)
{
    vector<int> message = getDecryptMessage(allInputs[INPUT_PATH]);
    if (allInputs[SIMPLE_COMPLICATED] == SIMPLE_ORDER)
        makeEncryptedMessageFile(allInputs[OUTPUT_PATH], makeSimpleDecrypt(message, allInputs[PASSWORD_KEY]));
    else if (allInputs[SIMPLE_COMPLICATED] == COMPLICATED_ORDER)
        makeEncryptedMessageFile(allInputs[OUTPUT_PATH], makeComplicatedDecrypt(message, allInputs[PASSWORD_KEY]));
}

void makeOutputFile()
{
    vector<string> allInputs = getInputs();
    if (allInputs[PROGRAM_MODE] == ENCRYPT_ORDER)
        launchEncryptTasks(allInputs);
    else if (allInputs[PROGRAM_MODE] == DECRYPT_ORDER)
        launchDecryptTasks(allInputs);
}
