import 'package:arche/extensions/iter.dart';
import 'package:arche/src/impl/cans.dart';
import 'package:arche/src/impl/debug_io.dart';
import 'package:test/test.dart';

void main() {
  test("Simple", () {
    var a = [2];
    a.last = 1;
    debugWriteln(a);
  });

  test("Iterator", () {
    var v = [1, 2, 3];
    var iter = v.iterator;
    debugWriteln("${iter.next()}.${iter.next()}.${iter.next()} ${iter.next()}");
  });
}
