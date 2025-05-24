import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'admin/admin_home.dart';
import 'user/user_products.dart';
import 'user/cart/cart_provider.dart';
import 'services/firestore_service.dart';
import 'firebase_options.dart';
import 'auth/otp_login_page.dart'; // OTP login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: MaterialApp(
        title: 'Fish Delivery Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeSelector(),
        routes: {
          '/adminHome': (_) => AdminHome(),
          '/userProducts': (_) => UserProducts(),
          '/otpLoginUser': (_) => OtpLoginPage(role: 'user'),
          '/otpLoginAdmin': (_) => OtpLoginPage(role: 'admin'),
        },
      ),
    );
  }
}

class HomeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select View')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Admin Login'),
              onPressed: () {
                Navigator.pushNamed(context, '/otpLoginAdmin');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('User Login'),
              onPressed: () {
                Navigator.pushNamed(context, '/otpLoginUser');
              },
            ),
          ],
        ),
      ),
    );
  }
}
