

import scanner.SyntaxErrorException;
import scanner.TokenType;
import scanner.Symbol;


%%

%class MyScanner
%unicode

%line
%column
%public

%{

%}

%init{
%init}

%function nextInput

/* user defined regexes */
LIBIRARY=[<]([^\n\r ]*)[>]
LETTER=[A-Za-z]
DIGIT=[0-9]
Ident = {LETTER}({LETTER}|{DIGIT}|_)*
SingleComment =  "//" [^\n\r]*
MultiComment = "/*"
StringLiteral = \"
CharLiteral= \'
IntLiteralDecimal = (0 | [1-9][0-9]*) [L]?
HexDigit = [0-9A-Fa-f]
IntLiteralHex = 0 [xX] 0* {HexDigit}*
RealLiteral = ( ( {Float} {Expo}?  ) | ( {IntLiteralDecimal} {Expo} ) ) [F]?
Expo = [eE] [+-]? [0-9]+
Float = ( ([0-9]+ \. [0-9]*) | (\. [0-9]+) )


%type Symbol
%state STRINGSTATE,CHARSTATE,COMMENTSTATE
%%


<YYINITIAL>{
    /* Detecting a Reserved C KeyWords */
    "auto" {return new Symbol(TokenType.KeyID, "auto");}
    "double" {return new Symbol(TokenType.KeyID, "double");}
    "int" {return new Symbol(TokenType.KeyID, "int");}
    "struct" {return new Symbol(TokenType.KeyID, "struct");}
    "const" {return new Symbol(TokenType.KeyID, "const");}
    "float" {return new Symbol(TokenType.KeyID, "float");}
    "short" {return new Symbol(TokenType.KeyID, "short");}
    "unsigned" {return new Symbol(TokenType.KeyID, "unsigned");}
    "break" {return new Symbol(TokenType.KeyID, "break");}
    "else" {return new Symbol(TokenType.KeyID, "else");}
    "long" {return new Symbol(TokenType.KeyID, "long");}
    "switch" {return new Symbol(TokenType.KeyID, "switch");}
    "continue" {return new Symbol(TokenType.KeyID, "continue");}
    "for" {return new Symbol(TokenType.KeyID, "for");}
    "signed" {return new Symbol(TokenType.KeyID, "signed");}
    "void" {return new Symbol(TokenType.KeyID, "void");}
    "case" {return new Symbol(TokenType.KeyID, "case");}
    "enum" {return new Symbol(TokenType.KeyID, "enum");}
    "register" {return new Symbol(TokenType.KeyID, "register");}
    "typedef" {return new Symbol(TokenType.KeyID, "typedef");}
    "default" {return new Symbol(TokenType.KeyID, "default");}
    "goto" {return new Symbol(TokenType.KeyID,"goto");}
    "sizeof" {return new Symbol(TokenType.KeyID, "sizeof");}
    "volatile" {return new Symbol(TokenType.KeyID, "volatile");}
    "char" {return new Symbol(TokenType.KeyID, "char");}
    "extern" {return new Symbol(TokenType.KeyID, "extern");}
    "return" {return new Symbol(TokenType.KeyID, "return");}
    "union" {return new Symbol(TokenType.KeyID, "union");}
    "do" {return new Symbol(TokenType.KeyID, "do");}
    "if" {return new Symbol(TokenType.KeyID, "if");}
    "static" {return new Symbol(TokenType.KeyID, "static");}
    "while" {return new Symbol(TokenType.KeyID, "while");}
    "#include" {return new Symbol(TokenType.KeyID, "#include");}
    "main" {return new Symbol(TokenType.KeyID, "main");}
    "printf" {return new Symbol(TokenType.KeyID, "printf");}
    "scanf" {return new Symbol(TokenType.KeyID, "scanf");}
    "String" {return new Symbol(TokenType.KeyID, "String");}
    "in" {return new Symbol(TokenType.KeyID, "in");}
    "bool" {return new Symbol(TokenType.KeyID, "bool"); }
    "new" { return new Symbol(TokenType.KeyID, "new"); }
    "true" {return new Symbol(TokenType.KeyID, "true"); }
    "false" {return new Symbol(TokenType.KeyID, "false"); }
    "record" {return new Symbol(TokenType.KeyID,"record");}
    "repeat" {return new Symbol(TokenType.KeyID,"repeat");}
    "until" {return new Symbol(TokenType.KeyID,"until");}
    "function" {return new Symbol(TokenType.KeyID,"function"); }
    "println" { return new Symbol(TokenType.KeyID,"println"); }

    /* Detecting Start of a literal string */

    {StringLiteral} {
        yybegin(STRINGSTATE);
        return new Symbol(TokenType.LITSTRING , "\"");
    }
    /* Detecting Start of a Literal character */
    {CharLiteral} {
        yybegin(CHARSTATE);
        return new Symbol(TokenType.LITCHAR, "\'");
    }
    /* Detecting a literal real number */
    {RealLiteral} {
        return new Symbol(TokenType.REALNUMBER , yytext());
    }

    /* Detecting a literal integer number */
    {IntLiteralDecimal} | {IntLiteralHex} {
        return new Symbol(TokenType.INTEGERNUMBER , yytext());
    }
    /* Detecting an identifier */
    {Ident} {
        return new Symbol(TokenType.ID , yytext());
    }
    {LIBIRARY} {
            return new Symbol(TokenType.LIBRARY , yytext());
        }
    /* Detecting a one line comment */
    {SingleComment}  {
        return new Symbol(TokenType.COMMENT , yytext());
    }
    /* Detecting start of a multi line comment */
    {MultiComment} {
        yybegin(COMMENTSTATE);
        return new Symbol(TokenType.COMMENT , "/*");
    }



    /* text edit formatting */
    \n {
            return new Symbol(TokenType.NEXTLINE);
    }
    [ ] {
            return new Symbol(TokenType.SPACE);
    }
    \t {
        return new Symbol(TokenType.TAB);
    }


    /* other symbols */
    . {
        return new Symbol(TokenType.OTHER , yytext());
    }

}
/* in this state we already saw the first " and we scan untill another " */
<STRINGSTATE>{
    \" { yybegin(YYINITIAL); return new Symbol(TokenType.LITSTRING , "\"");}
    "\\n" { return  new Symbol(TokenType.SPSTR , "\\n");}
    "\\t" { return  new Symbol(TokenType.SPSTR , "\\t");}
    "\\b" { return  new Symbol(TokenType.SPSTR , "\\b");}
    "\\f" { return  new Symbol(TokenType.SPSTR , "\\f");}
    "\\'" { return  new Symbol(TokenType.SPSTR , "\\'");}
    "\\\"" { return  new Symbol(TokenType.SPSTR , "\\\"");}
    "\\r" { return  new Symbol(TokenType.SPSTR , "\\r");}
    [ ] { return new Symbol(TokenType.SPACE);}
    \t {return new Symbol(TokenType.TAB);}
    \n | \\. {throw new SyntaxErrorException(yyline, yycolumn);}
    . {return new Symbol(TokenType.LITSTRING , yytext());}
}

