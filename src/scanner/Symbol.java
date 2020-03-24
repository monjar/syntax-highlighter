package scanner;

public class Symbol {
    private String value;
    private TokenType tp;

    Symbol(TokenType tp) {
        this.tp = tp;
    }

    Symbol(TokenType tp, String value) {
        this.tp = tp;
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }

    public TokenType getType() {
        return this.tp;
    }

    public void setValue(String value) {
        this.value = value;
    }


}

