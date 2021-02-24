#ifndef LINK_H
#define LINK_H

using string = char[];

extern "C" void printf(string str, ...);
extern "C" void printlen(string str, long len);
extern "C" void print(string str);
extern "C" void printHex(void* data);
extern "C" void printNum(long data);
extern "C" void newline();
extern "C" char* getInput();

extern "C" long stoi(string str, long base);
extern "C" long strfind(string str, char c);
extern "C" long strlen(string str);
extern "C" long strcomp(string A, string B);
extern "C" string strcat(string A, string B);
extern "C" void strcopy(char* A, char* B);

extern "C" void memcopy(void* loc, long length, char val);
extern "C" long memlen(void* start);
extern "C" void* alloc(short size);
extern "C" void free(void* block);

extern "C" long pow(long A, long B);

extern "C" void sleep(long seconds);
extern "C" void exit(long code);

#endif
