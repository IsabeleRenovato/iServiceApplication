import 'package:flutter/material.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/service_services.dart';
import 'package:service_app/views/establishment_pages/register_service_page.dart';

class ServiceCardPage extends StatelessWidget {
  final UserInfo userInfo;
  final Service service;
  final VoidCallback onUpdated;
  final VoidCallback onDeleted;

  const ServiceCardPage(
      {required this.userInfo,
      required this.service,
      required this.onUpdated,
      required this.onDeleted,
      super.key});

  @override
  Widget build(BuildContext context) {
    // Obtendo a largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    // Definindo a largura responsiva com base na largura da tela
    final imageWidth = screenWidth * 0.4; // 40% da largura da tela
    final buttonWidth = screenWidth * 0.4; // 40% da largura da tela

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              width: imageWidth,
              height: imageWidth, // Tornando a imagem quadrada
              alignment: Alignment.center,
              child: service.serviceImage == null
                  ? Image.asset(
                      'assets/images.png',
                      fit: BoxFit.cover,
                      width: imageWidth,
                      height: imageWidth,
                    ) // Imagem padrão
                  : Image.network(
                      service.serviceImage!,
                      fit: BoxFit.cover,
                      width: imageWidth,
                      height: imageWidth,
                    ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            service.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16, // Reduzindo o tamanho do texto
            ),
          ),
          Text(
            '${service.estimatedDuration} Minutos',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              thickness: 1,
              height: 25,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterServicePage(
                        userInfo: userInfo,
                        serviceId: service.serviceId,
                      ),
                    ),
                  );
                  if (result != null && result) {
                    onUpdated(); // Chama o callback após retornar com sucesso
                  }
                },
                child: Container(
                  width: buttonWidth,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2864ff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Editar",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  var result =
                      await ServiceServices().delete(service.serviceId);
                  if (result) {
                    onUpdated(); // Chama o callback após retornar com sucesso
                  }
                },
                child: Container(
                  width: buttonWidth,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(100, 216, 218, 221),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Remover",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
