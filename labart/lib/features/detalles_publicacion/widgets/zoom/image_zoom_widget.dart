import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:ui';

class ImageZoomWidget extends StatefulWidget {
  final ImageProvider imageProvider;
  final VoidCallback onClose;

  const ImageZoomWidget({
    super.key,
    required this.imageProvider,
    required this.onClose,
  });

  @override
  _ImageZoomWidgetState createState() => _ImageZoomWidgetState();
}

class _ImageZoomWidgetState extends State<ImageZoomWidget>
    with SingleTickerProviderStateMixin {
  late PhotoViewController _controller;
  double _currentScale = 1.0;
  double _initialScale = 1.0;
  bool _initialScaleSet = false;
  Offset _position = Offset.zero;
  Offset _initialPosition = Offset.zero;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuart,
      ),
    );
    
    _blurAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutExpo,
      ),
    );
    
    _animationController.forward();
    
    _controller = PhotoViewController()
      ..outputStateStream.listen((state) {
        if (!mounted) return;
        
        setState(() {
          _currentScale = state.scale ?? _currentScale;
          _position = state.position;
          
          if (!_initialScaleSet && state.scale != null) {
            _initialScale = state.scale!;
            _initialPosition = state.position;
            _initialScaleSet = true;
          }
        });

        if (_initialScaleSet && _currentScale <= _initialScale * 0.85) {
          _exitWithAnimation();
        }
        
        if (_initialScaleSet && 
            _currentScale <= _initialScale * 1.1 && 
            _position.dy - _initialPosition.dy > 100) {
          _exitWithAnimation();
        }
      });
  }

  Future<void> _exitWithAnimation() async {
    await _animationController.reverse();
    if (!mounted) return;
    widget.onClose();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final buttonColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.black : Colors.white;
    final backgroundColor = isDarkMode ? 
      Colors.black.withOpacity(0.85 * _opacityAnimation.value) : 
      const Color.fromARGB(255, 65, 65, 65).withOpacity(0.50 * _opacityAnimation.value);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: Container(
                  color: backgroundColor,
                ),
              ),
            ),
            
            FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PhotoView(
                        controller: _controller,
                        imageProvider: widget.imageProvider, // Corregido aquí
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 3.0,
                        initialScale: PhotoViewComputedScale.contained,
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        basePosition: Alignment.center,
                        enableRotation: false,
                        filterQuality: FilterQuality.high,
                        gestureDetectorBehavior: HitTestBehavior.opaque,
                        loadingBuilder: (context, event) => Container(), // Vacío porque usa caché
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.broken_image,
                                color: Colors.white.withOpacity(0.5),
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Couldn\'t load image',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            Positioned(
              top: MediaQuery.of(context).padding.top + 35,
              right: 20,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: _exitWithAnimation,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: buttonColor.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}