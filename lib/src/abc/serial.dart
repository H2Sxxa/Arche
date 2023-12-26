abstract interface class Serializer<A, B> {
  A decode(B data);
  B encode(A object);
}
