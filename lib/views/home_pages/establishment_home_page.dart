import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:service_app/services/establishment_category_services.dart';
import 'package:service_app/services/home_services.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:service_app/models/establishment_category.dart';
import 'package:service_app/models/home.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/utils/barChart.dart';
import 'package:service_app/views/appointment_history_pages/appointment_history_page.dart';

import '../establishment_pages/establishment_catalog_page.dart';

class EstablishmentHomePage extends StatefulWidget {
  final UserInfo userInfo;

  const EstablishmentHomePage({required this.userInfo, super.key});

  @override
  State<EstablishmentHomePage> createState() => _EstablishmentHomePageState();
}

class _EstablishmentHomePageState extends State<EstablishmentHomePage> {
  late UserInfo _userInfo;
  late HomeModel _homeModel;
  late Future<List<EstablishmentCategory>> _categoryFuture = Future.value([]);
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

  Future<void> fetchData() async {
    try {
      var establishmentCategories = await EstablishmentCategoryServices().get();
      if (establishmentCategories.isNotEmpty) {
        if (mounted) {
          setState(() {
            _categoryFuture = Future.value(establishmentCategories);
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar Special Schedules: $e');
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

    if (tokenProvider.token == null) {
      return const CircularProgressIndicator();
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2864ff)),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
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
                    "Olá, ${widget.userInfo.userProfile!.commercialName}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: _userInfo.userProfile?.profileImage != null
                        ? NetworkImage(_userInfo.userProfile!.profileImage!)
                        : const AssetImage('assets/foto_perfil.png')
                            as ImageProvider,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 175,
                  height: 175,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentHistoryPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _homeModel.totalAppointments != null
                                ? _homeModel.totalAppointments.toString()
                                : '0',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Agendamentos do Dia",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 175,
                  height: 175,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EstablishmentCatalogPage(userInfo: _userInfo),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.add_chart_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _homeModel.totalServicesActives != null
                                ? _homeModel.totalServicesActives.toString()
                                : '0',
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          const Text(
                            "Total de Serviços Ativos",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text('   Relatório de agendamento mensal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            BarChartSample7(),
            /*Center(
              child: InkWell(
                onTap: () async {},
                child: Container(
                  width: 360,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2864ff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Relatórios",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
