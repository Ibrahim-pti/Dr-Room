void main() {
  try {
    String Function() f = () => null as dynamic;
    f();
  } catch(e) {
    print("Test 1: " + e.toString());
  }

  try {
    Map<String, dynamic> json = {'status': null};
    String x = json['status'];
  } catch(e) {
    print("Test 2: " + e.toString());
  }
}
