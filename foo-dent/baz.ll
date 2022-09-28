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

    enum token_type_t {
        Token_EOF = 0,
        Token_BAZ,
        Token_EOLN,
        Token_INDENT,
        Token_DEDENT
    };
    
    void baz::Lexer::advance_location(std::string txt) {
        start_line = line;
        start_column = column;
        for (char c: txt) {
            if (c == '\n') {
                line++;
                column = 1;
            } else {
                column++;
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

{EOLN}    { return Token_EOLN; }
baz       { return Token_BAZ;  }
" "       { }
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
        std::cout << types[token_type] << std::endl;
    } 
    return 0;
}
