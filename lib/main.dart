import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:service_app/views/appointment_history_pages/appointment_history_page.dart';
import 'package:service_app/views/appointment_pages/search_page.dart';
import 'package:service_app/views/client_pages/my_profile_page.dart';
import 'package:service_app/views/home_pages/client_home_page.dart';
import 'package:service_app/views/home_pages/home_page.dart';
import 'package:service_app/utils/token_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          TokenProvider(), // Cria uma instância do TokenProvider

      child: const ServiceApp(),
    ),
  );
}

//Teste
class ServiceApp extends StatelessWidget {
  const ServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Remover quando sair de debug
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      title: 'iService',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      initialRoute: '/',
      routes: {
        '/login': (context) => HomePage(),
        '/home': (context) => ClientHomePage(),
        '/search': (context) => SearchPage(),
        '/appointments': (context) => AppointmentHistoryPage(),
        '/profile': (context) => MyProfilePage(),
      },
    );
  }
}
