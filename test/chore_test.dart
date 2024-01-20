import 'package:arche/arche.dart';
import 'package:arche/extensions/iter.dart';
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

  test("Can Write Test", () {
    ConstCan can0 = const ConstCan(100);
    ConstCan can1 = const ConstCan(2);
    ConstCan can2 = const ConstCan(1);

    can0.value = "";
    debugWriteln(can0.optValue.isSome());
    debugWriteln(can1.optValue.isNull());
    debugWriteln(can2.optValue.isNull());
  });

  test("Can Dynamic Test", () {
    LazyDynamicCan<int> can = LazyDynamicCan(builder: () {
      debugWriteln("get 10");
      return 10;
    });
    debugWriteln(can.value);
    debugWriteln(can.value);
    debugWriteln(can.reload());
  });
}
