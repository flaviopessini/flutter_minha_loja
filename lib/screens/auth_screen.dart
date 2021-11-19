import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/components/auth_form_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(253, 115, 44, 0.5),
                  Color.fromRGBO(255, 200, 117, 0.9),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 70.0,
                      ),
                      transform: Matrix4.rotationZ(-8.0 * pi / 180.0)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.deepOrange.shade700,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8.0,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ]),
                      child: const Text(
                        'Minha Loja',
                        style: TextStyle(
                          fontSize: 44.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const AuthFormWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
