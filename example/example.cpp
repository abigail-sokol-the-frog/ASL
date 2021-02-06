#include "link.h"

int main(){
    string prompt = "What's your name: ";
    string msg = "Nice to meet you %s!\n";
    print(prompt);
    printf(msg, getInput());
    return 0;
}
