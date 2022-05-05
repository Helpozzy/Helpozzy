import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class SecretVaultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        backgroundColor: WHITE,
        title: Text('Auth Biometric'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              Icon(
                Icons.lock_open,
                size: 60,
                color: PRIMARY_COLOR,
              ),
              SizedBox(height: 24.0),
              Text(
                'You have successfully accessed the secret vault. Leaving the vault is pretty easy, just go back to the previous screen by using the "Leave vault" button.',
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    'Leave vault',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
