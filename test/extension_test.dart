import 'package:arche/extensions/iter.dart';
import 'package:arche/src/impl/debug_io.dart';
import 'package:test/test.dart';

void main() {
  test("Test List join", () {
    debugWrite([1, 2].joinElement(100));
  });

  test("Test iter all", () {
    debugWrite([true, true].all());
    debugWrite([true, false].all());
  });

  test("Test ListGenerator", () {
    debugWrite(ListExt.generatefrom(
      [1, 2, 3],
      functionFactory: (p0) => ++p0,
    ));
  });
}
