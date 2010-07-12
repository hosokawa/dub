module index;

import com.fastcgi.fcgi_stdio;
import tango.core.Memory;

import dab.util;
import dab.config;
import dab.mvc;

void main() {
    SiteConfig sc = new SiteConfig();
    Application application = cast(Application)factory(sc.application);
    while (FCGI_Accept() >= 0) {
        try {
            if (application is null) {
                throw new Exception("ApplicationNotFound: " ~ sc.application);
            } else {
                application.run(sc);
            }
        } catch (Exception e) {
            printf("Content-Type: text/plain; charset=UTF-8\r\n\r\n");
            printf("%.*s(%d): %.*s\r\n", e.file, e.line, e.msg);
        }
    }
}
