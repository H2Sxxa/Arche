import 'dart:io';

extension FSUtils on FileSystemEntity {
  Directory subDirectory(String path) {
    return Platform.isWindows
        ? Directory("${absolute.path}\\$path")
        : Directory("${absolute.path}/$path");
  }

  File subFile(String path) {
    return Platform.isWindows
        ? File("${absolute.path}\\$path")
        : File("${absolute.path}/$path");
  }

  String subPath(String subpath) {
    return Platform.isWindows ? "$path\\$subpath" : "$path/$subpath";
  }
}

extension CheckFile on File {
  File check() {
    createSync();
    return this;
  }
}

extension CheckDirectory on Directory {
  Directory check() {
    createSync();
    return this;
  }
}
