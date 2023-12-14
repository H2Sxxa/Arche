import 'package:arche/extensions/iter.dart';
import 'package:arche/impl/debug.dart';
import 'package:test/test.dart';

void main() {
  test("Test List join", () {
    debugPrintln([1, 2].joinElement(100));
  });

  test("Test iter all", () {
    debugPrintln([true, true].all());
    debugPrintln([true, false].all());
  });
}
