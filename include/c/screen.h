typedef struct cursor{
    int x;
    int y;
}cursor;


typedef struct screenBuffer{
    cursor curs;
}screenBuffer;

void printc(char*,char);
void print(char*);