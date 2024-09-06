import 'package:flutter/material.dart';
import 'package:service_app/Services/auth_services.dart';
import 'package:service_app/models/auth/login.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/views/auth_pages/register_address_page.dart';
import 'package:service_app/views/auth_pages/register_client_profile_page.dart';
import 'package:service_app/views/auth_pages/register_establishment_profile_page.dart';
import 'package:service_app/views/home_pages/client_home_page.dart';
import 'package:service_app/views/main_pages/establishment_main_page.dart';
import 'package:service_app/views/main_pages/client_main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String mensagemErro = '';
  bool visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Faça login em sua conta",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),

              TextFormField(
                controller: emailController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w100,
                  ),
                  prefixIcon: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.email_sharp,
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.5),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              TextFormField(
                controller: passwordController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                obscureText: !visiblePassword,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w100,
                  ),
                  prefixIcon: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.lock_open_sharp,
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visiblePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        visiblePassword = !visiblePassword;
                      });
                    },
                  ),
                ),
              ),

              // Esqueceu a senha?
              /*const SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RedefinirSenhaPage(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),*/
              SizedBox(
                height: 20,
              ),
              if (mensagemErro.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    mensagemErro,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),

              const SizedBox(
                height: 40,
              ),

              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  setState(() {
                    mensagemErro = '';
                  });
                  var request = Login(
                      email: emailController.text,
                      password: passwordController.text);
                  AuthServices()
                      .login(context, request)
                      .then((UserInfo userInfo) {
                    if (userInfo.userRole.userRoleId == 2) {
                      if (userInfo.userProfile == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegisterEstablishmentProfilePage(
                                        userInfo: userInfo)));
                      } else if (userInfo.address == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegisterAddressPage(userInfo: userInfo)));
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  EstablishmentMainPage(userInfo: userInfo)),
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                    if (userInfo.userRole.userRoleId == 3) {
                      if (userInfo.userProfile == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterClientProfilePage(
                                    userInfo: userInfo)));
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ClientMainPage(
                                    userInfo: userInfo,
                                  )),
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                  }).catchError((e) {
                    messageError(e.toString());
                  });
                },
                color: const Color(0xFF2864ff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  "Entrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(
                height: 260,
              ),
            ],
          ),
        ),
      ),
    );
  }

  messageError(String message) {
    setState(() {
      mensagemErro = message;
    });
  }
}
