import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/appointment.dart';
import 'package:service_app/models/home.dart';
import 'dart:io';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/home_services.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  late UserInfo _userInfo;
  late HomeModel _homeModel;
  Map<String, dynamic> payload = {};
  Map<String, dynamic> initialData = {};
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserInfo().then((_) {
      setState(() {
        fetchDataHome().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    });
  }

  Future<void> fetchUserInfo() async {
    var tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    payload = Jwt.parseJwt(tokenProvider.token!);
    print(payload);
    if (payload['UserId'] != null) {
      int userId = int.tryParse(payload['UserId'].toString()) ?? 0;
      await UserInfoServices()
          .getUserInfoByUserId(userId)
          .then((UserInfo userInfo) {
        setState(() {
          _userInfo = userInfo;
          initialData = {
            'name': userInfo.user.name,
            'cpf': userInfo.userProfile!.document,
            'birth': DateFormat('dd/MM/yyyy')
                .format(userInfo.userProfile!.dateOfBirth!),
            'cel': userInfo.userProfile!.phone!
          };
        });
      }).catchError((e) {
        print('Erro ao buscar UserInfo: $e ');
      });
    }
  }

  Future<void> fetchDataHome() async {
    var tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    payload = Jwt.parseJwt(tokenProvider.token!);
    if (payload['UserId'] != null) {
      int userId = int.tryParse(payload['UserId'].toString()) ?? 0;
      await HomeServices().getHomeByUserId(userId).then((HomeModel homeModel) {
        _homeModel = homeModel;
      }).catchError((e) {
        print('Erro ao buscar UserInfo: $e ');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    print(tokenProvider.token);
    if (tokenProvider.token == null) {
      return const CircularProgressIndicator();
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white, // Define o fundo da tela como branco
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2864ff)),
        ),
      );
    }

    final String formattedDate =
        DateFormat('dd/MM/yyyy').format(_homeModel.nextAppointment!.start);

    final String formattedTime =
        DateFormat('HH:mm').format(_homeModel.nextAppointment!.start);

    List<Map<String, dynamic>> categoria = [
      {"icon": "assets/cuidados-com-a-pele.png", "text": "salão de beleza"},
      {"icon": "assets/ferramentas.png", "text": "mecânico"},
      {"icon": "assets/pincel.png", "text": "pintura"},
      {"icon": "assets/mais.png", "text": "mais"},
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Olá, ' + _userInfo.user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: _userInfo.userProfile?.profileImage != null
                        ? FileImage(File(_userInfo.userProfile!.profileImage!))
                        : const AssetImage('assets/foto_perfil.png')
                            as ImageProvider,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.93,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2864ff),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Color(0xFF2864ff),
                                  size: 35,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(height: 9),
                                  Text(
                                    "Próximo Agendamento",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month,
                                      color: Colors.white54),
                                  const SizedBox(width: 5),
                                  Text(
                                    _homeModel.nextAppointment?.start != null
                                        ? formattedDate.toString()
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(Icons.access_time_filled,
                                      color: Colors.white54),
                                  const SizedBox(width: 5),
                                  Text(
                                    _homeModel.nextAppointment?.start != null
                                        ? formattedTime.toString()
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

            //containers com serviços
            const SizedBox(height: 20),
            SizedBox(
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categoria.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 19),
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          categoria[index]["icon"],
                          width: 45,
                          height: 45,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 45,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categoria.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 19),
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          categoria[index]["text"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            //slide
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: (20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Especialmente para você",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    //onTap: press,
                    child: const Text("Veja mais"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.asset(
                            width: 380,
                            height: 180,
                            "assets/barbeiro.png",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: 380,
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF343434).withOpacity(0.4),
                                  const Color(0xFF343434).withOpacity(0.15),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: "Barbearia",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //slide2
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.asset(
                            width: 380,
                            height: 180,
                            "assets/manicure.png",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: 380,
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF343434).withOpacity(0.4),
                                  const Color(0xFF343434).withOpacity(0.15),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: "Manicure",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: BottomNavigationMenu(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),*/
    );
  }
}
