#!/bin/bash

if command -v clisp &>/dev/null; then
	sudo apt install clisp
fi

cd scripts
clisp auto_intor.cl
mv *.c ../src/autocode/