import 'dart:io';

extension FSUtils on FileSystemEntity {
  Directory subDirectory(String path) {
    return Directory("${absolute.path}/$path");
  }

  File subFile(String path) {
    return File("${absolute.path}/$path");
  }

  String subPath(String subpath) {
    return "$path/$subpath";
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
