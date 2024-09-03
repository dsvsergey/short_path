class PriorityQueue<E> {
  final List<E> _list = [];
  final Comparator<E> compare;

  PriorityQueue(this.compare);

  void add(E element) {
    _list.add(element);
    _list.sort(compare);
  }

  E removeFirst() => _list.removeAt(0);

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  int get length => _list.length;

  bool any(bool Function(E) test) => _list.any(test);
}
