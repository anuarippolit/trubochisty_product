import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/culvert_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const TruboApp());
}

class TruboApp extends StatelessWidget {
  const TruboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CulvertProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Trubochisty',
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: const EntryPoint(),
          );
        },
      ),
    );
  }
}

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<AuthProvider>(context, listen: false).autoLogin();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isAuthenticated
        ? const HomePage()
        : const AuthScreen();
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/auth_provider.dart';
// import 'providers/culvert_provider.dart';
// import 'providers/theme_provider.dart';
// import 'screens/home.dart';
// import 'screens/auth_screen.dart';

// void main() {
//   runApp(const TruboApp());
// }

// class TruboApp extends StatelessWidget {
//   const TruboApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => CulvertProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//       ],
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, _) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Trubochisty',
//             theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
//             home: const EntryPoint(),
//           );
//         },
//       ),
//     );
//   }
// }

// class EntryPoint extends StatefulWidget {
//   const EntryPoint({super.key});

//   @override
//   State<EntryPoint> createState() => _EntryPointState();
// }

// class _EntryPointState extends State<EntryPoint> {
//   bool _initialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       Provider.of<AuthProvider>(context, listen: false).autoLogin();
//       _initialized = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return authProvider.isAuthenticated
//         ? const HomeScreen()
//         : const AuthScreen();
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'providers/culvert_provider.dart';
// // import 'providers/auth_provider.dart';
// // import 'providers/theme_provider.dart';
// // import 'screens/culvert_management_screen.dart';
// // import 'screens/auth_screen.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MultiProvider(
// //       providers: [
// //         ChangeNotifierProvider(create: (_) => ThemeProvider()),
// //         ChangeNotifierProvider(create: (_) => AuthProvider()),
// //         ChangeNotifierProvider(create: (_) => CulvertProvider()),
// //       ],
// //       child: Consumer<AuthProvider>(
// //         builder: (context, authProvider, _) {
// //           return MaterialApp(
// //             title: 'TruboСhisty',
// //             debugShowCheckedModeBanner: false,
// //             theme: ThemeData(primarySwatch: Colors.indigo),
// //             initialRoute: authProvider.isAuthenticated ? '/home' : '/login',
// //             routes: {
// //               '/login': (ctx) => const AuthScreen(),
// //               '/home': (ctx) => const CulvertManagementScreen(),
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
