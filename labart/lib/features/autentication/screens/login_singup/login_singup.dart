import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labart/features/autentication/screens/login_singup/verify_email.dart';
import 'package:labart/features/autentication/screens/password_configurations/forget_password.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:rive/rive.dart' hide LinearGradient, Image;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:get/get.dart'; // Si usas GetX

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late RiveAnimationController _riveController;
  int _selectedTabIndex = 0;
  final _formKey = GlobalKey<FormState>();
  double _panelPosition = 0.75;
  bool _keyboardVisible = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _needsScroll = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _riveController = SimpleAnimation('state machine', autoplay: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewInsets = MediaQuery.of(context).viewInsets;
    final newKeyboardVisible = viewInsets.bottom > 0;
    
    if (newKeyboardVisible != _keyboardVisible) {
      setState(() {
        _keyboardVisible = newKeyboardVisible;
        // Calculamos la posición basada en el contenido y el espacio disponible
        if (_keyboardVisible) {
          // Cuando el teclado está visible, colocamos el panel 10% arriba del teclado
          // Queremos que el panel ocupe el 90% del espacio disponible (dejando 10% abajo)
          _panelPosition = 0.9 - (_selectedTabIndex == 0 ? 0.20 : 0.60);
        } else {
          // Cuando no hay teclado, usamos posiciones basadas en el contenido
          _panelPosition = _selectedTabIndex == 0 ? 0.84 : 0.45;
        }
      });
    }
  }

  Future<void> _saveRegistrationData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('register_name', _nameController.text);
    await prefs.setString('register_email', _emailController.text);
    await prefs.setString('register_password', _passwordController.text);
  }

  Future<void> _saveOtpCode(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('register_otp', otp);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _needsScroll = true);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${THttpHelper.baseUrl}/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "correo_usuario": _emailController.text,
          "Contrasena": _passwordController.text
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data["token_de_acceso"] ?? '');
        await prefs.setInt('id_usuario', data["ID_usuario"] ?? 0);

        final idUsuario = prefs.getInt('id_usuario') ?? 0;
        print('ID del usuario: $idUsuario');

        if (!mounted) return;  // Verificar si el widget sigue en pantalla

        Get.offAll(() => NavigationMenu());

      } else {
        setState(() {
          _errorMessage = "Credenciales incorrectas";
          _needsScroll = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión. Intenta nuevamente";
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyEmail() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _needsScroll = true);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${THttpHelper.baseUrl}/email'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "destinatario": _emailController.text,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Guardar datos en caché antes de navegar
        await _saveRegistrationData();
        await _saveOtpCode(responseData['OTP']); // Guardar el código OTP

        
        // Registro exitoso, navegar a verificación de email
        if (!mounted) return;
        Get.to(() => const VerifyEmailScreen());
      } else if (response.statusCode == 409) {
        setState(() {
          _errorMessage = "El correo electrónico ya está registrado";
        });
      } else if (response.statusCode == 500) {
        setState(() {
          _errorMessage = "No se pudo enviar el correo de verificación. Por favor intenta nuevamente";
        });
      } else {
        setState(() {
          _errorMessage = "Error en el servidor";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión. Intenta nuevamente";
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _submitForm() {
    if (_selectedTabIndex == 0) {
       _login();
      // Get.offAll(() => NavigationMenu());
    } else {
      if (_formKey.currentState!.validate()) {
        // print('Register: ${_nameController.text}');
        _verifyEmail(); 
      } 
    }
  }

  void _toggleAuthMode() {
  setState(() {
    _selectedTabIndex = _selectedTabIndex == 0 ? 1 : 0;
    if (_keyboardVisible) {
      _panelPosition = 0.9 - (_selectedTabIndex == 0 ? 0.0 : 0.45);
        } else {
          // Cuando no hay teclado, usamos posiciones basadas en el contenido
          _panelPosition = _selectedTabIndex == 0 ? 0.84 : 0.45;
    }
  });
}

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final riveHeight = screenHeight * 0.4;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: riveHeight,
            child: RiveAnimation.asset(
              'lib/assets/animations/final_fantasy.riv',
              fit: BoxFit.cover,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            top: riveHeight * _panelPosition,
            left: 0,
            right: 0,
            bottom: 0, // Asegura que llegue hasta el fondo
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,// Fondo blanco sólido
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor, // Borde superior semi-transparente
                    width: 6,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                child: _needsScroll
                    ? SingleChildScrollView(
                        physics: _needsScroll
                          ? const AlwaysScrollableScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                        child: _buildFormContent(),
                      )
                    : _buildFormContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

//dark ? TColors.primary : Colors.black
// Colors.black

  Widget _buildFormContent() {
    final dark = THelperFunctions.isDarkMode(context);
    
    final primaryTextColor = dark ? TColors.textWhite : const Color.fromARGB(200, 0, 0, 0);
    final inputBackground =Colors.transparent;
    final borderColor = dark ?TColors.white : TColors.dark;
    
    final buttonGradient = LinearGradient(
      colors: _selectedTabIndex == 0 
        ? [
            Color.fromARGB(157, 100, 180, 246), 
            Color.fromARGB(255, 219, 77, 255), 
            Color.fromARGB(159, 211, 170, 212)
          ]
        : [
            Color.fromARGB(157, 246, 188, 100), 
            Color.fromARGB(255, 219, 77, 255), 
            const Color.fromARGB(134, 30, 136, 229)
          ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final titleStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: primaryTextColor,
      fontFamily: 'Poppins',
    );

    final buttonTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'Poppins',
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedTabIndex == 0 ? 'Iniciar Sesión' : 'Registrarse',
                  style: titleStyle,
                ),
                const SizedBox(height: 5),
                
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                // Parte animada (solo los inputs)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.vertical,
                        axisAlignment: -1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: _selectedTabIndex == 0 
                    ? _buildLoginForm(inputBackground, borderColor, primaryTextColor) 
                    : _buildRegisterForm(inputBackground, borderColor, primaryTextColor, dark, TColors.primary),
                ),

                // Parte fija (botón y elementos inferiores)
                AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  decoration: BoxDecoration(
                    gradient: buttonGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _isLoading ? null : _submitForm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              _selectedTabIndex == 0 ? 'Iniciar Sesión' : 'Registrarse',
                              style: buttonTextStyle,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: borderColor,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'O continúa con',
                        style: TextStyle(
                          color: dark ?  Colors.grey[500] : Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: borderColor,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialAuthButton(
                      iconPath: 'lib/assets/logos/facebook-icon.png',
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    SocialAuthButton(
                      iconPath: 'lib/assets/logos/google-icon.png',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                TextButton(
                  onPressed: _toggleAuthMode,
                  child: RichText(
                    text: TextSpan(
                      text: _selectedTabIndex == 0 
                        ? '¿No tienes cuenta? ' 
                        : '¿Ya tienes cuenta? ',
                      style: TextStyle(
                        color: dark ?  Colors.grey[500] : Colors.grey[600] ,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(
                          text: _selectedTabIndex == 0 ? 'Regístrate' : 'Inicia sesión',
                          style: TextStyle(
                            color: TColors.primary,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(Color inputBackground, Color borderColor, Color textColor) {
    return Column(
      key: const ValueKey('login_form'),
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
              filled: true,
              fillColor: inputBackground,
              prefixIcon: Icon(Icons.email, color: textColor.withOpacity(0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textColor.withOpacity(0.5), width: 1.5),
              ),
            ),
            style: TextStyle(color: textColor),
            cursorColor: textColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa un correo electrónico';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
            filled: true,
            fillColor: inputBackground,
            prefixIcon: Icon(Icons.lock, color: textColor.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _showPassword 
                  ? CrossFadeState.showFirst 
                  : CrossFadeState.showSecond,
                firstChild: const Icon(Icons.visibility_off, color: Colors.grey),
                secondChild: const Icon(Icons.visibility, color: Colors.grey),
              ),
              onPressed: _togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: textColor.withOpacity(0.5), width: 1.5),
            ),
          ),
          style: TextStyle(color: textColor),
          cursorColor: textColor,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa una contraseña';
            }
            if (value.length < 4) {
              return 'La contraseña debe tener al menos 5 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: ()=>Get.to(() => const ForgetPassword()),
            child: Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(
                color: TColors.primary,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(Color inputBackground, Color borderColor, Color textColor, bool dark, Color primaryColor) {
    return Column(
      key: const ValueKey('register_form'),
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nombre de Usuario',
              labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
              filled: true,
              fillColor: inputBackground,
              prefixIcon: Icon(Icons.person, color: textColor.withOpacity(0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textColor.withOpacity(0.5), width: 1.5),
              ),
            ),
            style: TextStyle(color: textColor),
            cursorColor: textColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu nombre de Usuario';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
            filled: true,
            fillColor: inputBackground,
            prefixIcon: Icon(Icons.email, color: textColor.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: textColor.withOpacity(0.5), width: 1.5),
            ),
          ),
          style: TextStyle(color: textColor),
          cursorColor: textColor,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa un correo electrónico';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
            filled: true,
            fillColor: inputBackground,
            prefixIcon: Icon(Icons.lock, color: textColor.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _showPassword 
                  ? CrossFadeState.showFirst 
                  : CrossFadeState.showSecond,
                firstChild: const Icon(Icons.visibility_off, color: Colors.grey),
                secondChild: const Icon(Icons.visibility, color: Colors.grey),
              ),
              onPressed: _togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: textColor.withOpacity(0.5), width: 1.5),
            ),
          ),
          style: TextStyle(color: textColor),
          cursorColor: textColor,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa una contraseña';
            }
            if (value.length < 4) {
              return 'La contraseña debe tener al menos 5 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_showConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirmar contraseña',
            labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
            filled: true,
            fillColor: inputBackground,
            prefixIcon: Icon(Icons.lock_outline, color: textColor.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _showConfirmPassword 
                  ? CrossFadeState.showFirst 
                  : CrossFadeState.showSecond,
                firstChild: const Icon(Icons.visibility_off, color: Colors.grey),
                secondChild: const Icon(Icons.visibility, color: Colors.grey),
              ),
              onPressed: _toggleConfirmPasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: textColor.withOpacity(0.5), width: 1.5),
            ),
          ),
          style: TextStyle(color: textColor),
          cursorColor: textColor,
          validator: (value) {
            if (value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: true,
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 8), // Reemplazado TSizes.spaceBtwItems por un valor fijo
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "I agree to ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: "Privacy Policy ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: dark ? Colors.white : primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: dark ? Colors.white : primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: "and ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: "Terms of use",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: dark ? Colors.white : primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: dark ? Colors.white : primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _riveController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class SocialAuthButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x33000000), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(
          iconPath,
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}