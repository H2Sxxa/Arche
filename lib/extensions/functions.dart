typedef FunctionCallback<R> = R Function();
typedef FunctionFactory<T, R> = R Function(T value);
typedef FunctionIndexedFactory<T, R> = R Function(int index, T value);
typedef Predicate<T> = bool Function(T value);
typedef Transformer<T> = T Function(T value);

extension PredicateImpl<T> on Predicate<T> {
  bool test(T value) {
    return this(value);
  }
}

extension TransformerImpl<T> on Transformer<T> {
  T transform(T value) {
    return this(value);
  }
}

R? when<R>(bool condition, FunctionCallback<R> function) =>
    condition ? function() : null;

O? whenNotNull<I, O>(I? input, FunctionFactory<I, O> function) =>
    when(input != null, () => function(input as I));

O? whenNull<I, O>(I? input, FunctionFactory<I, O> function) =>
    when(input == null, () => function(input as I));
