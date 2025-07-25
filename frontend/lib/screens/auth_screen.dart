import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
  _username,
  _password,
);

      // On success, go to main screen
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() => _error = 'Неверное имя пользователя или пароль');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Авторизация')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Имя пользователя'),
                    validator: (value) => value!.isEmpty ? 'Введите имя' : null,
                    onSaved: (value) => _username = value!.trim(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Введите пароль' : null,
                    onSaved: (value) => _password = value!.trim(),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Войти'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../widgets/form_widgets/modern_text_field.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen>
//     with TickerProviderStateMixin {
//   bool _isSignUp = false;
//   bool _isPasswordVisible = false;
//   bool _showDemoCredentials = false;

//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
    
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

//     _fadeController.forward();
//     _slideController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isMobile = screenSize.width < 768;

//     return Scaffold(
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Container(
//           decoration: _buildGradientBackground(),
//           child: SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(isMobile ? 24 : 32),
//                 child: SlideTransition(
//                   position: _slideAnimation,
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       maxWidth: isMobile ? double.infinity : 400,
//                     ),
//                     child: _buildAuthCard(context),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   BoxDecoration _buildGradientBackground() {
//     final colorScheme = Theme.of(context).colorScheme;
//     return BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           colorScheme.primaryContainer.withOpacity(0.1),
//           colorScheme.secondaryContainer.withOpacity(0.1),
//           colorScheme.tertiaryContainer.withOpacity(0.1),
//         ],
//       ),
//     );
//   }

//   Widget _buildAuthCard(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
    
//     return Card(
//       elevation: 20,
//       shadowColor: colorScheme.shadow.withOpacity(0.3),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               colorScheme.surface.withOpacity(0.95),
//               colorScheme.surface.withOpacity(0.85),
//             ],
//           ),
//         ),
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 32),
//             _buildAuthForm(),
//             const SizedBox(height: 24),
//             _buildActionButtons(),
//             const SizedBox(height: 24),
//             _buildToggleAuthMode(),
//             if (!_isSignUp) ...[
//               const SizedBox(height: 16),
//               _buildDemoCredentials(),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: colorScheme.primaryContainer.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Icon(
//             Icons.water_rounded,
//             size: 48,
//             color: colorScheme.primary,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           'TruboСhisty',
//           style: theme.textTheme.headlineMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: colorScheme.onSurface,
//             letterSpacing: -1,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           _isSignUp ? 'Создайте аккаунт' : 'Добро пожаловать!',
//           style: theme.textTheme.bodyLarge?.copyWith(
//             color: colorScheme.onSurface.withOpacity(0.7),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAuthForm() {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, _) {
//         return Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               if (_isSignUp) ...[
//                 _buildNameField(),
//                 const SizedBox(height: 16),
//               ],
//               _buildEmailField(),
//               const SizedBox(height: 16),
//               _buildPasswordField(),
//               if (authProvider.errorMessage != null) ...[
//                 const SizedBox(height: 16),
//                 _buildErrorMessage(authProvider.errorMessage!),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNameField() {
//     return TextFormField(
//       controller: _nameController,
//       decoration: _buildInputDecoration(
//         'Полное имя',
//         Icons.person_outline_rounded,
//       ),
//       validator: (value) {
//         if (_isSignUp && (value == null || value.trim().isEmpty)) {
//           return 'Введите ваше имя';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildEmailField() {
//     return TextFormField(
//       controller: _emailController,
//       keyboardType: TextInputType.emailAddress,
//       decoration: _buildInputDecoration(
//         'Email',
//         Icons.email_outlined,
//       ),
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return 'Введите email';
//         }
//         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//           return 'Введите корректный email';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller: _passwordController,
//       obscureText: !_isPasswordVisible,
//       decoration: _buildInputDecoration(
//         'Пароль',
//         Icons.lock_outline_rounded,
//         suffixIcon: IconButton(
//           onPressed: () {
//             setState(() {
//               _isPasswordVisible = !_isPasswordVisible;
//             });
//           },
//           icon: Icon(
//             _isPasswordVisible 
//                 ? Icons.visibility_off_rounded 
//                 : Icons.visibility_rounded,
//           ),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Введите пароль';
//         }
//         if (_isSignUp && value.length < 6) {
//           return 'Пароль должен быть не менее 6 символов';
//         }
//         return null;
//       },
//     );
//   }

//   InputDecoration _buildInputDecoration(
//     String label, 
//     IconData icon, 
//     {Widget? suffixIcon}
//   ) {
//     final colorScheme = Theme.of(context).colorScheme;
    
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.7)),
//       suffixIcon: suffixIcon,
//       filled: true,
//       fillColor: colorScheme.surface.withOpacity(0.5),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: colorScheme.primary, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: colorScheme.error, width: 1),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: colorScheme.error, width: 2),
//       ),
//       labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//     );
//   }

