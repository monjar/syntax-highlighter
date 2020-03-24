package html;

import java.io.*;
import scanner.*;

public class HtmlHandler {
    // singleton instance
    private static HtmlHandler instance = new HtmlHandler();
    // html file
    private static File htmlFile;
    // the html syntax is written in this string then on the file
    private static StringBuilder sb = new StringBuilder();
    // the size of each tab in html file
    private static final int TabSize = 8;
    // ide background color
    private static final String backGroundColor = Style.Color.WHITE;

    public static HtmlHandler getInstance() {
        return instance;
    }

    private HtmlHandler() {

    }

    public void clear(){
        sb = new StringBuilder();
    }

    // creating the file and the directory
    public void initializeFile(String fileName) {

        File dir = new File("src/tests/outputs");
        htmlFile = new File("src/tests/outputs/" + fileName + ".html");
        try {
            boolean mkdirResult = dir.mkdirs();
            boolean createFileResult = htmlFile.createNewFile();
            if (!mkdirResult | !createFileResult)
                System.out.println("Old html file replaced with new one!");
            putHeader();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // writing the string builders content on th e html file
    public void write() {
        sb.append("\n\t\t</p>\n\t</body>\n</html>");
        String content = sb.toString();
        try {
            OutputStream os = new FileOutputStream(htmlFile.getAbsoluteFile());
            OutputStreamWriter writer = new OutputStreamWriter(os);
            writer.write(content);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // scans each scanner symbol and puts the correct style in html <span> tag
    public void highlightSyntax(Symbol sym) {
        switch (sym.getType()) {
            case KeyID:
                putSymbol(sb, sym, Style.Color.BLUE, Style.Text.BOLD);
                break;
            case LITCHAR:
            case LITSTRING:
                putSymbol(sb, sym, Style.Color.GREEN);
                break;
            case SPCHAR:
            case SPSTR:
                putSymbol(sb, sym, Style.Color.GREEN, Style.Text.ITALIC);
                break;
            case INTEGERNUMBER:
                putSymbol(sb, sym, Style.Color.ORANGE);
                break;
            case REALNUMBER:
                putSymbol(sb, sym, Style.Color.ORANGE, Style.Text.ITALIC);
                break;
            case ID:
                putSymbol(sb, sym, Style.Color.VIOLET);
                break;
            case COMMENT:
                putSymbol(sb, sym, Style.Color.GRAY);
                break;
            case TAB:
                putTab(sym);
                break;
            case SPACE:
                putSpace(sym);
                break;
            case NEXTLINE:
                sb.append("<br>\n");
                break;
            case LIBRARY:
                putLibrary(sym);
                break;
            case EOFType:
                break;
            default:
                putSymbol(sb, sym, Style.Color.BLACK);
                break;
        }


    }

    private void putLibrary(Symbol sym) {
        String libStr = sym.getValue().replace("<", "&lt").replace(">", "&gt");
        sym.setValue(libStr);
        putSymbol(sb, sym, Style.Color.RED);
    }

    private void putSpace(Symbol sym) {
        sym.setValue("&nbsp;");
        putSymbol(sb, sym, backGroundColor);
    }

    private void putTab(Symbol sym) {
        StringBuilder tab = new StringBuilder();
        for (int i = 0; i < TabSize; i++)
            tab.append("&nbsp;");
        sym.setValue(tab.toString());
        putSymbol(sb, sym, backGroundColor);
    }

    // putting header and title in string builder
    private void putHeader() {
        sb.append("<html>\n\t<head>\n\t\t<title>\n\t\t</title>\n\t</head>");
        sb.append("\n\t<body bgcolor ='").append(backGroundColor).append("'>\n\t\t<p>\n");
    }

    // creates <span> tag for each symbol
    private void putSymbol(StringBuilder sb, Symbol sym, String color) {
        String content = "<span style='color:" + color + ";'>" + sym.getValue() + "</span>";
        sb.append(content);
    }

    // creates <span> tag for each symbol with italic or bold style
    private void putSymbol(StringBuilder sb, Symbol sym, String color, String textStyle) {
        String content = "<" + textStyle + " style='color:" + color + ";'>" + sym.getValue() + "</" + textStyle + ">";
        sb.append(content);
    }

}
