# Judge
This repository consists of a judge for this program.

## How to run?

### Linux Users
At first, you should give judge permissions to run by this command:
```
chmod 755 judge.sh
```
Then you should generate testcases for judge by this command:
```
./judge.sh -g mainCode/main.cpp
```

Now you can judge your code by this command:
```
./judge.sh <your code address>
```
For example we can judge our sample code like this:
```
./judge.sh sampleCode/sample.cpp
```

### Mac OS Users
At first, you should install `coreutils`:
```
brew install coreutils
```

Then you should give judge permissions to run by this command:
```
chmod 755 mac_judge.sh
```
And then, you should generate testcases for judge by this command:
```
./mac_judge.sh -g mainCode/main.cpp
```

Now you can judge your code by this command:
```
./mac_judge.sh <your code address>
```
For example we can judge our sample code like this:
```
./mac_judge.sh sampleCode/sample.cpp
```