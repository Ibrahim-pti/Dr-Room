import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BodyMapScreen extends StatefulWidget {
  const BodyMapScreen({super.key});

  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0F172A))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // Inject JavaScript to hide the header, footer, and navigation
            // so only the interactive body map is visible.
            _controller.runJavaScript('''
              try {
                // Hide common web elements
                var header = document.querySelector('header');
                if (header) header.style.display = 'none';
                
                var footer = document.querySelector('footer');
                if (footer) footer.style.display = 'none';
                
                var navs = document.querySelectorAll('nav');
                for (var i = 0; i < navs.length; i++) {
                  navs[i].style.display = 'none';
                }
                
                // Hide any obvious ad banners
                var ads = document.querySelectorAll('[id*="ad-"], [class*="ad-"]');
                for (var i = 0; i < ads.length; i++) {
                  ads[i].style.display = 'none';
                }
              } catch(e) {
                console.log(e);
              }
            ''');
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://www.innerbody.com/image/cardov.html'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detailed Anatomy',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            ),
        ],
      ),
    );
  }
}
