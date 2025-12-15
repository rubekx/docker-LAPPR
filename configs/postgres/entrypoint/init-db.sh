#!/bin/bash
user='laravel'

files=/docker-entrypoint-initdb.d/dump/*

for file in $files
do
    psql -U $user < $file
done