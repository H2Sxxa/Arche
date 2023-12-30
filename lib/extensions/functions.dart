typedef FunctionCallback<R> = R Function();
typedef FunctionFactory<T, R> = R Function(T value);
typedef Predicate<T> = bool Function(T value);

extension PredicateImpl<T> on Predicate<T> {
  bool test(T value) {
    return this(value);
  }
}
