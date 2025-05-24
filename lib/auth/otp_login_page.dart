import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpLoginPage extends StatefulWidget {
  // Accept role parameter to customize login (optional)
  final String? role;

  const OtpLoginPage({Key? key, this.role}) : super(key: key);

  @override
  _OtpLoginPageState createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  String _verificationId = '';
  bool _codeSent = false;
  bool _loading = false;

  void _sendOTP() async {
    setState(() => _loading = true);
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid phone number')));
      setState(() => _loading = false);
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _checkUserRole();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification failed')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
          _loading = false;
        });
      },
    );
  }

  void _verifyOTP() async {
    setState(() => _loading = true);
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a 6-digit OTP')));
      setState(() => _loading = false);
      return;
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otp,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      await _checkUserRole();
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  Future<void> _checkUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final doc = await userRef.get();

    if (doc.exists) {
      String role = doc['role'] ?? 'user';
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/adminHome');
      } else {
        Navigator.pushReplacementNamed(context, '/userProducts');
      }
    } else {
      // New user default to 'user' role
      await userRef.set({
        'phone': '+91${_phoneController.text.trim()}',
        'role': 'user',
      });
      Navigator.pushReplacementNamed(context, '/userProducts');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login with OTP')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixText: '+91 ',
              ),
              keyboardType: TextInputType.phone,
              enabled: !_codeSent,
            ),
            if (_codeSent)
              TextField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'Enter OTP'),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text(_codeSent ? 'Verify OTP' : 'Send OTP'),
                    onPressed: _codeSent ? _verifyOTP : _sendOTP,
                  ),
          ],
        ),
      ),
    );
  }
}
