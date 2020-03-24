import html.HtmlHandler;
import scanner.MyScanner;
import scanner.Symbol;
import scanner.SyntaxErrorException;
import scanner.TokenType;

import java.io.*;

class Main {

    public static void main(String[] args) throws IOException {


        File dir = new File("src/tests/testFiles");
        File[] directoryFiles = dir.listFiles();
        if (directoryFiles != null) {
            for (File htmlFile : directoryFiles)
                AnalyzeCLikeFile(htmlFile);
        }


    }

    private static void AnalyzeCLikeFile(File htmlFile) throws IOException {
        // initializing the test file
        FileReader fileReader = new FileReader(htmlFile);
        // invoking the class that our .flex file generated
        MyScanner scanner = new MyScanner(fileReader);
        // htmlHandler is a singleton that computes the return value of our scanner and prints highlighted text on our html file
        HtmlHandler.getInstance().initializeFile(getFileName(htmlFile) + "_Highlighted");
        // getting input from scanner until EOF
        tryGettingInputFromScanner(htmlFile, scanner);
        // Write html string to file
        HtmlHandler.getInstance().write();
        // clear html string
        HtmlHandler.getInstance().clear();
    }

    private static void tryGettingInputFromScanner(File htmlFile, MyScanner yylex) throws IOException {
        try {
            getInputFromScanner(yylex);
        } catch (SyntaxErrorException see) {
            System.out.println("Error in file: " + htmlFile.getName() + "\n" + see.getMessage());
        }
    }

    private static void getInputFromScanner(MyScanner yylex) throws IOException {
        while (true) {
            // getting next symbol
            Symbol sym = yylex.nextInput();
            // giving the symbol to htmlHandler
            HtmlHandler.getInstance().highlightSyntax(sym);
            if (sym.getType() == TokenType.EOFType)
                break;
        }
    }

    private static String getFileName(File htmlFile) {
        return htmlFile.getName().replace(".clike", "");
    }

}