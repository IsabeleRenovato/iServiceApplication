import 'dart:async';
import 'package:flutter/material.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/user_info.dart';
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
        title: Text(widget.establishmentUserInfo.userProfile!.commercialName!),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(250),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40, // Define o tamanho do avatar
                          backgroundColor: Colors.grey[300],
                          backgroundImage: NetworkImage(
                            widget.establishmentUserInfo.userProfile!
                                    .profileImage ??
                                'URL_INVALIDA',
                            scale: 1.0,
                          ),
                          onBackgroundImageError: (exception, stackTrace) {
                            // Aqui você pode logar o erro se necessário
                          },
                          child: widget.establishmentUserInfo.userProfile!
                                      .profileImage ==
                                  null
                              ? Image.asset('assets/testeCorte.jpeg',
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.establishmentUserInfo.userProfile!
                                    .commercialName!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '${widget.establishmentUserInfo.address!.street} - ${widget.establishmentUserInfo.address!.number}\n${widget.establishmentUserInfo.address!.neighborhood} - ${widget.establishmentUserInfo.address!.city}\nCEP: ${widget.establishmentUserInfo.address!.postalCode}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: Text("Lista de horarios aqui"),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2864ff),
                              ),
                              child: const Text(
                                'Horário de funcionamento',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 25),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewListPage(
                                            userId: widget.establishmentUserInfo
                                                .userProfile!.userId)));
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
                                widget.establishmentUserInfo.userProfile!
                                            .rating !=
                                        null
                                    ? '★ ${widget.establishmentUserInfo.userProfile!.rating!.value.toStringAsFixed(1)}'
                                    : '★ 0',
                                style: const TextStyle(
                                  fontSize: 16,
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
      ),
      body: FutureBuilder<List<Service>>(
        future: servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: tabs,
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
