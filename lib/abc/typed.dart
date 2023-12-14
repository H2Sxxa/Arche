import 'package:arche/abc/serial.dart';

typedef MapSerializer<K, V, I> = Serializer<Map<K, V>, I>;
typedef FunctionCallback<R> = R Function();
typedef Test<T> = bool Function(T);
