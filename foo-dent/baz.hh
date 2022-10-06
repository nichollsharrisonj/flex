#ifndef _BAZ_HH
#define _BAZ_HH

#include <iostream>

#if ! defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif

enum token_type_t {
    Token_EOF = 0,
    Token_BAZ,
    Token_EOLN,
    Token_INDENT,
    Token_DEDENT
};

namespace baz {
class Lexer : public yyFlexLexer {
public:
    Lexer(std::istream *in) :
        yyFlexLexer { in },
        line { 1 },
        column { 1 },
        start_line { 1 },
        start_column { 1 }
    { }
    virtual ~Lexer() { }
    
    //get rid of override virtual function warning
    using FlexLexer::yylex;

    // Critical method for supporting Bison parsing.
    virtual int yylex(void);
    // YY_DECL defined in .ll
    // Method body created by flex in .cc

private:
    //
    // Token location information. Advanced by advance_location.
    int line, column;
    int start_line, start_column;

    // Indent length
    int indent;
    // Stack of indents
    std::stack<int> indents;
    //
    // Bump the line/column
    void advance_location(std::string txt);
    //
};

} // end baz namespace 


#endif 
