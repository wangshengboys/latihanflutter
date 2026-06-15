import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: const BoxDecoration(color: Color(0xFFD8A01A)),
          // Tambahkan ini agar teks background tidak bocor keluar section
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              // --- 1. BACKGROUND TEXT ("IM CENTAURY") ---
              Positioned(
                bottom: isDesktop ? -30 : 10,
                right: isDesktop ? -20 : 10,
                child: Text(
                  'IM CENTAURY',
                  style: TextStyle(
                    fontSize: isDesktop ? 128 : 64,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withOpacity(0.15),
                    letterSpacing: 2,
                  ),
                ),
              ),

              // --- 2. KONTEN UTAMA (Tanpa Positioned.fill) ---
              // Dengan melepas Positioned.fill, konten ini bebas mendorong tinggi Stack ke bawah sesuai panjang teks!
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? MediaQuery.of(context).size.width * 0.05
                      : 20,
                  vertical: isDesktop ? 60 : 50,
                ),
                child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // LAYOUT DESKTOP
  // ==========================================
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 19,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 200,
            ), // transform: translateY(40px)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitle(isDesktop: true),
                const SizedBox(height: 20),
                _buildDescription(isDesktop: true),
                const SizedBox(height: 40),
                _buildDesktopTable(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 10,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ), // transform: translateY(10px)
              child: _buildProfileImage(isDesktop: true),
            ),
          ),
        ),
      ],
    );
  }

  // LAYOUT MOBILE
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(isDesktop: false),
        const SizedBox(height: 20),
        _buildProfileImage(isDesktop: false), // Foto pindah ke urutan ke-2!
        const SizedBox(height: 30),
        _buildDescription(isDesktop: false),
        const SizedBox(height: 30),
        _buildMobileTable(),
      ],
    );
  }

  Widget _buildTitle({required bool isDesktop}) {
    return Text(
      'About Me',
      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
      style: TextStyle(
        fontSize: isDesktop ? 56 : 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDescription({required bool isDesktop}) {
    return Text(
      'I am an Informatics Engineering student at Paramadina University with a strong artistic background, rooted in my vocational high school education in Multimedia. With over 5 years of experience as a designer, I have developed a solid foundation in visual aesthetics and communication. My interest in 3D began through my passion for gaming, particularly war-themed games, which inspired me to explore and create 3D assets, especially for game development. I have now accumulated over 3 years of experience in 3D modeling and asset creation. Currently, I am also sharpening my skills in the field of information technology, focusing on frontend development and user experience (UX). Although I have been in this field for about a year, I have already worked on a real-world project: a social media application that I continue to develop. I am highly motivated to keep learning, combining visual creativity with technical skills, and building digital solutions that are not only functional but Also visually compelling.',
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 17.6, // 1.1rem
        height: 1.6, // line-height: 1.6
        color: Colors.white,
      ),
    );
  }

  Widget _buildProfileImage({required bool isDesktop}) {
    return Image.asset(
      'assets/images/foto-about.webp',
      // Kita ganti ukurannya menjadi fixed max-width agar Flutter tidak pusing
      width: isDesktop ? 400 : 280,
      fit: BoxFit.contain,
    );
  }

  // --- Tabel Versi Desktop ---
  Widget _buildDesktopTable() {
    return Table(
      // Ganti IntrinsicColumnWidth menjadi FlexColumnWidth untuk menghindari layout loop
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2.5), // Beri ruang lebih luas untuk isi data
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(2.5),
      },
      children: [
        _buildTableRow('Birthday', 'June 2004', 'Phone', '+62 895-3140-8593'),
        _buildTableRow('Age', '21', 'Email', 'bintangtimursip@gmail.com'),
      ],
    );
  }

  TableRow _buildTableRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.6,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            value1,
            style: const TextStyle(fontSize: 17.6, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.6,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            value2,
            style: const TextStyle(fontSize: 17.6, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // --- Tabel Versi Mobile (Teks Rata Tengah) ---
  Widget _buildMobileTable() {
    return Column(
      children: [
        _buildMobileTableItem('Birthday', 'June 2004'),
        _buildMobileTableItem('Age', '21'),
        _buildMobileTableItem('Phone', '+62 895-3140-8593'),
        _buildMobileTableItem('Email', 'bintangtimursip@gmail.com'),
      ],
    );
  }

  Widget _buildMobileTableItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.6,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 17.6, color: Colors.white),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
