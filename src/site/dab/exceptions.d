module dab.exceptions;

class DabException : Exception {
    this(char[] msg) {
        super(msg);
    }
}

class MapperNotFoundException : DabException {
    this() {
        super("MapperNotFoundException");
    }
}

class ControllerNotFoundException : DabException {
    this() {
        super("ControllerNotFoundException");
    }
}

class ViewNotFoundException : DabException {
    this() {
        super("ViewNotFoundException");
    }
}
