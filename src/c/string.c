#include <string.h>

char* AddColorToStr(char* str,char c){
    int length= GetStrLength(str);
    char* r="";
    for(int i=0; i<length;i++){
        int j= i*2;
        int g= i*2+1;
        r[j]= str[i];
        r[g]= c;
    }
    return r;
}

int GetStrLength(char* str){
    for(int i=0; i>=0;i++){
        if(str[i]=='\0'){
            return i+1;
        }
    }
    return -1;
}