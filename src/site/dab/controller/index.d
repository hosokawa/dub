module dab.controller.index;

import dab.util;
import dab.mvc;

class Index : Controller {
    override char[] execute(ref ExecInfo ei) {
        ei.setContentType("text/html");
        if (ei.request.getInt("count") > 0) {
            return "dab.view.result.DTemplate";
        }
        return "dab.view.index.DTemplate";
    }
}
