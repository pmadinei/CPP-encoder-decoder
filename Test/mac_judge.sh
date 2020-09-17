#!/usr/bin/env bash

EXE=a.out
COMPILER="g++ -g -std=c++11 -o $EXE"
VERBOSE=true
DEST_DIR="codes"
TEMP_DIR="temp"
JUDGE_DIR="data"
INPUT_NAME="in.txt"
SOL_NAME="sol.txt"
OUT_EXT="out"
CODE_ADDR=$1
MAINCODE_ADDR=$2
TIME_LIM=10s
VERBOSE_DIFF_TOOL="sdiff -sw 60"
# VERBOSE_DIFF_TOOL="/Applications/p4merge.app/Contents/Resources/launchp4merge"

DIFF_TOOL="sdiff -s"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
B="\033[1;4m"
NC="\033[0m"

JUDGE_DIR=$(greadlink -f "$JUDGE_DIR")




if [[ $1 == "--unzip" ]] || [[ $1 == "-u" ]]; then
    if [[ -e "$DEST_DIR" ]]; then
        echo -e "${B}$DEST_DIR${NC} already existed."
        rm -rI "$DEST_DIR"
    fi
    unzip "$2" -d "$DEST_DIR" > /dev/null
    pushd "$DEST_DIR" > /dev/null
    rm -rf *_onlinetext_
    for f in *; do
        mv "$f" "`echo ${f/_*_assignsubmission_file_/}`"
    done
    for f in **/*.zip; do
        pushd "`dirname "$f"`" > /dev/null
        unzip "`basename "$f"`" > /dev/null && rm "`basename "$f"`"
        popd > /dev/null
    done
    rm -rf **/__MACOSX 2> /dev/null
    rm -rf **/.DS_Store 2> /dev/null
    find . -name *.out -delete
    find . -name *.o -delete
    popd > /dev/null
    echo -e "$PWD/${B}$DEST_DIR${NC} ("$(ls "$DEST_DIR" | wc -l)")"

elif [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
    echo "usage:"
    echo -e "\t$0 --help|-h"
    echo -e "\t$0 --unzip|-u <codes_archive_addr>"
    echo -e "\t$0 <code_file>"

elif [[ $1 == "--generate" ]] || [[  $1 == "-g" ]]; then
    if [[ ! -e $TEMP_DIR ]]; then
        mkdir $TEMP_DIR
    fi
    MAINCODE_ADDR=$(greadlink -f "$MAINCODE_ADDR")

    pushd "$TEMP_DIR" > /dev/null
    rm * 2> /dev/null
    passed=0
    failed=0
    compiled=true
    generated="generated"
    echo -e "\n${YELLOW}Compiling...${NC}"
    if ! $COMPILER "$MAINCODE_ADDR"; then
        echo -e "${RED}Compile Error${NC}"
        compiled=false
        generated="notGenerated"
        failed=$(ls -l "$JUDGE_DIR/" | grep "^d" | wc -l)
    else
        echo -e "${GREEN}Compiled!${NC}"
        echo -e "\n${YELLOW}Running...${NC}"
        for test_case in "$JUDGE_DIR/"*"/"; do
            test_case="$(basename "$test_case")"
            input="$JUDGE_DIR/$test_case/$INPUT_NAME"
            sol="$JUDGE_DIR/$test_case/$SOL_NAME"
            output="$JUDGE_DIR/$test_case/sol.txt"
            printf "Testcase $test_case generated \n"

            rm input.txt 2> /dev/null
            rm output.txt 2> /dev/null
            cp "$JUDGE_DIR/$test_case/input.txt" input.txt
            if gtimeout $TIME_LIM ./$EXE < "$input" ; then
                rm "$output" 2> /dev/null
                cp output.txt "$output"

            else
                echo -e "${RED}Timed out${NC}"
                ((failed+=1))
            fi
        done
    fi
    echo -e "\n${YELLOW}Report${NC}"
    printf "Code: $1 (compiled: %b)\n" $compiled
    printf "Code: $1 (testcases: %s)\n" $generated
    popd  > /dev/null

else
    if [[ ! -e $TEMP_DIR ]]; then
        mkdir $TEMP_DIR
    fi

    CODE_ADDR=$(greadlink -f "$CODE_ADDR")

    pushd "$TEMP_DIR" > /dev/null
    rm * 2> /dev/null
    passed=0
    failed=0
    compiled=true
    echo -e "\n${YELLOW}Compiling...${NC}"
    if ! $COMPILER "$CODE_ADDR"; then
        echo -e "${RED}Compile Error${NC}"
        compiled=false
        failed=$(ls -l "$JUDGE_DIR/" | grep "^d" | wc -l)
    else
        echo -e "${GREEN}Compiled!${NC}"
        echo -e "\n${YELLOW}Running...${NC}"
        for test_case in "$JUDGE_DIR/"*"/"; do
            test_case="$(basename "$test_case")"
            input="$JUDGE_DIR/$test_case/$INPUT_NAME"
            sol="$JUDGE_DIR/$test_case/$SOL_NAME"
            output="$JUDGE_DIR/$test_case/output.txt"
            printf "Testcase $test_case: "

            rm input.txt 2> /dev/null
            rm output.txt 2> /dev/null
            cp "$JUDGE_DIR/$test_case/input.txt" input.txt
            if gtimeout $TIME_LIM ./$EXE < "$input" ; then
                rm "$output" 2> /dev/null
                cp output.txt "$output"

                if $DIFF_TOOL "$output" "$sol" > /dev/null; then
                    echo -e "${GREEN}Accepted${NC}"
                    ((passed+=1))
                else
                    echo -e "${RED}Wrong Answer${NC}"
                    if $VERBOSE; then
                        printf "%28s | %28s\n" "< $output" "> $sol"
                        $VERBOSE_DIFF_TOOL "$output" "$sol"
                    fi
                    ((failed+=1))
                fi
                rm "$output"  2> /dev/null
            else
                echo -e "${RED}Timed out${NC}"
                ((failed+=1))
            fi
        done
    fi
    echo -e "\n${YELLOW}Report${NC}"
    printf "Code: $1 (compiled: %b)\n" $compiled
    echo -e "Passed:\t${GREEN}$passed${NC} out of $((passed + failed))"
    echo -e "Failed:\t${RED}$failed${NC} out of $((passed + failed))"
    popd  > /dev/null

fi
