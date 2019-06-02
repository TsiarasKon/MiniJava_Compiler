#!/bin/bash
for filename in *.ll; do
    echo Compiling $filename ...
    /home/users/thp06/clang/clang -Wno-override-module -o "$filename".out "$filename"
    echo Executing "$filename".out ...
    ./"$filename".out
    echo
done

