import 'package:flutter/material.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/service_services.dart';
import 'package:service_app/views/establishment_pages/register_service_page.dart';
import 'package:service_app/views/establishment_pages/service_card_page.dart';

class EstablishmentCatalogPage extends StatefulWidget {
  final UserInfo userInfo;

  const EstablishmentCatalogPage({required this.userInfo, super.key});

  @override
  State<EstablishmentCatalogPage> createState() =>
      _EstablishmentCatalogPageState();
}

class _EstablishmentCatalogPageState extends State<EstablishmentCatalogPage> {
  Future<List<Service>> _servicesFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Service>? services = await ServiceServices()
          .getServiceByUserProfileId(
              widget.userInfo.userProfile!.userProfileId);

      if (mounted) {
        setState(() {
          _servicesFuture = Future.value(services);
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar Special Schedules: $e');
      if (mounted) {
        setState(() {
          _servicesFuture = Future.value([]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Catálogo",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterServicePage(
                          userInfo: widget.userInfo,
                          serviceId: 0,
                        ),
                      ),
                    );

                    if (result == true) {
                      fetchData(); // Atualiza a lista de serviços ao retornar se um novo serviço foi adicionado
                    }
                  },
                  child: Container(
                    width: 390,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2864ff),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Adicionar um novo serviço",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Service>>(
              future: _servicesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2864ff)),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.56,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final service = snapshot.data![index];
                        return ServiceCardPage(
                          userInfo: widget.userInfo,
                          service: service,
                          onUpdated: fetchData,
                          onDeleted: fetchData,
                        );
                      },
                    );
                  }
                }
                return const Center(
                    child: Text(
                        'Nenhum serviço cadastrado.')); // Exibe mensagem se não houver dados
              },
            ),
          ),
        ],
      ),
    );
  }
}
