@echo off
echo Updating submodules...
git submodule update --init --jobs=16
echo Generating project files...
call "tools/premake5.exe" vs2022 --file="lua/pants.lua" --example-mod