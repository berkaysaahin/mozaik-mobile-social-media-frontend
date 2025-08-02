extension StableSort<T> on List<T> {
  List<T> sorted(int Function(T a, T b) compare) {
    final list = [...this];
    list.sort((a, b) {
      final result = compare(a, b);
      return result != 0 ? result : a.hashCode.compareTo(b.hashCode);
    });
    return list;
  }
}