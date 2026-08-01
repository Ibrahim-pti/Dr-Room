with open('lib/core/utils/api_client.dart', 'r') as f:
    content = f.read()

# Add getImageUrl method
method = """  static String get storageUrl => AppConfig.storageUrl;

  static String getImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    
    final origin = AppConfig.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    final cleanPath = path.startsWith('/') ? path : '/$path';
    // Handle the case where path already contains /storage
    if (cleanPath.startsWith('/storage')) {
        return '$origin$cleanPath';
    }
    return '$origin/storage$cleanPath';
  }"""

content = content.replace("  static String get storageUrl => AppConfig.storageUrl;", method)

with open('lib/core/utils/api_client.dart', 'w') as f:
    f.write(content)
