CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
FILEPATH=$(find student-submission -name "ListExamples.java")

if [ -f $FILEPATH ]
then
    echo $FILEPATH
else
    echo 'didnt find file'
    exit
fi

cp $FILEPATH grading-area
cp TestListExamples.java grading-area
cp -r lib grading-area
ls grading-area

cd grading-area

javac -cp ".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar" *.java

if [[ $? -ne 0 ]]
then 
    echo 'ERROR! Failed to Compile'
    exit 0
fi

output=$(java -cp ".:lib/junit-4.13.2.jar:lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples)
#output=$(java -cp ".:lib/junit-4.13.2.jar:lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples)

# Print the output (optional, for debugging)
echo "$output"

# Extract the summary line

OKsummary=$(echo $summary | grep -o "OK ([0-9]* tests)" | grep -o "[0-9]*")
if [[ $? -eq 0 ]]
then 
    echo "GRADE: $OKsummary / $OKsummary"
    exit 0
fi
# Assuming the summary is in a format like "Tests run: X, Failures: Y"
summary=$(echo "$output" | grep -o "Tests run: [0-9]*,  Failures: [0-9]*")



# Extract the number of tests run and the number of failures
tests_run=$(echo $summary | grep -o "Tests run: [0-9]*" | grep -o "[0-9]*")
failures=$(echo $summary | grep -o "Failures: [0-9]*" | grep -o "[0-9]*")

# Calculate the number of successful tests
let "successes = tests_run - failures"

# Display the result
echo "GRADE: $successes / $tests_run"
exit 0

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
