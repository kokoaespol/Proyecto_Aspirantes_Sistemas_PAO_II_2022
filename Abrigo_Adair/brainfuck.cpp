#include <iostream>
#include <stdlib.h>
#include <unistd.h>

#include <fstream>
#include <sys/stat.h>
#include <cstdlib>
using namespace std;

//Class tokenType - List the valid characters that braninkfuck uses
enum tokenType    {
    LT,
    RT,
    PLUS,
    MINUS,
    DOT,
    COMMA,
    LBRACE,
    RBRACE,
    EoF, 
    ILEGAL
};


class Token{
    public:
        char input;
        tokenType tk;
        Token( tokenType tk, char _input){
            this->input = _input;
            if (&_input == ">"){         
                this->tk = LT;
            }
            else if (&_input == "<"){    
                this->tk = RT;
            }
            else if (&_input == "+"){    
                this->tk = PLUS;
            }
            else if (&_input == "-"){    
                this->tk = MINUS;
            }
            else if (&_input == ","){    
                this->tk = COMMA;
            }
            else if (&_input == "."){    
                this->tk = DOT;
            }
            else if (&_input == "["){    
                this->tk = LBRACE;
            }
            else if (&_input == "\0"){    
                this->tk = EoF;
            }
            else{    
                this->tk = ILEGAL;
            }
            
        }
};

class Brainfuck{
    public:
        char data[200];
        char *pointer;
        const char *character;

        Brainfuck(const char c[]){
            pointer = data;
            character = c;
        }

        void evaluate(){
            while(*character){
                switch (*character){
                    case '>':
                        pointer++;
                        break;
                    case '<':
                        pointer--;
                        break;
                    case '+':
                        (*pointer)++;
                        break;
                    case '-':
                        (*pointer)--;
                        break;
                    case '.':
                        std::cout << *pointer;
                        break;
                    case ',':
                        std::cin >> *pointer;
                        break;
                    case '[':{
                        int cont = 1;
                        if(*pointer == '\0'){
                            do {
                                character++;
                                if      (*character == '[') cont++;
                                else if (*character == ']') cont--;
                            } while ( cont != 0 );
                        }
                    }                         
                     break;


                    case ']':{
                        int cont = 0;
                        if(*pointer == '\0'){
                            do {
                                if      (*character == '[') cont++;
                                else if (*character == ']') cont--;
                                character--;
                            } while ( cont != 0 );
                        }
                    }
                    break;
                }
                character++;
            }
        }


};


int main(){
    cout << "Bienvenido" << endl;
    char input[100];  
    cin >> input;
    Brainfuck st = Brainfuck(input);
    st.evaluate();
    system("pause");
    return 0;
};