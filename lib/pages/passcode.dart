import 'dart:async';

import 'package:budget_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class PasscodePage extends StatefulWidget {
  const PasscodePage({super.key});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

const storedPasscode = '123456';

class _PasscodePageState extends State<PasscodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Passcode Screen',
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.black26,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please enter your passcode to enter the App',
              style: TextStyle(fontSize: 25, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Adding space between text and button
            _defaultLockScreenButton(context),
          ],
        ),
      ),
    );
  }

  _defaultLockScreenButton(BuildContext context) => MaterialButton(
        color: Colors.blueAccent,
        child: const Text(
          'Open Lock Screen',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        onPressed: () {
          _showLockScreen(
            context,
            opaque: false,
            cancelButton: const Text(
              'Cancel',
              style: TextStyle(fontSize: 20, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          );
        },
      );

  _showLockScreen(BuildContext context,
      {required bool opaque,
      CircleUIConfig? circleUIConfig,
      KeyboardUIConfig? keyboardUIConfig,
      required Widget cancelButton,
      List<String>? digits}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: opaque,
        pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
          title: const Text(
            'Enter App Passcode',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          circleUIConfig: circleUIConfig,
          keyboardUIConfig: keyboardUIConfig,
          passwordEnteredCallback: _onPasscodeEntered,
          cancelButton: cancelButton,
          deleteButton: const Text(
            'Delete',
            style: TextStyle(fontSize: 16, color: Colors.white),
            semanticsLabel: 'Delete',
          ),
          shouldTriggerVerification: _verificationNotifier.stream,
          backgroundColor: Colors.black.withOpacity(0.8),
          cancelCallback: _onPasscodeCancelled,
          digits: digits,
          passwordDigits: 6,
          bottomWidget: _buildPasscodeRestoreButton(),
        ),
      ),
    );
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const HomePage()), // Navigate to HomePage
      );
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  _buildPasscodeRestoreButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: TextButton(
            onPressed: _resetAppPassword,
            child: const Text(
              "Reset passcode",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
      );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Reset passcode",
            style: TextStyle(color: Colors.black87),
          ),
          content: const Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            TextButton(
              onPressed: onAccepted,
              child: const Text(
                "I understand",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }
}
