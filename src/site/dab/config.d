import com.fastcgi.fcgi_stdio;
import tango.text.xml.Document;
import tango.text.xml.DocPrinter;
import tango.io.stream.TextFile;

class SiteConfig {
    Document!(char) doc;

    this() {
        doc = new Document!(char);
        scope auto stream = new TextFileInput("./conf/site.conf");
        char[] readed;
        foreach (line; stream) {
            readed ~= line;
        }
        doc.parse(readed);
    }

    char[] mapper() {
        foreach (node; doc.query["site"]["class"]["url_map"]) {
            return node.value;
        }
        return null;
    }

    char[] application() {
        foreach (node; doc.query["site"]["class"]["application"]) {
            return node.value;
        }
        return null;
    }

    char[] exception() {
        foreach (node; doc.query["site"]["class"]["exception"]) {
            return node.value;
        }
        return null;
    }

    char[] htdocsPath() {
        foreach (node; doc.query["site"]["path"]["htdocs"]) {
            return node.value;
        }
        return null;
    }

    char[] privatePath() {
        foreach (node; doc.query["site"]["path"]["private"]) {
            return node.value;
        }
        return null;
    }
}
