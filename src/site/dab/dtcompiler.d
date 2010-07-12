module d.compile;

import com.fastcgi.fcgi_stdio;

enum Type { CHAR, ENTER, LEAVE };
struct Token {
    Type type;
    char[] val;
}

enum Mode { TOP, OUTER, INNER };

Token[] lexical(char[] input) {
    Token[] tokens;
    input ~= "\0\0";
    for (int i = 0; i < input.length - 2; i++) {
        if (input[i..i+3] == "<?d") {
            tokens ~= Token(Type.ENTER, "<?d");
            i += 2;
            continue;
        } else if (input[i..i+2] == "?>") {
            tokens ~= Token(Type.LEAVE, "?>");
            i += 1;
            continue;
        } else {
            tokens ~= Token(Type.CHAR, input[i..i+1]);
        }
    }
    return tokens;
}

char[] analyze(Token[] tokens) {
    char[] s;
    Mode mode = Mode.TOP;
    foreach (Token t; tokens) {
        switch (mode) {
        case Mode.TOP:
            switch (t.type) {
            case Type.CHAR:
                s ~= "res ~= `" ~ t.val;
                mode = Mode.OUTER;
                break;
            case Type.ENTER:
                mode = Mode.INNER;
                break;
            case Type.LEAVE:
                return "Syntax Error in " ~ t.val;
            }
            break;
        case Mode.OUTER:
            switch (t.type) {
            case Type.CHAR:
                s ~= t.val;
                break;
            case Type.ENTER:
                s ~= "`;";
                mode = Mode.INNER;
                break;
            case Type.LEAVE:
                return "Syntax Error in " ~ t.val;
            }
            break;
        case Mode.INNER:
            switch (t.type) {
            case Type.CHAR:
                s ~= t.val;
                break;
            case Type.ENTER:
                return "Syntax Error in " ~ t.val;
            case Type.LEAVE:
                s ~= "res ~= `";
                mode = Mode.OUTER;
                break;
            }
            break;
        }
    }
    if (mode == Mode.OUTER) {
        s ~= "`;";
    }
    return s;
}


/+ template.src
module %module%;

import com.fastcgi.fcgi_stdio;
import tango.io.Stdout;
import tango.text.convert.Integer;
import tango.text.Text;

import dab.dtcompiler;
import dab.mvc;
import dab.request;

class DTemplate : View {
    override void execute(ref ExecInfo ei) {
        Request req = ei.request;
	Text!(char) res = new Text!(char);
        // printf("%.*s", analyze(lexical(import("%.dt%"))));
        mixin(analyze(lexical(import("%.dt%"))));
        ei.setContents(res);
        super.execute(ei);
    }
}
template.src +/
