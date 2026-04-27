component {
    this.name = "cf-emoji-java-tests";
    this.applicationTimeout = createTimeSpan(0, 0, 30, 0);
    this.sessionManagement = false;

    variables.appDir = getDirectoryFromPath(getCurrentTemplatePath());
    variables.parentDir = getCanonicalPath(variables.appDir & "../");

    this.mappings["/cfemojijava"] = variables.parentDir;

    this.javaSettings = {
        loadPaths: [ getCanonicalPath(variables.parentDir & "/lib") ],
        reloadOnChange: true
    };
}
