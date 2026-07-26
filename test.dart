class A {
  final String status;
  A({required this.status});
}
void main() {
  dynamic j = {'status': null};
  try {
    A(status: j['status']);
  } catch(e) {
    print("Test 1: " + e.toString());
  }

  try {
    String Function() f = () => null as dynamic;
    f();
  } catch(e) {
    print("Test 2: " + e.toString());
  }
}
