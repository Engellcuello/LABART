import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rive/rive.dart';
import 'package:labart/features/autentication/screens/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labart/features/autentication/screens/onboarding/controllers.onboarding/onboarding_controller.dart';
import 'package:labart/features/autentication/screens/login_singup/login_singup.dart';

class SplashNormal extends StatefulWidget {
  const SplashNormal({super.key});

  @override
  SplashNormalState createState() => SplashNormalState();
}

class SplashNormalState extends State<SplashNormal> {
  static const _animationPath = 'lib/assets/animations/splashscreen.riv';
  static const _animationVersion = 1;
  static String get _cacheFileName => 'splashscreen_v$_animationVersion.riv';
  
  late RiveAnimationController _controller;
  late Future<Artboard> _animationFuture;
  bool _shouldNavigate = false;
  
  // Controlador de onboarding
  final OnBoardingController onboardingController = Get.put(OnBoardingController());

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('Timeline 1');
    _animationFuture = _loadAnimation();
    _preloadOnboardingResources();
  }

  Future<void> _preloadOnboardingResources() async {
    // Precarga cualquier recurso necesario para el onboarding aquí
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<Artboard> _loadAnimation() async {
    try {
      final file = await _getAnimationFile();
      final data = await file.readAsBytes();
      final fileRive = RiveFile.import(ByteData.view(data.buffer));
      return _initializeArtboard(fileRive);
    } catch (e) {
      debugPrint('Error loading animation: $e');
      final assetData = await rootBundle.load(_animationPath);
      final fileRive = RiveFile.import(assetData);
      return _initializeArtboard(fileRive);
    }
  }

  Artboard _initializeArtboard(RiveFile fileRive) {
    final artboard = fileRive.mainArtboard;
    artboard.addController(_controller);
    _controller.isActive = true;
    
    
    // Inicia el temporizador para la navegación
    _startNavigationTimer();
    
    return artboard;
  }

  void _startNavigationTimer() {
    // Espera 3 segundos (o el tiempo que dura tu animación) antes de navegar
    Timer(const Duration(seconds: 3), _checkNavigation);
  }

  Future<void> _checkNavigation() async {
    if (!mounted || _shouldNavigate) return;
    _shouldNavigate = true;

    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool(OnBoardingController.onboardingKey) ?? false;
    final token = prefs.getString('token');

    // Lógica de navegación:
    if (token != null && token.isNotEmpty) {
      // Usuario ya inició sesión
      Get.off(() => NavigationMenu());
    } else if (onboardingCompleted) {
      // Mostró onboarding pero no ha iniciado sesión
      Get.off(() => AuthScreen());
    } else {
      // Primer ingreso, muestra onboarding
      Get.off(() => const OnBoardingScreen());
    }
  }


  Future<File> _getAnimationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final cachedFile = File('${directory.path}/$_cacheFileName');

    if (await cachedFile.exists()) {
      try {
        final assetData = await rootBundle.load(_animationPath);
        final newFileData = assetData.buffer.asUint8List();
        final cachedFileData = await cachedFile.readAsBytes();
        
        if (_isDifferent(newFileData, cachedFileData)) {
          await cachedFile.delete();
          debugPrint('Deleted outdated cached animation');
        }
      } catch (e) {
        debugPrint('Error comparing animation versions: $e');
      }
    }

    if (await cachedFile.exists()) {
      debugPrint('Using cached animation version $_animationVersion');
      return cachedFile;
    }

    final assetData = await rootBundle.load(_animationPath);
    await cachedFile.writeAsBytes(assetData.buffer.asUint8List());
    debugPrint('Created new cached animation version $_animationVersion');
    return cachedFile;
  }

  bool _isDifferent(Uint8List a, Uint8List b) {
    if (a.length != b.length) return true;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return true;
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 239, 231),
      body: FutureBuilder<Artboard>(
        future: _animationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
            return const Center(child: SizedBox());
          }

          return Rive(
            artboard: snapshot.data!,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}