%{
    #include <string>
    #include <iostream>
    #include <fstream>
    #include "balanced.hh"

    #undef YY_DECL
    #define YY_DECL int balanced::Lexer::yylex(void)

    #define YY_USER_ACTION process(yytext);
    
    #define yyterminate() return 0
    #define YY_NO_UNISTD_H

    std::string remove_EOLNs(std::string txt) {
        int ending = txt.length();
        while (txt[ending-1] == '\r' || txt[ending-1] == '\n') {
            ending--;
        }
        return txt.substr(0,ending);
    }
    
    void balanced::Lexer::process(std::string txt) {
        current = current + txt;
    }
    
    void balanced::Lexer::report(bool accepted) {
        std::cout << remove_EOLNs(current) << " ";
        if (accepted && left_open == 0) {
            std::cout << "YES";
        } else {   
            std::cout << "NO";
        }
        std::cout << std::endl;
        current = "";
        left_open = 0;
        BEGIN(0);
    }
%}

%option debug
%option nodefault
%option noyywrap
%option yyclass="Lexer"
%option c++

%s ZERO FIRSTONE SECONDONE
     
EOLN    \r\n|\n\r|\n|\r

%%

%{

%}

<INITIAL>{EOLN} { report(false); }
<ZERO>{EOLN} { report(false); }
<FIRSTONE>{EOLN} { report(false); }
<SECONDONE>{EOLN} { report(true); }

<INITIAL>"0"    { BEGIN(ZERO); }
<INITIAL>"1"    { BEGIN(INITIAL); }

<ZERO>"0"       { BEGIN(ZERO); }
<ZERO>"1"       { BEGIN(FIRSTONE); }

<FIRSTONE>"0"  { BEGIN(FIRSTONE); }
<FIRSTONE>"1"  { BEGIN(SECONDONE); }

<SECONDONE>"0" { BEGIN(ZERO); }
<SECONDONE>"1" { BEGIN(INITIAL); }


<<EOF>> {
    return 0;
}

. {
    std::string txt { yytext };
    std::cerr << "Unexpected \"" << txt << "\" in input." << std::endl;
    return -1;
}
    
%%

int main(int argc, char** argv) {
    std::string src_name { argv[1] };
    std::ifstream ins { src_name };
    balanced::Lexer lexer { &ins };
    return lexer.yylex();
}
