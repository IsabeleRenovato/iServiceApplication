import 'package:flutter/material.dart';
import 'package:service_app/views/auth_pages/register_user_page.dart';

class ProfileChoicePage extends StatelessWidget {
  const ProfileChoicePage({super.key});

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
                          image: AssetImage("assets/sign-up-iservice.png"))),
                ),
                const SizedBox(
                  height: 0,
                ),
                const Text(
                  "Selecione o seu tipo de perfil",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Seja você um cliente em busca de serviços incríveis ou um estabelecimento pronto para expandir sua presença, estamos aqui para ajudar.",
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
                const SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RegisterUserPage(userRoleId: 3)));
                  },
                  color: const Color(0xFF2864ff),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text("Cliente",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RegisterUserPage(userRoleId: 2)));
                  },
                  color: const Color(0xFF2864ff),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text("Estabelecimento",
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
