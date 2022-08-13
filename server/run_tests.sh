#!/bin/bash

echo ">----------------- INICIANDO TESTES ------------------<"
cd tests
echo ""
echo ">--------- Testando controllers..."
cd controllers ; go test -v ; cd ..
echo ""
echo ">--------- Testando repositorios..."
cd repositories ; go test -v ; cd ..
cd ..
echo ">----------------- TESTES FINALIZADOS ------------------<"