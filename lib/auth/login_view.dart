import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:labeling/game/brick_breaker.dart';
import 'package:labeling/services/auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background_auth.png'), // Giriş ekranı arka plan fotoğrafı
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-posta',
                      border: OutlineInputBorder(), // MD3 stiline uygun
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      border: OutlineInputBorder(), // MD3 stiline uygun
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16), // MD3 stiline uygun
                    ),
                    child: const Text('Giriş Yap'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16), // MD3 stiline uygun
                      ),
                      child: const Text('Hesap Oluştur'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _forgotPassword,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16), // MD3 stiline uygun
                      ),
                      child: const Text('Şifremi Unuttum'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn() async {
    try {
      User? user = await auth.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BrickBreakerGame()),
        );
      }
      // Sign in successful
    } catch (e) {
      // Sign in failed
    }
  }

  Future<void> _register() async {
    try {
      User? user = await auth.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Failed')),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BrickBreakerGame()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
      }

      // Registration successful
    } catch (e) {
      // Registration failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Failed: $e')),
      );
    }
  }

  void _forgotPassword() {
    // Şifre sıfırlama işlemleri burada yapılabilir
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Şifremi Unuttum'),
        content: const Text('Şifre sıfırlama bağlantısı gönderildi.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void createAccount() {
    // Hesap oluşturma işlemleri burada yapılabilir
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesap Oluştur'),
        content: const Text('Hesap oluşturma sayfasına yönlendiriliyorsunuz.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
