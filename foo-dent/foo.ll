%{
    #include <string>
    #include <iostream>
    #include <fstream>
    #include "foo.hh"

    #undef YY_DECL
    #define YY_DECL int foo::Lexer::yylex(void)

    #define YY_USER_ACTION advance_location(yytext);

    #define DEBUG 0
    
    #define yyterminate() return 0
    #define YY_NO_UNISTD_H

    void foo::Lexer::advance_location(std::string txt) {
        start_line = line;
        start_column = column;
        indent = 0;
        for (char c: txt) {
            if (c == '\n') {
                line++;
                column = 1;
            } else {
                column++;
                if (c == ' ') {
                    indent++;
                }
            }
        }
    }
    
    void foo::Lexer::do_foo(void) {
        if (DEBUG) {
            std::cout << "FOO[" << start_line << "," << start_column << "] " << std::endl;
        } else {
            std::cout << "FOO ";
        }
    }

    int foo::Lexer::push_indent(void) {

        int prev_indent = indents.size() == 0 ? 0 : indents.top();

        if (indent > prev_indent) {
            indents.push(indent);
            if (DEBUG) {
                std::cout << "INDENT[" << start_line << "," << start_column << "] " << std::endl;
            } else {
                std::cout << "\nINDENT ";
            }
            
        } else {
            while (indent < prev_indent) {
                if (DEBUG) {
                    std::cout << "DEDENT[" << start_line << "," << start_column << "] " << std::endl;
                } else {
                    std::cout << "DEDENT ";
                }
                indents.pop();
                prev_indent = indents.top();

                if (indent > prev_indent) {
                    return 1;
                }
            }
        } 

        return 0;
    }

%}

%option debug
%option nodefault
%option noyywrap
%option yyclass="foo::Lexer"
%option c++

EOLN    \r\n|\n\r|\n|\r

%s ERROR
    
%%

%{

%}

foo{EOLN} { do_foo(); }

" "*       { if (push_indent()) {
                std::cerr << "\nERROR: Incorrect indentation." << std::endl;
                return 0; 
             }
           }
        
<<EOF>>   { return 0; }

. {
    std::string txt { yytext };
    std::cerr << "Unexpected \"" << txt << "\" in input." << std::endl;
    return -1;
}
    
%%

int main(int argc, char** argv) {
    
    std::string src_name { argv[1] };
    std::ifstream ins { src_name };
    foo::Lexer lexer { &ins };
    return lexer.yylex();
}
