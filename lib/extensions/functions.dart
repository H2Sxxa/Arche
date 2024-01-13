typedef FunctionCallback<R> = R Function();
typedef FunctionFactory<T, R> = R Function(T value);
typedef FunctionIndexedFactory<T, R> = R Function(int index, T value);
typedef Predicate<T> = bool Function(T value);

extension PredicateImpl<T> on Predicate<T> {
  bool test(T value) {
    return this(value);
  }
}

R? when<R>(bool condition, FunctionCallback<R> function) =>
    condition ? function() : null;

R? whenNotNull<I, R>(I input, FunctionCallback<R> function) =>
    when(input != null, function);

R? whenNull<I, R>(I input, FunctionCallback<R> function) =>
    when(input == null, function);
