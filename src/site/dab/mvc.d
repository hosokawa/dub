module dab.mvc;

import com.fastcgi.fcgi_stdio;
import tango.text.Text;

import dab.request;
import dab.exceptions;
import dab.config;

class Application {
    abstract void run(ref SiteConfig sc);
}

class View {
    void execute(ref ExecInfo ei) {
        printf("%.*s\r\n\r\n", ei.contentType);
        printf("%.*s", ei.contents);
    }
}

class Model {
}

class Controller {
    abstract char[] execute(ref ExecInfo ei);
}

class Mapper {
    abstract char[] getClassName();
    abstract void analyzeRequest(Request req);
}

enum ExecState {
    NOT_PROCESSED,
    CONTENTS,
    FORWARD,
    REDIRECT
}

class ExecInfo {
    private Request req;
    private ExecState _status;
    private char[] content_type; // CONTENTS
    private Text!(char) con;
    private char[] forward_name; // FORWARD
    private char[] redirect_to;  // REDIRECT
    private DabException ex;     // Exception

    this(Request req) {
        this.req = req;
        this._status = ExecState.NOT_PROCESSED;
    }

    void setContentType(char[] content_type, char[] charset = null) {
        if (charset is null) {
            charset = "UTF-8";
        }
        this.content_type = "Content-Type: " ~ content_type ~"; charset=" ~ charset;
    }

    Request request() {
        return req;
    }

    char[] contents() {
        return con.selection;
    }

    void setContents(Text!(char) con) {
        this.con= con;
    }

    ExecState status() {
        return _status;
    }

    DabException exception() {
        return ex;
    }

    void exception(DabException ex) {
        this.ex = ex;
    }

    char[] contentType() {
        return content_type;
    }
}
