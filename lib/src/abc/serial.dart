abstract interface class Serializer<A, B> {
  A decode(B data);
  B encode(A object);
}

typedef MapSerializer<K, V, I> = Serializer<Map<K, V>, I>;
