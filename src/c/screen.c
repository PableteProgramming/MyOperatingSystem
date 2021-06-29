#include <screen.h>
#include <string.h>

void printc(char* str, char c){
    char* consoleBuffer= (char*)0xb8000;
    char* cstr= AddColorToStr(str,c);
    int length= GetStrLength(cstr);
    for(int i=0; i<length;i++){
        consoleBuffer[i]= cstr[i];
    }
}

void print(char* str){
    char* consoleBuffer= (char*)0xb8000;
    char* cstr= AddColorToStr(str,0x0f);
    int length= GetStrLength(cstr);
    for(int i=0; i<length;i++){
        consoleBuffer[i]= cstr[i];
    }
}