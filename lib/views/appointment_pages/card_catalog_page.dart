import 'package:flutter/material.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/views/appointment_pages/service_page.dart';

class CardCatalogPage extends StatelessWidget {
  final UserInfo clientUserInfo;
  final UserInfo establishmentUserInfo;
  final List<Service> services;

  const CardCatalogPage(
      {required this.clientUserInfo,
      required this.establishmentUserInfo,
      required this.services,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        return MenuItemCard(
            clientUserInfo: clientUserInfo,
            establishmentUserInfo: establishmentUserInfo,
            service: services[index]);
      },
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final UserInfo clientUserInfo;
  final UserInfo establishmentUserInfo;
  final Service service;

  const MenuItemCard(
      {required this.clientUserInfo,
      required this.establishmentUserInfo,
      required this.service,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServicePage(
              clientUserInfo: clientUserInfo,
              establishmentUserInfo: establishmentUserInfo,
              service: service,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          service.name.length > 25
                              ? '${service.name.substring(0, 25)}...'
                              : service.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          service.description,
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'R\$ ${service.price}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: 80,
                      height: 80,
                      child: service.serviceImage != null
                          ? Image.network(service.serviceImage!,
                              fit: BoxFit.cover)
                          : Image.asset(
                              'assets/images.png',
                              fit: BoxFit.cover,
                              width: 155,
                              height: 155,
                            )),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
