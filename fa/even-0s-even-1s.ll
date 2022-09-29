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

%s ODD_ZERO ODD_ONE ODD_BOTH
     
EOLN    \r\n|\n\r|\n|\r

%%

%{

%}

<INITIAL>{EOLN} { report(true); }
<ODD_ZERO>{EOLN} { report(false); }
<ODD_ONE>{EOLN} { report(false); }
<ODD_BOTH>{EOLN} { report(true); }

<INITIAL>"0"    { BEGIN(ODD_ZERO); }
<INITIAL>"1"    { BEGIN(ODD_ONE); }

<ODD_ZERO>"0"       { BEGIN(INITIAL); }
<ODD_ZERO>"1"       { BEGIN(ODD_BOTH); }

<ODD_ONE>"0"  { BEGIN(ODD_BOTH); }
<ODD_ONE>"1"  { BEGIN(INITIAL); }

<ODD_BOTH>"0" { BEGIN(ODD_ONE); }
<ODD_BOTH>"1" { BEGIN(ODD_ZERO); }


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