//   Widget _buildErrorMessage(String message) {
//     final colorScheme = Theme.of(context).colorScheme;
    
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: colorScheme.errorContainer.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: colorScheme.error.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.error_outline_rounded,
//             color: colorScheme.error,
//             size: 20,
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               message,
//               style: TextStyle(
//                 color: colorScheme.error,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, _) {
//         return SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: authProvider.isLoading ? null : _handleSubmit,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).colorScheme.primary,
//               foregroundColor: Theme.of(context).colorScheme.onPrimary,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 4,
//             ),
//             child: authProvider.isLoading
//                 ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : Text(
//                     _isSignUp ? 'Создать аккаунт' : 'Войти',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildToggleAuthMode() {
//     final colorScheme = Theme.of(context).colorScheme;
    
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           _isSignUp ? 'Уже есть аккаунт?' : 'Нет аккаунта?',
//           style: TextStyle(
//             color: colorScheme.onSurface.withOpacity(0.7),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             setState(() {
//               _isSignUp = !_isSignUp;
//               _formKey.currentState?.reset();
//               context.read<AuthProvider>().clearError();
//             });
//           },
//           child: Text(
//             _isSignUp ? 'Войти' : 'Создать аккаунт',
//             style: TextStyle(
//               color: colorScheme.primary,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDemoCredentials() {
//     final colorScheme = Theme.of(context).colorScheme;
    
//     return Column(
//       children: [
//         TextButton.icon(
//           onPressed: () {
//             setState(() {
//               _showDemoCredentials = !_showDemoCredentials;
//             });
//           },
//           icon: Icon(
//             _showDemoCredentials 
//                 ? Icons.keyboard_arrow_up_rounded 
//                 : Icons.keyboard_arrow_down_rounded,
//             color: colorScheme.primary,
//           ),
//           label: Text(
//             'Демо-аккаунты',
//             style: TextStyle(
//               color: colorScheme.primary,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         if (_showDemoCredentials) ...[
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: colorScheme.surfaceVariant.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Consumer<AuthProvider>(
//               builder: (context, authProvider, _) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: authProvider.demoCredentials.map((cred) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               '${cred['name']} (${cred['role']})',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               _emailController.text = cred['email']!;
//                               _passwordController.text = cred['password']!;
//                             },
//                             style: TextButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, 
//                                 vertical: 4,
//                               ),
//                               minimumSize: Size.zero,
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                             ),
//                             child: const Text(
//                               'Использовать',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Future<void> _handleSubmit() async {
//     if (!_formKey.currentState!.validate()) return;

//     final authProvider = context.read<AuthProvider>();
//     bool success;

//     if (_isSignUp) {
//       success = await authProvider.signUp(
//         _nameController.text.trim(),
//         _emailController.text.trim(),
//         _passwordController.text,
//       );
//     } else {
//       success = await authProvider.signIn(
//         _emailController.text.trim(),
//         _passwordController.text,
//       );
//     }

//     if (success && mounted) {
//       // Navigation will be handled by the main app based on auth state
//     }
//   }
// } 