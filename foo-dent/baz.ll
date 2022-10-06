%{
    #include <string>
    #include <vector>
    #include <iostream>
    #include <fstream>
    #include "baz.hh"

    #undef YY_DECL
    #define YY_DECL int baz::Lexer::yylex(void)

    #define YY_USER_ACTION advance_location(yytext);
    
    #define yyterminate() return 0
    #define YY_NO_UNISTD_H

    
    void baz::Lexer::advance_location(std::string txt) {
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
                    ++indent;
                }
            }
        }
    }
    
%}

%option debug
%option nodefault
%option noyywrap
%option yyclass="baz::Lexer"
%option c++

EOLN    \r\n|\n\r|\n|\r

%s ERROR
    
%%

%{

%}

$" "*baz { 
            int prev_indent = indents.size() == 0 ? 0 : indents.top();

            if (indent > prev_indent) {
                indents.push(indent);
                unput('z');
                unput('a');
                unput('b');
                return Token_INDENT;
                
            } else if (indent < prev_indent) {
                indents.pop();
                prev_indent = indents.size() == 0 ? 0 : indents.top();

                if (indent < prev_indent) {
                    yyless(0);
                } else {
                    unput('z');
                    unput('a');
                    unput('b');
                }
                
                return Token_DEDENT;
            } else {
                unput('z');
                unput('a');
                unput('b');
            }
          }
{EOLN}    { 
            unput('$'); 
            return Token_EOLN; 
          }
baz       { return Token_BAZ; }
" "       { }
[$]       { }
<<EOF>>   { return Token_EOF;  }
. {
    std::string txt { yytext };
    std::cerr << "Unexpected \"" << txt << "\" in input." << std::endl;
    return -1;
}
    
%%

int main(int argc, char** argv) {
    std::string src_name { argv[1] };
    std::ifstream ins { src_name };
    baz::Lexer lexer { &ins };

    std::vector<std::string> types {"EOF","BAZ","EOLN","INDENT","DEDENT"};
    int token_type;
    while ((token_type = lexer.yylex()) != Token_EOF) {
        if (token_type < 0) {
            exit(-1);
        }
        std::cout << types[token_type] << " ";
        if (types[token_type] == "EOLN") std::cout << std::endl;
    } 
    return 0;
}
