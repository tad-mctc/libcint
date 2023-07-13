#!/bin/bash

# exit whole script and not only the current command (CTRL+C)
trap "echo Exited!; exit;" SIGINT SIGTERM

if ! command -v clisp &>/dev/null; then
	sudo apt install clisp
fi

cd scripts
clisp auto_intor.cl
mv *.c ../src/autocode/