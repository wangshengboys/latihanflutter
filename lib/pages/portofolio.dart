import 'dart:ui';
import 'package:flutter/material.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/project_section.dart';
import '../sections/service_section.dart';
import '../sections/contact_section.dart';

class PortofolioPage extends StatefulWidget {
  const PortofolioPage({super.key});

  @override
  State<PortofolioPage> createState() => _PortofolioPageState();
}

class _PortofolioPageState extends State<PortofolioPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Navigator.pop(context);
    }

    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFFDFDFD),
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: AppBar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  elevation: 0,
                  toolbarHeight: 80,
                  automaticallyImplyLeading: false,
                  shape: const Border(
                    bottom: BorderSide(color: Colors.black12, width: 0.5),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Image.asset('assets/images/logo.png', height: 40),
                  ),
                  // dekstop menu keliatan, mobile menu masuk
                  actions: isDesktop ? [_buildDesktopNav()] : null,
                  iconTheme: const IconThemeData(color: Color(0xFFD8A01A)),
                ),
              ),
            ),
          ),

          // Mobile Drawer
          endDrawer: !isDesktop
              ? Drawer(
                  backgroundColor: Colors.white.withOpacity(0.95),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const DrawerHeader(
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Center(
                            child: Text(
                              'Menu',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111111),
                              ),
                            ),
                          ),
                        ),
                        _buildMobileNavItem(
                          'Home',
                          () => _scrollToSection(_heroKey),
                        ),
                        _buildMobileNavItem(
                          'About',
                          () => _scrollToSection(_aboutKey),
                        ),
                        _buildMobileNavItem(
                          'Project',
                          () => _scrollToSection(_projectKey),
                        ),
                        _buildMobileNavItem(
                          'Services',
                          () => _scrollToSection(_servicesKey),
                        ),
                        _buildMobileNavItem(
                          'Contact',
                          () => _scrollToSection(_contactKey),
                        ),
                      ],
                    ),
                  ),
                )
              : null,

          // Page
          body: SingleChildScrollView(
            child: Column(
              children: [
                //Home
                HeroSection(key: _heroKey),

                // about
                AboutSection(key: _aboutKey),

                // project
                ProjectSection(key: _projectKey),

                // services
                ServiceSection(key: _servicesKey),

                // contact
                ContactSection(key: _contactKey),
              ],
            ),
          ),
        );
      },
    );
  }

  // Navigasi Dekstop
  Widget _buildDesktopNav() {
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Row(
        children: [
          _buildDesktopNavButton(
            'Home',
            () => _scrollToSection(_heroKey),
            isActive: true,
          ),
          _buildDesktopNavButton('About', () => _scrollToSection(_aboutKey)),
          _buildDesktopNavButton(
            'Project',
            () => _scrollToSection(_projectKey),
          ),
          _buildDesktopNavButton(
            'Services',
            () => _scrollToSection(_servicesKey),
          ),
          _buildDesktopNavButton(
            'Contact',
            () => _scrollToSection(_contactKey),
          ),
          const SizedBox(width: 20),
          // Tombol Bahasa EN
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0F0),
              foregroundColor: const Color(0xFF111111),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.language, size: 18),
            label: const Text(
              'EN',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Animasi kalau di pencet
  Widget _buildDesktopNavButton(
    String label,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFFD4A32A)
                  : const Color(0xFF111111),
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Pilihan menu mobile
  Widget _buildMobileNavItem(String label, VoidCallback onTap) {
    return ListTile(
      title: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF111111),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }
}
