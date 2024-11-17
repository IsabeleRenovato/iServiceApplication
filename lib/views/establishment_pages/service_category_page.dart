import 'package:flutter/material.dart';
import 'package:service_app/models/service_category.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/service_category_services.dart';
import 'package:service_app/views/establishment_pages/register_service_category_page.dart';

class ServiceCategoryPage extends StatefulWidget {
  final UserInfo userInfo;

  const ServiceCategoryPage({required this.userInfo, super.key});

  @override
  State<ServiceCategoryPage> createState() => _ServiceCategoryPageState();
}

class _ServiceCategoryPageState extends State<ServiceCategoryPage> {
  Future<List<ServiceCategory>> _serviceCategoriesFuture = Future.value([]);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void refreshData() {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<ServiceCategory> serviceCategories = await ServiceCategoryServices()
          .getByUserProfileId(widget.userInfo.userProfile!.userProfileId);

      if (mounted) {
        setState(() {
          _serviceCategoriesFuture = Future.value(serviceCategories);
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar Service Categories: $e');
      if (mounted) {
        setState(() {
          _serviceCategoriesFuture = Future.value([]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2864ff)),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterServiceCategoryPage(
                          userInfo: widget.userInfo)),
                );
                if (result == true) {
                  fetchData();
                }
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
            child: FutureBuilder<List<ServiceCategory>>(
              future: _serviceCategoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF2864ff)));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final serviceCategory = snapshot.data![index];
                        return SchedulesCard(
                          serviceCategory: serviceCategory,
                          onDeleted: refreshData,
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child:
                            Text('Nenhuma categoria de serviço cadastrada.'));
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SchedulesCard extends StatelessWidget {
  final ServiceCategory serviceCategory;
  final VoidCallback onDeleted;

  const SchedulesCard(
      {super.key, required this.serviceCategory, required this.onDeleted});

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
                  serviceCategory.name,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(100, 216, 218, 221),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.black,
                      onPressed: () async {
                        var result = await ServiceCategoryServices()
                            .deleteServiceCategory(
                                serviceCategory.serviceCategoryId);
                        if (result) {
                          onDeleted();
                        }
                      },
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
