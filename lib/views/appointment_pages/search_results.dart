import 'package:flutter/material.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/views/appointment_pages/card_catalog_page.dart';
import 'package:service_app/views/appointment_pages/service_page.dart';

class SearchResultsPage extends StatelessWidget {
  final UserInfo userInfo;
  final String searchText;
  final List<Service> servicesList;

  const SearchResultsPage({
    required this.userInfo,
    required this.searchText,
    required this.servicesList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados da Pesquisa: $searchText'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: servicesList.isEmpty
            ? Center(
                child: Text(
                  'Nenhum serviço encontrado para "$searchText".',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: servicesList.length,
                itemBuilder: (context, index) {
                  final service = servicesList[index];
                  return MenuItemCard(
                    clientUserInfo: userInfo,
                    establishmentUserInfo:
                        userInfo, // Ajuste conforme necessário
                    service: service,
                  );
                },
              ),
      ),
    );
  }
}
