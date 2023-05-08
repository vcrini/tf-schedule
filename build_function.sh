#!/usr/bin/env bash
FUNCTION=function.zip
cd deploy_function/package/ || exit
zip -r9 ../../$FUNCTION .
cd ..
zip -g ../$FUNCTION lambda_function.py
cd ..
