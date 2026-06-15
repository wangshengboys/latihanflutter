import 'package:flutter/material.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar 12 gambar services sesuai penamaan di HTML-mu
    final List<String> services = List.generate(
      12,
      (index) => 'assets/images/serv-${index + 1}.png',
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        return Container(
          width: double.infinity,
          color: const Color(0xFFFDFDFD), // Background putih dari CSS
          padding: EdgeInsets.symmetric(
            // Padding kiri-kanan: 5% untuk Web, 12% untuk HP (sesuai CSS)
            horizontal: isDesktop
                ? MediaQuery.of(context).size.width * 0.05
                : MediaQuery.of(context).size.width * 0.12,
            vertical: isDesktop ? 150 : 100,
          ),
          child: Column(
            // Teks rata kiri di Web, rata tengah di HP
            crossAxisAlignment: isDesktop
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // --- JUDUL SERVICES ---
              Text(
                'Services',
                style: TextStyle(
                  fontSize: isDesktop ? 56 : 35, // 3.5rem (Web) vs 2.2rem (HP)
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111111),
                ),
              ),
              SizedBox(height: isDesktop ? 50 : 30), // Jarak margin-bottom
              // --- GRID SERVICES ---
              // Dibungkus Center & ConstrainedBox untuk membatasi lebar di HP (max 450px)
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? double.infinity : 450,
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop
                          ? 6
                          : 2, // 6 kolom (Web) vs 2 kolom (HP)
                      mainAxisSpacing: isDesktop ? 50 : 15, // Gap atas-bawah
                      crossAxisSpacing: isDesktop ? 50 : 15, // Gap kiri-kanan
                      childAspectRatio:
                          1.0, // Asumsi gambar berbentuk kotak (1:1)
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return _ServiceCard(
                        imagePath: services[index],
                        isDesktop: isDesktop,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// KELAS ANIMASI HOVER (Melayang)
// ==========================================
class _ServiceCard extends StatefulWidget {
  final String imagePath;
  final bool isDesktop;

  const _ServiceCard({required this.imagePath, required this.isDesktop});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        // Logika transform: translateY dari CSS (naik -10px di web, -5px di HP)
        transform: Matrix4.identity()
          ..translate(
            0.0,
            _isHovered ? (widget.isDesktop ? -10.0 : -5.0) : 0.0,
          ),
        // Padding ekstra 5px untuk HP sesuai CSS
        padding: EdgeInsets.all(widget.isDesktop ? 0 : 5.0),
        child: Image.asset(
          widget.imagePath,
          fit: BoxFit.contain, // Memastikan gambar tidak terpotong
        ),
      ),
    );
  }
}
