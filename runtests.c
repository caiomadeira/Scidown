/// Caio Madeira
/// Compilated with Visual Studio 2022 Developer Command Prompt v17.8.5

#include<windows.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define _CRT_NO_SECURE_WARNINGS
#define RUN_COMMAND "lua tests.lua"

int main(void) 
{
    char command1[4] = "lua";
    char filename[50] = "tests.lua";
    char result[100];

    SetConsoleTitleA("Scidown - Lua Testing");
    puts("**********************************************************************");
    puts("** LUA TESTING - SCIDOWN");
    puts("** by caio madeira (github.com/caiomadeira)");
    puts("**********************************************************************\n\n\n");

    Sleep(1000);
    strcpy(result, command1);
    strcat(result, " ");
    strcat(result, filename);
    strcat(result, " ");
    strcat(result, "-v");

    system(result);

    Sleep(1000);
    system("pause");
    return 0;
}