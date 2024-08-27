import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/user_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/services/service_services.dart';
import 'package:service_app/views/appointment_history_pages/review_list_page.dart';
import 'package:service_app/views/appointment_pages/card_catalog_page.dart';

class EstablishmentCatalogPage extends StatefulWidget {
  final UserInfo clientUserInfo;
  final UserInfo establishmentUserInfo;

  const EstablishmentCatalogPage(
      {required this.clientUserInfo,
      required this.establishmentUserInfo,
      super.key});

  @override
  State<EstablishmentCatalogPage> createState() =>
      _EstablishmentCatalogPageState();
}

class _EstablishmentCatalogPageState extends State<EstablishmentCatalogPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<Service>> servicesFuture;
  dynamic _image;
  String? imagePath;
  late String? bytes;
  bool isEdited = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    servicesFuture = fetchData();
  }

  Future<List<Service>> fetchData() async {
    try {
      var services = await ServiceServices().getServiceByUserProfileId(
          widget.establishmentUserInfo.userProfile!.userProfileId);
      return services;
    } catch (e) {
      debugPrint('Erro ao buscar serviços: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height *
              0.22), // Ajusta a altura dinamicamente
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20), // Ajusta o padding
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width *
                              0.1, // Ajusta o tamanho do CircleAvatar
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              widget.establishmentUserInfo.userProfile != null
                                  ? NetworkImage(
                                      widget.establishmentUserInfo.userProfile!
                                              .profileImage ??
                                          'URL_INVALIDA',
                                      scale: 1.0,
                                    )
                                  : AssetImage('assets/images.png')
                                      as ImageProvider,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.establishmentUserInfo.userProfile!
                                    .commercialName!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05, // Ajusta o tamanho da fonte
                                ),
                              ),
                              Text(
                                '${widget.establishmentUserInfo.address!.street} - ${widget.establishmentUserInfo.address!.number}\n${widget.establishmentUserInfo.address!.neighborhood} - ${widget.establishmentUserInfo.address!.city}\nCEP: ${widget.establishmentUserInfo.address!.postalCode}',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04), // Ajusta o tamanho da fonte
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                String numericDays = widget
                                        .establishmentUserInfo
                                        .userProfile
                                        ?.schedule
                                        ?.days ??
                                    "";
                                String schedule =
                                    '${widget.establishmentUserInfo.userProfile?.schedule?.start ?? "--:--"} às ${widget.establishmentUserInfo.userProfile?.schedule?.breakStart ?? "--:--"} - ${widget.establishmentUserInfo.userProfile?.schedule?.breakEnd ?? "--:--"} às ${widget.establishmentUserInfo.userProfile?.schedule?.end ?? "--:--"}';

                                List<String> daysWithSchedule =
                                    numericDays.split(',').map((day) {
                                  String dayName;
                                  switch (day) {
                                    case '0':
                                      dayName = 'Segunda-feira';
                                      break;
                                    case '1':
                                      dayName = 'Terça-feira';
                                      break;
                                    case '2':
                                      dayName = 'Quarta-feira';
                                      break;
                                    case '3':
                                      dayName = 'Quinta-feira';
                                      break;
                                    case '4':
                                      dayName = 'Sexta-feira';
                                      break;
                                    case '5':
                                      dayName = 'Sábado';
                                      break;
                                    case '6':
                                      dayName = 'Domingo';
                                      break;
                                    default:
                                      dayName = 'Dia desconhecido';
                                  }
                                  return '$dayName: $schedule';
                                }).toList();

                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.25, // Ajusta a altura dinamicamente
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                'Horário de funcionamento',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width *
                                                      0.05, // Ajusta o tamanho da fonte
                                                  color:
                                                      const Color(0xFF2864ff),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            ...daysWithSchedule
                                                .map((day) => Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left:
                                                              20), // Ajusta o padding
                                                      child: Text(
                                                        day,
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04), // Ajusta o tamanho da fonte
                                                      ),
                                                    ))
                                                .toList(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2864ff),
                              ),
                              child: Text(
                                'Horário de funcionamento',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.04, // Ajusta o tamanho da fonte
                                ),
                              ),
                            ),
                            SizedBox(width: 20), // Ajusta o espaçamento
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewListPage(
                                      userId: widget.establishmentUserInfo
                                          .userProfile!.userId,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(color: Colors.black54),
                                ),
                              ),
                              child: Text(
                                widget.establishmentUserInfo.userProfile
                                            ?.rating !=
                                        null
                                    ? '★ ${widget.establishmentUserInfo.userProfile!.rating!.value.toStringAsFixed(1)}'
                                    : '★ 0',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.04, // Ajusta o tamanho da fonte
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      body: FutureBuilder<List<Service>>(
        future: servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2864ff)));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar os dados"));
          } else if (snapshot.hasData) {
            // Criar um mapa de categorias para os serviços
            Map<String, List<Service>> servicesByCategory = {};
            for (Service service in snapshot.data!) {
              String categoryName = service.serviceCategory!.name;
              servicesByCategory
                  .putIfAbsent(categoryName, () => [])
                  .add(service);
            }

            // Adicionar a guia "Todos" e a vista correspondente
            List<Tab> tabs = [const Tab(text: 'Todos')];
            List<Widget> tabViews = [
              CardCatalogPage(
                  clientUserInfo: widget.clientUserInfo,
                  establishmentUserInfo: widget.establishmentUserInfo,
                  services: snapshot.data!),
            ];

            // Adicionar guias de categorias específicas
            tabs.addAll(servicesByCategory.keys
                .map((categoryName) => Tab(text: categoryName))
                .toList());
            tabViews.addAll(servicesByCategory.entries.map((entry) {
              return CardCatalogPage(
                  clientUserInfo: widget.clientUserInfo,
                  establishmentUserInfo: widget.establishmentUserInfo,
                  services: entry.value);
            }).toList());
            // Configuração do TabController se necessário
            if (_tabController == null ||
                _tabController!.length != tabs.length) {
              _tabController?.dispose();
              _tabController = TabController(vsync: this, length: tabs.length);
            }

            return Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Color(0xFF2864ff),
                    indicatorColor: Color(0xFF2864ff),
                    isScrollable: true,
                    tabs: tabs,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: tabViews,
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Nenhum serviço disponível"));
          }
        },
      ),
    );
  }
}
