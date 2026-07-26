void main() {
  try {
    List<dynamic> raw = [null];
    List<String> mapped = raw.map<String>((e) => e).toList();
  } catch(e) {
    print("Test: " + e.toString());
  }
}
