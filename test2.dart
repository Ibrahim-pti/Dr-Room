void main() {
  List<int> list = [];
  try {
    list.firstWhere((x) => x == 1, orElse: () => null as dynamic);
  } catch(e) {
    print("Test 1: " + e.toString());
  }
}
