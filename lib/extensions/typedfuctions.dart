typedef FunctionCallback<R> = R Function();
typedef FunctionFactory<T, R> = R Function(T);
typedef Predicate<T> = bool Function(T);

extension PredicateImpl<T> on Predicate<T> {
  bool test(T value) {
    return this(value);
  }
}
