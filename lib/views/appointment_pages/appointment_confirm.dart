import 'package:flutter/material.dart';
import 'package:service_app/models/user_info.dart';

import 'package:service_app/views/main_pages/client_main_page.dart';

class AppointmentConfirm extends StatelessWidget {
  final UserInfo userInfo;

  const AppointmentConfirm({required this.userInfo, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          color: const Color(0xFFFAFAFA),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/confirmed.gif'))),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Seu agendamento foi',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' confirmado!',
                            style: TextStyle(
                              color: Color(0xFF2864ff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Abaixo disponibilizamos o contato do estabelecimento",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.phone,
                        color: Color(0xFF2864ff),
                        size: 24.0,
                      ),
                      SizedBox(width: 10),
                      Text(
                        userInfo.userProfile!.commercialPhone ??
                            'Telefone não disponível',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Color(0xFF2864ff),
                        size: 24.0,
                      ),
                      SizedBox(width: 10),
                      Text(
                        userInfo.userProfile!.commercialEmail ??
                            'Email não disponível',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
                          builder: (context) =>
                              ClientMainPage(userInfo: userInfo),
                        ),
                      );
                    },
                    color: Color(0xFF2864ff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Avançar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
