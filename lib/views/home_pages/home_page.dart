import 'package:flutter/material.dart';
import 'package:service_app/views/auth_pages/profile_choice_page.dart';
import 'package:service_app/views/auth_pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/agenda-iService.png'))),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Bem-Vindo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Simplifique sua vida agendando serviços de forma rápida e fácil com nosso aplicativo intuitivo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                const SizedBox(height: 30),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text("Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileChoicePage()));
                  },
                  color: const Color(0xFF2864ff),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text("Cadastre-se",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
