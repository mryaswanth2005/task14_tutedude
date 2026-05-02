import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  const LoginScreen({super.key, required this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;

  String _authMessage(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'Invalid email format.';
        case 'user-not-found':
          return 'No user found for this email.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email or password is incorrect.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'popup-closed-by-user':
          return 'Google sign-in was canceled.';
      }
      return e.message ?? 'Authentication failed (${e.code}).';
    }
    return e.toString();
  }

  void _showMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _signIn() async {
    setState(() => _loading = true);
    try {
      await widget.authService.signInWithEmail(
        _emailCtl.text.trim(),
        _passCtl.text.trim(),
      );
    } catch (e) {
      _showMessage('Sign in failed: ${_authMessage(e)}');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      await widget.authService.registerWithEmail(
        _emailCtl.text.trim(),
        _passCtl.text.trim(),
      );
    } catch (e) {
      _showMessage('Register failed: ${_authMessage(e)}');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _google() async {
    setState(() => _loading = true);
    try {
      final result = await widget.authService.signInWithGoogle();
      if (result == null) {
        _showMessage('Google sign-in was canceled.');
      }
    } catch (e) {
      _showMessage('Google sign-in failed: ${_authMessage(e)}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailCtl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passCtl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _signIn,
              child: const Text('Sign in'),
            ),
            TextButton(
              onPressed: _loading ? null : _register,
              child: const Text('Register'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: _loading ? null : _google,
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
