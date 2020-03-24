package scanner;

import java.util.InputMismatchException;

public class SyntaxErrorException extends InputMismatchException {


    SyntaxErrorException(int row, int col) {
        super("Syntax Error! line: " + (row + 1) + " column: " + (col + 1));
    }

    @Override
    public String toString() {
        return this.getMessage();
    }
}
