module d.common;

Object factory(char[] classname) {
    auto ci = ClassInfo.find(classname);
    if (!(ci is null)) {
        return ci.create();
    }
    return null;
}
