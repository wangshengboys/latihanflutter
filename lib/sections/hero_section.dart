import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

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
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? MediaQuery.of(context).size.width * 0.05
                : 20,
            vertical: isDesktop
                ? 150
                : 120,
          ),
          child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        );
      },
    );
  }

  // Dekstop lO
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHelloImage(height: 80),
              const SizedBox(height: 20),
              _buildTitle(fontSize: 64),
              const SizedBox(height: 40),
              _buildActionGroup(isDesktop: true),
              const SizedBox(height: 50),
              _buildStatsBox(isDesktop: true),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: _FloatingProfileImage(maxWidth: 500),
          ),
        ),
      ],
    );
  }

  // Mobile LO
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHelloImage(height: 60),
        const SizedBox(height: 10),
        _buildTitle(fontSize: 32, isCenter: true),
        const SizedBox(height: 30),
        _FloatingProfileImage(maxWidth: 300),
        const SizedBox(height: 30),
        _buildStatsBox(isDesktop: false),
        const SizedBox(height: 30),
        _buildActionGroup(isDesktop: false),
      ],
    );
  }

  Widget _buildHelloImage({required double height}) {
    return Image.asset('assets/images/hello-en.png', height: height);
  }

  Widget _buildTitle({required double fontSize, bool isCenter = false}) {
    return RichText(
      textAlign: isCenter ? TextAlign.center : TextAlign.left,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF111111),
          height: 1.2,
          fontFamily: 'SFProDisplay',
        ),
        children: const [
          TextSpan(text: "I'm "),
          TextSpan(
            text: "Bintang Timur\n",
            style: TextStyle(color: Color(0xFFD8A01A)),
          ), // Highlight Emas
          TextSpan(text: "Programmer and Designer"),
        ],
      ),
    );
  }

  Widget _buildActionGroup({required bool isDesktop}) {
    return Wrap(
      alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 20,
      children: [
        // Sosial Media
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HoverScaleWidget(
              child: Image.asset(
                'assets/images/Github.png',
                height: isDesktop ? 50 : 30,
              ),
            ),
            const SizedBox(width: 15),
            _HoverScaleWidget(
              child: Image.asset(
                'assets/images/icon-in.png',
                height: isDesktop ? 50 : 30,
              ),
            ),
            const SizedBox(width: 15),
            _HoverScaleWidget(
              child: Image.asset(
                'assets/images/icon-ig.png',
                height: isDesktop ? 50 : 30,
              ),
            ),
          ],
        ),
        // Tombol CV
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE2E2E2),
            foregroundColor: const Color(0xFF333333),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : 20,
              vertical: isDesktop ? 20 : 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Download CV',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD8A01A),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : 20,
              vertical: isDesktop ? 20 : 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Hire Me',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBox({required bool isDesktop}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 10,
        vertical: isDesktop ? 20 : 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: isDesktop ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("5Y", "Experience\nDesign", isDesktop),
          _buildDivider(isDesktop),
          _buildStatItem("1Y", "Experience\nProgramming", isDesktop),
          _buildDivider(isDesktop),
          _buildStatItem("3Y", "Experience\n3D Artist", isDesktop),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDesktop) {
    return _HoverScaleWidget(
      scaleAmount: 1.15, // Sama persis dengan transform: scale(1.15) di CSS
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 80 : 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD8A01A),
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 19 : 12,
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDesktop) {
    return Container(
      width: 2,
      height: isDesktop ? 50 : 30,
      color: const Color(0xFFDDDDDD),
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 35 : 5),
    );
  }
}

// anim naik turun
class _HoverScaleWidget extends StatefulWidget {
  final Widget child;
  final double scaleAmount;
  const _HoverScaleWidget({required this.child, this.scaleAmount = 1.1});

  @override
  State<_HoverScaleWidget> createState() => _HoverScaleWidgetState();
}

class _HoverScaleWidgetState extends State<_HoverScaleWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_isHovered ? widget.scaleAmount : 1.0),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}

// animasi pp
class _FloatingProfileImage extends StatefulWidget {
  final double maxWidth;
  const _FloatingProfileImage({required this.maxWidth});

  @override
  State<_FloatingProfileImage> createState() => _FloatingProfileImageState();
}

class _FloatingProfileImageState extends State<_FloatingProfileImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // anim foto
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0,
      end: -15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Image.asset(
        'assets/images/foto-profil.webp',
        width: widget.maxWidth,
        fit: BoxFit.contain,
      ),
    );
  }
}
