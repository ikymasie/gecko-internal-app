import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gecko_internal/views/pages/admin-login.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'AIzaSyCpqvSTQr9iiSIrsPbsZSeZSSdtSSME9gs',
    appId: '1:625639870933:android:ba00c171e2ba4051356d5c',
    messagingSenderId: '625639870933',
    projectId: 'tickiteer-dev',
    storageBucket: 'tickiteer-dev.appspot.com',
  )
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
       theme: GeckoTheme.theme,
       debugShowCheckedModeBanner: false,
       debugShowMaterialGrid: false,
      home: AdminLoginPage(),
    );
  }
}
