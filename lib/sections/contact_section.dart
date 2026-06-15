import 'package:flutter/material.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  // State untuk melacak tab mana yang aktif (false = Email, true = WA)
  bool _isWaActive = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        return Container(
          width: double.infinity,
          color: const Color(0xFFFDFDFD),
          padding: EdgeInsets.only(
            top: isDesktop
                ? 120
                : 0, // Di HP, padding 0 agar warna nempel layar atas
            bottom: isDesktop ? 80 : 0,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            // LOGIKA WARNA BACKGROUND: Hijau WA atau Kuning Emas
            color: _isWaActive
                ? const Color(0xFF25D366)
                : const Color(0xFFD8A01A),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop
                  ? MediaQuery.of(context).size.width * 0.05
                  : 20,
              vertical: isDesktop
                  ? 60
                  : 120, // Padding atas HP lebih besar untuk Appbar
            ),
            constraints: BoxConstraints(
              minHeight: isDesktop ? 550 : MediaQuery.of(context).size.height,
            ),
            child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          ),
        );
      },
    );
  }

  // ==========================================
  // 1. LAYOUT DESKTOP (Menyamping)
  // ==========================================
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kiri: Teks Info
        Expanded(flex: 1, child: _buildContactInfo(isDesktop: true)),
        const SizedBox(width: 50),

        // Kanan: Tab + Kartu Putih (Digabung pakai Row, bukan Stack!)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabs(isDesktop: true),
            SizedBox(
              width: 500, // Lebar kartu putih tetap 500
              child: _buildWhiteCard(isDesktop: true),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 2. LAYOUT MOBILE (Atas-Bawah)
  // ==========================================
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactInfo(isDesktop: false),
        const SizedBox(height: 50), // Jarak antara info dan kotak putih
        // Bawah: Tab + Kartu Putih (Digabung pakai Column, bukan Stack!)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabs(isDesktop: false),
            SizedBox(
              width: double.infinity,
              child: _buildWhiteCard(isDesktop: false),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // KOMPONEN: INFO KONTAK (Teks & List)
  // ==========================================
  Widget _buildContactInfo({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: isDesktop ? 48 : 40, // 3rem vs 2.5rem
              color: const Color(0xFF111111),
              fontWeight: FontWeight.w600,
              fontFamily: 'SFProDisplay',
            ),
            children: const [
              TextSpan(text: 'Let’s talk\non something '),
              TextSpan(
                text: 'great\n',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: 'together'),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildInfoItem(
          'assets/images/icon-mail-line.png',
          'bintangtimursip@gmail.com',
        ),
        _buildInfoItem('assets/images/icon-wa-line.png', '+62 895-3140-8593'),
        _buildInfoItem(
          'assets/images/icon-loc-line.png',
          'Jawa Barat, Depok, Pancoran Mas',
        ),
      ],
    );
  }

  Widget _buildInfoItem(String iconPath, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 24,
            color: Colors.white,
          ), // Beri warna putih jika icon bawaannya hitam
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 19.2,
                color: Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ), // 1.2rem
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KOMPONEN: TOMBOL TAB (Email & WA)
  // ==========================================
  Widget _buildTabs({required bool isDesktop}) {
    // Jika desktop berjejer ke bawah (Column), jika HP berjejer ke samping (Row)
    return isDesktop
        ? Column(children: _tabButtons(isDesktop))
        : Row(children: _tabButtons(isDesktop));
  }

  List<Widget> _tabButtons(bool isDesktop) {
    return [
      // Tab Email
      GestureDetector(
        onTap: () => setState(() => _isWaActive = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isDesktop ? 70 : 80,
          height: 60,
          decoration: BoxDecoration(
            color: !_isWaActive ? Colors.white : Colors.white.withOpacity(0.5),
            borderRadius: isDesktop
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
          ),
          child: Center(
            child: Image.asset('assets/images/icon-mail-line.png', width: 25),
          ),
        ),
      ),
      // Tab WA
      GestureDetector(
        onTap: () => setState(() => _isWaActive = true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isDesktop ? 70 : 80,
          height: 60,
          decoration: BoxDecoration(
            color: _isWaActive ? Colors.white : Colors.white.withOpacity(0.5),
            borderRadius: isDesktop
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
          ),
          child: Center(
            child: Image.asset('assets/images/icon-wa-line.png', width: 25),
          ),
        ),
      ),
    ];
  }

  // ==========================================
  // KOMPONEN: KARTU PUTIH UTAMA (Form / WA)
  // ==========================================
  Widget _buildWhiteCard({required bool isDesktop}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,

      // --- PERBAIKAN ABSOLUT DI SINI KING ---
      // Kita ganti 'constraints' menjadi 'height' tetap.
      // Angka 680 ini cukup untuk menampung form Email tanpa melar.
      // (Kalau di layarmu form emailnya masih kepotong, naikkan jadi 700 atau 720)
      height: 680,

      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.zero,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        // Kita tambahkan layoutBuilder untuk meratakan konten WA ke atas,
        // biar saat kotaknya tinggi 680px, konten WA gak otomatis ke tengah (center)
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.topCenter, // Memaksa konten tetap di atas
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: _isWaActive ? _buildWaContent(isDesktop) : _buildEmailContent(),
      ),
    );
  }

  // --- KONTEN 1: FORM EMAIL ---
  Widget _buildEmailContent() {
    return Column(
      key: const ValueKey('Email'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I’m Intrested In :',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD8A01A),
          ),
        ),
        const SizedBox(height: 30),
        _buildTextField('Service', 'Type Services'),
        _buildTextField('Your Name', 'Name'),
        _buildTextField('Your Email', 'example@gmail.com'),
        _buildTextField('Message', '', maxLines: 4),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {}, // Kosongkan fungsinya
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD8A01A),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Kirim',
              style: TextStyle(
                fontSize: 17.6,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14.4, color: Color(0xFF111111)),
          ), // 0.9rem
          const SizedBox(height: 5),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: maxLines > 1
                  ? const EdgeInsets.all(10)
                  : const EdgeInsets.symmetric(vertical: 8),
              // Garis bawah untuk text field biasa, kotak untuk textarea (message)
              border: maxLines > 1
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF999999)),
                    )
                  : const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF333333)),
                    ),
              enabledBorder: maxLines > 1
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF999999)),
                    )
                  : const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF333333)),
                    ),
              focusedBorder: maxLines > 1
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD8A01A)),
                    )
                  : const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD8A01A)),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // --- KONTEN 2: WHATSAPP QR ---
  Widget _buildWaContent(bool isDesktop) {
    return SizedBox(
      key: const ValueKey('WA'),
      height: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profil Bintang
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/foto-profil-bulat.png',
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    fontFamily: 'SFProDisplay',
                  ),
                  children: [
                    TextSpan(
                      text: 'Hi\n',
                      style: TextStyle(color: Color(0xFF25D366)),
                    ),
                    TextSpan(
                      text: 'what can i\n',
                      style: TextStyle(color: Color(0xFF111111)),
                    ),
                    TextSpan(
                      text: 'Help You',
                      style: TextStyle(color: Color(0xFF25D366)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Kotak Hijau QR Code
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: isDesktop ? 30 : 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(15),
              ),

              // --- PERBAIKAN DI SINI KING ---
              // Mengubah Row menjadi Column agar isinya berjejer dari atas ke bawah
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Posisikan semua di tengah secara vertikal
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Posisikan semua di tengah secara horizontal
                children: [
                  // 1. ATAS: Logo WhatsApp
                  Image.asset(
                    'assets/images/icon-wa-logo.png',
                    width: isDesktop ? 180 : 130,
                  ),
                  const SizedBox(height: 10),

                  // 2. TENGAH: Teks "Scan Here !"
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: isDesktop ? 26 : 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFProDisplay',
                      ),
                      children: const [
                        TextSpan(
                          text: 'Scan ',
                          style: TextStyle(color: Color(0xFF111111)),
                        ),
                        TextSpan(
                          text: 'Here !',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ), // Jarak pemisah antara teks dan QR Code
                  // 3. BAWAH: Gambar QR Code
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Ukuran sedikit disesuaikan agar pas di dalam kotak hijau secara vertikal
                    child: Image.asset(
                      'assets/images/qr-code.png',
                      width: isDesktop ? 220 : 160,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
