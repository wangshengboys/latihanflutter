import 'package:flutter/material.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({super.key});

  @override
  State<ProjectSection> createState() => _ProjectSectionState();
}

class _ProjectSectionState extends State<ProjectSection> {
  // 1. STATE UNTUK FILTER KATEGORI
  String _selectedCategory = 'ALL';

  // 2. DATABASE PROYEK (Berdasarkan HTML kamu)
  final List<Map<String, dynamic>> _allProjects = [
    {
      'id': 'p1',
      'category': '2D',
      'thumb': 'assets/images/proj1-1.webp',
      'images': [
        'assets/images/proj1-1.webp',
        'assets/images/proj1-2.webp',
        'assets/images/proj1-3.webp',
      ],
    },
    {
      'id': 'p2',
      'category': '2D',
      'thumb': 'assets/images/proj2-1.webp',
      'images': [
        'assets/images/proj2-1.webp',
        'assets/images/proj2-2.webp',
        'assets/images/proj2-3.webp',
      ],
    },
    {
      'id': 'p3',
      'category': '2D',
      'thumb': 'assets/images/proj-3.1.webp',
      'images': [
        'assets/images/proj-3.1.webp',
        'assets/images/proj3-2.webp',
        'assets/images/proj3-3.webp',
      ],
    },
    {
      'id': 'p4',
      'category': '3D',
      'thumb': 'assets/images/proj4-1.webp',
      'images': ['assets/images/proj4-1.webp', 'assets/images/proj4-2.webp'],
    },
    {
      'id': 'p5',
      'category': '3D',
      'thumb': 'assets/images/proj5-1.webp',
      'images': ['assets/images/proj5-1.webp', 'assets/images/proj5-2.webp'],
    },
    {
      'id': 'p6',
      'category': '3D',
      'thumb': 'assets/images/proj6-1.webp',
      'images': [
        'assets/images/proj6-1.webp',
        'assets/images/proj6-2.webp',
        'assets/images/proj6-3.webp',
        'assets/images/proj6-4.webp',
      ],
    },
    {
      'id': 'p7',
      'category': 'UI/UX',
      'thumb': 'assets/images/proj7-1.webp',
      'images': [
        'assets/images/proj7-1.webp',
        'assets/images/proj7-2.webp',
        'assets/images/proj7-3.webp',
        'assets/images/proj7-4.webp',
        'assets/images/proj7-5.webp',
        'assets/images/proj7-6.webp',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _selectedCategory == 'ALL'
        ? _allProjects
        : _allProjects
              .where((p) => p['category'] == _selectedCategory)
              .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        return Container(
          width: double.infinity,
          color: const Color(0xFFFDFDFD),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? MediaQuery.of(context).size.width * 0.05
                : 20,
            vertical: isDesktop ? 150 : 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project',
                      style: TextStyle(
                        fontSize: isDesktop ? 56 : 40,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'I have completed over 100+ projects across various creative and digital development fields. My experience includes 2D Design, 3D Design, UI/UX Design, and Mobile Frontend Design. Each project is crafted with a strong focus on detail, aesthetics, and functionality, while aligning with user needs and modern design trends.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 17.6,
                        color: const Color(0xFF555555),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              Wrap(
                spacing: 30,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: ['ALL', '2D', '3D', 'UI/UX', 'APP'].map((category) {
                  bool isActive = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 17.6,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFFD8A01A)
                            : const Color(0xFF111111),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 3 : 1,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  childAspectRatio: 16 / 9,
                ),
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];
                  return _buildProjectCard(project, isDesktop);
                },
              ),

              const SizedBox(height: 80),

              Column(
                children: [
                  const Text(
                    'Experienced Apps & Tools',
                    style: TextStyle(
                      fontSize: 17.6,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Image.asset(
                    'assets/images/tools-group.png',
                    width: isDesktop
                        ? 600
                        : MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, bool isDesktop) {
    return GestureDetector(
      onTap: () => _openLightbox(project['images'], isDesktop),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _HoverImage(imagePath: project['thumb']),
      ),
    );
  }

  void _openLightbox(List<String> images, bool isDesktop) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Konten Berdasarkan Platform
              isDesktop
                  ? _DesktopSliderView(images: images)
                  : _MobileScrollView(images: images),

              // Tombol Close (X)
              Positioned(
                top: 30,
                right: 30,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 40),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HoverImage extends StatefulWidget {
  final String imagePath;
  const _HoverImage({required this.imagePath});

  @override
  State<_HoverImage> createState() => _HoverImageState();
}

class _HoverImageState extends State<_HoverImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Image.asset(
          widget.imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class _DesktopSliderView extends StatefulWidget {
  final List<String> images;
  const _DesktopSliderView({required this.images});

  @override
  State<_DesktopSliderView> createState() => _DesktopSliderViewState();
}

class _DesktopSliderViewState extends State<_DesktopSliderView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Slider Gambar
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Image.asset(widget.images[index], fit: BoxFit.contain);
              },
            ),

            if (widget.images.length > 1)
              Positioned(
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 30,
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),

            if (widget.images.length > 1)
              Positioned(
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 30,
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileScrollView extends StatelessWidget {
  final List<String> images;
  const _MobileScrollView({required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 80,
          bottom: 40,
          left: 20,
          right: 20,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(images[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
