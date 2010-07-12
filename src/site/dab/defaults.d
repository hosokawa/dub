module dab.defaults;

import dab.mvc;
import dab.request;
import dab.config;
import dab.util;
import dab.exceptions;

class DefaultMapper : Mapper {
    override void analyzeRequest(Request req) {
    }
    
    override char[] getClassName() {
        return "dab.controller.index.Index";
    }
}

class DefaultApplication : Application {
    override void run(ref SiteConfig sc) {
        scope Request req = new Request(sc);
        ExecInfo ei = new ExecInfo(req);
        try {
            Mapper mapper = cast(Mapper)factory(sc.mapper);
            if (mapper is null) {
                throw new MapperNotFoundException();
            }
            mapper.analyzeRequest(req);
            Controller controller = cast(Controller)factory(mapper.getClassName());
            if (controller is null) {
                throw new ControllerNotFoundException();
            }
            char[] viewName = controller.execute(ei);
            View view = cast(View)factory(viewName);
            if (view is null) {
                throw new ViewNotFoundException();
            }
            view.execute(ei);
        } catch (DabException e) {
            ei.exception = e;
            View view = cast(View)factory(sc.exception);
            if (view is null) {
                throw new Exception("ExceptionViewNotFound: '" ~ sc.exception ~ "'");
            }
            ei.setContentType("text/html");
            view.execute(ei);
        }
    }
}
