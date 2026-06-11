#!/bin/sh

./save_and_restore_variables.py save
eww reload
./save_and_restore_variables.py restore
