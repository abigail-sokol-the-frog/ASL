# Assembly Standered Library

A x86_64 assembly library that impliments most standered c librarys

Library calling convention:
    
    registers rdi, rsi, rdx, rcx, r8, and r9 in that order
    registers xmm$ from 0 - 7 in asending order for floating point numbers
    return value is in rax, or floating point return in xmm0
    strings are null terminated char pointers
    All functions leave stack and non-rax registers unchanged unless stated otherwise

I/O Functions:
    
    void printf: 
        save a string in rdi
        save next values in registers in order
        formating options:
            %s will be replaced by a string stored at rsi
            %h will be replaced by the hex value stored in rsi
            %n will be replaced by the 16bit values stored in rsi
    
    void printlen:
        save a string in rdi
        store a length in rsi
        print length number of characters of rdi

    void print:
        print the string stored in rdi to the console
    
    void printHex:
        store a hex value in rdi
        formats the string and prints input
    
    void printNum:
        store a 16bit value in rdi
        prints the base 10 value

    void newline:
        prints a new line
    
    rax getInput:
        returns a pointer to the inputed string in rax
        the max length of the input is 100 characters

String methods:
    
    RDI val:
        set dil to a character
        converts from ascii to binary | Returns in the rdi register! |
        note that if the character is not [0-9, A-Z, a-z] then it returns itself

    rax stoi:
        set rdi to a string
        set rsi to the base
        returns the number that the string points to

    rax strfind:
        set rdi to a string
        set rsi (sil) to a character value
        returns the index of the character, or -1 if the index doesn't exist
    
    rax strlen:
        set rdi to a string
        returns the length of the string
    
    rax strcmp:
        set rdi to a string
        set rsi to a string
        returns -1 if they are equal, and returns 0 if they are not
    
    rax strcat:
        set rdi to a string
        set rsi to a string
        returns a pointer to a new string with a value of rdi + rsi
    
    void strcopy:
        set rdi to a string pointer
        set rsi to a string pointer
        saves string rsi to string rdi

Memory functions:
    
    void memcopy:
        set rdi to the start of the block of memory you want to set
        set rsi to the size of the memory block
        set rdx (dl) to the value you want to set the block of memory to
    
    rax memlen:
        set rdi to a pointer to the start of the block
        returns the length till a non-null value is found
    
    rax alloc:
        set rdi to a value less than or equal to 0xFFFD and greater than 0
        returns a pointer to a memory segment in rax
    
    void free:
        let rdi be a pointer to a block of memory that was created using alloc
        unsets that memory (do not use the pointer afterwards)

Math functions: 
    
    rax pow:
        set rdi and rsi to a number
        returns rdi ^ rsi (note that overflow may happen, and is not fixed)

Other:
    
    void sleep:
        put number of seconds in rdi
        sleeps for the length of time
    
    void exit:
        put exit code in rdi
        ends program
    
    rax getArg:
        set rdi to the argument number you want to get
        will returns that argument in rax, or return ~0 if there are no more arguments
        in general, I would recommend not using this function for anything

Data segment items:
    
    hexstr, hex, endline, mem_start, and mem_end: DON'T USE UNLESS YOU KNOW WHY
    error is a pointer to a string "Exit with error\n\0" and could be useful
