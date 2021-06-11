# push_swap_tester
Script to test Push Swap project

<img src="screenshot.png" width="75%">

### Usage

```
bash tester.sh
```

You can change the variable 'NUM_TESTS' which determines how many times the program will be run to calculate the averages of operations, using the flag -n <NUMBER>

You can also choose to test only a specific part of the program using the flag -f, as follows:
* -f erro : Error management
* -f sorted: Check if sorted lists do nothing
* -f simple: Lists of size 3 and 5
* -f middle: Lists of size 100
* -f advanced: Lists of size 500
