import 'dart:io';

void main() async {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  int totalReplacements = 0;

  for (final file in files) {
    String content = file.readAsStringSync();
    String original = content;
    
    content = content.replaceAll('Alignment.centerLeft', 'AlignmentDirectional.centerStart');
    content = content.replaceAll('Alignment.centerRight', 'AlignmentDirectional.centerEnd');
    content = content.replaceAll('Alignment.topLeft', 'AlignmentDirectional.topStart');
    content = content.replaceAll('Alignment.topRight', 'AlignmentDirectional.topEnd');
    content = content.replaceAll('Alignment.bottomLeft', 'AlignmentDirectional.bottomStart');
    content = content.replaceAll('Alignment.bottomRight', 'AlignmentDirectional.bottomEnd');

    content = content.replaceAll('EdgeInsets.only(', 'EdgeInsetsDirectional.only(');
    content = content.replaceAll('EdgeInsets.fromLTRB(', 'EdgeInsetsDirectional.fromSTEB(');
    
    // Positioned (careful not to replace Positioned.fill or others unless they take left/right, 
    // Positioned.fill doesn't take start/end. Positioned.directional exists but PositionedDirectional is standard)
    content = content.replaceAll(RegExp(r'\bPositioned\('), 'PositionedDirectional(');

    // BorderRadius
    content = content.replaceAll('BorderRadius.only(', 'BorderRadiusDirectional.only(');
    content = content.replaceAll('BorderRadius.horizontal(', 'BorderRadiusDirectional.horizontal(');

    // Replace parameter names
    content = content.replaceAll(RegExp(r'\bleft:'), 'start:');
    content = content.replaceAll(RegExp(r'\bright:'), 'end:');
    
    content = content.replaceAll(RegExp(r'\btopLeft:'), 'topStart:');
    content = content.replaceAll(RegExp(r'\btopRight:'), 'topEnd:');
    content = content.replaceAll(RegExp(r'\bbottomLeft:'), 'bottomStart:');
    content = content.replaceAll(RegExp(r'\bbottomRight:'), 'bottomEnd:');

    // Revert any false positives
    // e.g. crossAxisAlignment: CrossAxisAlignment.start is fine.
    // e.g. textDirection: TextDirection.start? No, it's TextDirection.ltr
    // Wait, TextDirection.ltr is not affected by left/right.
    
    // Revert Positioned.fill if we messed it up? We used \bPositioned\( so Positioned.fill( is safe.

    if (content != original) {
      file.writeAsStringSync(content);
      totalReplacements++;
      print('Updated: ${file.path}');
    }
  }

  print('Total files updated: $totalReplacements');
}
