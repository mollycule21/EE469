#!/usr/bin/env bash

# This bash script is used to generate a memory file to test instruction memory
INSTRUCTION_SIZE=32
NUMBER_OF_INSTRUCTIONS=1024

# first remove the previous file
rm rv32i-instruction.txt

for ((i = 0; i < $NUMBER_OF_INSTRUCTIONS; ++i))
do
	(bc <<< "obase=2;$i") >> temp.txt
done

(printf "%.32d\n" $(<temp.txt)) >> rv32i-instruction.txt
rm temp.txt
