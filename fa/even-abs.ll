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

%s EVEN_A ODD ODD_A
     
EOLN    \r\n|\n\r|\n|\r

%%

%{

%}


<INITIAL>{EOLN} { report(true); }
<EVEN_A>{EOLN} { report(true); }
<ODD>{EOLN} { report(false); }
<ODD_A>{EOLN} { report(false); }

<INITIAL>"a"    { BEGIN(EVEN_A); }
<INITIAL>"b"    { BEGIN(INITIAL); }
<INITIAL>"c"    { BEGIN(INITIAL); }

<EVEN_A>"a"    { BEGIN(EVEN_A); }
<EVEN_A>"b"    { BEGIN(ODD); }
<EVEN_A>"c"    { BEGIN(INITIAL); }

<ODD>"a"    { BEGIN(ODD_A); }
<ODD>"b"    { BEGIN(ODD); }
<ODD>"c"    { BEGIN(ODD); }

<ODD_A>"a"    { BEGIN(ODD_A); }
<ODD_A>"b"    { BEGIN(INITIAL); }
<ODD_A>"c"    { BEGIN(ODD); }


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
