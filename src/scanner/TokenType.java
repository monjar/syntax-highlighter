package scanner;

public enum TokenType {

    //identifiers
    ID, KeyID,

    //numbers
    INTEGERNUMBER,
    REALNUMBER,

    //strings and chars
    LITSTRING, LITCHAR,

    //special characters
    SPCHAR,SPSTR,

    //comments
    COMMENT,

    // file format
    EOFType,NEXTLINE,TAB,SPACE,
    // Libraries
    LIBRARY,
    //other kinds of symbols:
    OTHER,
}

