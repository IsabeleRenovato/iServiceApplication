import 'package:flutter/material.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/views/establishment_pages/register_service_category_page.dart';

class ServiceCategoryPage extends StatefulWidget {
  final UserInfo userInfo;

  const ServiceCategoryPage({required this.userInfo, super.key});

  @override
  State<ServiceCategoryPage> createState() => _ServiceCategoryPageState();
}

class _ServiceCategoryPageState extends State<ServiceCategoryPage> {
  List<Map<String, String>> specialDaysList = [];

  @override
  void initState() {
    super.initState();
    _loadSpecialDays();
  }

  void _loadSpecialDays() {
    // Dados falsos para simular
    specialDaysList = [
      {
        'category': 'Corte',
      },
      {
        'category': 'Barbear',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Categorias de Serviço",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterServiceCategoryPage(
                          userInfo: widget.userInfo)),
                );
              },
              child: Container(
                width: 390,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2864ff),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Adicionar uma categoria",
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
          Expanded(
            child: ListView.builder(
              itemCount: specialDaysList.length,
              itemBuilder: (context, index) {
                return SchedulesCard(specialDay: specialDaysList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SchedulesCard extends StatelessWidget {
  final Map<String, String> specialDay;

  const SchedulesCard({super.key, required this.specialDay});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  specialDay['category']!,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    // Ação para Remover
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(
                          100, 216, 218, 221), // Cor de fundo do botão
                      shape: BoxShape.circle, // Forma circular
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete), // Ícone de lixeira
                      color: Colors.black, // Cor do ícone
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