/* in this state we already saw the first ' and we scan one character then ' */
<CHARSTATE>{
        "\\n"\' {yybegin(YYINITIAL);  return  new Symbol(TokenType.SPCHAR , "\\n\'");}
        "\\t"\' {yybegin(YYINITIAL);  return  new Symbol(TokenType.SPCHAR , "\\t\'");}
        "\\b"\' {yybegin(YYINITIAL);  return  new Symbol(TokenType.SPCHAR , "\\b\'");}
        "\\f"\' {yybegin(YYINITIAL);  return  new Symbol(TokenType.SPCHAR , "\\f\'");}
        "\\'"\' {yybegin(YYINITIAL);  return  new Symbol(TokenType.SPCHAR , "\\'\'");}
        "\\\""\' {yybegin(YYINITIAL);  return  new Symbol(TokenType.SPCHAR , "\\\"\'");}
        "\\r"\' {yybegin(YYINITIAL);  return  new Symbol(TokenType.SPCHAR , "\\r\'");}
        \n | \\. {throw new SyntaxErrorException(yyline, yycolumn);}
        [^\n\r\'\\]\' {yybegin(YYINITIAL); return new Symbol(TokenType.LITCHAR , yytext());}
}

/* in this state we already saw the / and * and we scan untill * then / come */
<COMMENTSTATE>{
    "*/" { yybegin(YYINITIAL);  return  new Symbol(TokenType.COMMENT , "*/"); }
    [ ] { return new Symbol(TokenType.SPACE);}
    \t { return new Symbol(TokenType.TAB);}
    \n { return new Symbol(TokenType.NEXTLINE ,""); }
    . { return new Symbol(TokenType.COMMENT , yytext()); }
}
/* end of file state */
<<EOF>>{
    return new Symbol(TokenType.EOFType , "EOF");
}



