import 'package:arche/src/impl/debug.dart';
import 'package:arche/src/impl/singleton.dart';
import 'package:test/test.dart';

class TestCls {
  int v = 0;
  void increase() {
    v += 1;
  }

  TestCls._();
  factory TestCls() => singleton.provideof(instance: TestCls._());
}

void main() {
  test('Singleton', () {
    TestCls().increase();
    debugPrintln(TestCls().v);
  });
}
