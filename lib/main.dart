import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/auth_controller.dart';
import 'package:kids_space_admin/service/api_client.dart';
import 'package:kids_space_admin/utils/get_it_factory.dart';
import 'package:kids_space_admin/view/companies_summary_screen.dart';
import 'package:kids_space_admin/view/home_screen.dart';
import 'package:kids_space_admin/view/login_screen.dart';
import 'package:kids_space_admin/view/details_screen.dart';
import 'package:kids_space_admin/view/manage_company_screen.dart';
import 'package:kids_space_admin/view/register_company_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA4RtVJ-NiwG2kfLsBjX1rrZQ70FBEzEao",
      authDomain: "kids-space-c6f80.firebaseapp.com",
      projectId: "kids-space-c6f80",
      storageBucket: "kids-space-c6f80.firebasestorage.app",
      messagingSenderId: "1047788973580",
      appId: "1:1047788973580:web:de3a74c693e8a07ba84829",
      measurementId: "G-RL3V0TXE45"
    )
  );
  setup(GetIt.I);
  ApiClient().init(
    baseUrl: 'http://10.0.2.2:3000',
    tokenProvider: () async {
      final authController = GetIt.I<AuthController>();
      return await authController.getIdToken();
    },
    refreshToken: () async {
      final authController = GetIt.I<AuthController>();
      return await authController.refreshToken();
    },
  );
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Space Admin',
      navigatorKey: navigatorKey,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register_company': (context) => const RegisterCompanyScreen(),
        '/manage_company': (context) => const ManageCompanyScreen(),
        '/companies_summary': (context) => const CompaniesSummaryScreen(),
        '/details': (context) => const DetailsScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(),
    );
  }
}