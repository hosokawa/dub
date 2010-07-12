module dab.request;

import com.fastcgi.fcgi_stdio;

import tango.stdc.stringz;
import tango.text.Search;
import tango.text.Regex;
import tango.text.convert.Integer;

import dab.config;

class Request {
    private SiteConfig sc;
    private char[][char[]] env;
    private char[][][char[]] get;
    private char[][][char[]] post;

    this(SiteConfig sc) {
        this.sc = sc;
        setEnvironmentVariables();
        setGetParams();
        setPostParams();
    }

    private void setEnvironmentVariables() {
        auto e = new Environment();
        env = e.all;
    }

    private void setGetParams() {
        if ("QUERY_STRING" in env) {
            foreach (u; Regex("[&;]").split(env["QUERY_STRING"])) {
                foreach (m; Regex("=").search(u)) {
                    get[m.pre] ~= m.post;
                }
            }
        }
    }

    private void setPostParams() {
        if ("CONTENT_LENGTH" in env) {
            long len = toLong(env["CONTENT_LENGTH"]);
            if (len > 0) {
                char[] post_data = [];
                for (long i = 0; i < len; i++) {
                    int ch = getchar();
                    if (ch < 0) {
                        break;
                    }
                    post_data ~= cast(char)ch;
                }
                foreach (u; Regex("[&;]").split(post_data)) {
                    foreach (m; Regex("=").search(u)) {
                        post[m.pre] ~= m.post;
                    }
                }
            }
        }
    }

    SiteConfig SITE_CONFIG() {
        return sc;
    }

    char[][char[]] ENV() {
        return env;
    }

    char[][][char[]] GET() {
        return get;
    }

    char[][][char[]] POST() {
        return post;
    }

    char[][][char[]] SESSION() {
        return null;
    }

    char[] getString(char[] key) {
        foreach (vals; [POST, GET]) {
            if (key in vals) {
                return vals[key][0];
            }
        }
    }

    int getInt(char[] key) {
        foreach (vals; [POST, GET]) {
            if (key in vals) {
                return toInt(vals[key][0]);
            }
        }
        return 0;
    }
}


extern (C) {
    extern char** environ;
}

class Environment {
    private char[][char[]] env;

    this() {
        for (int i = 0; environ[i] != null; i++) {
            char[] s = fromStringz(environ[i]);
            auto match = search("=");
            int f = match.forward(s);
            if (f != -1) {
                char[] key = s[0..f];
                char[] value = s[f + 1..$];
                env[key] = value;
            }
        }
    }

    char[][char[]] all() {
        return env;
    }
}
