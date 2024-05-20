import 'package:flutter/material.dart';
import 'package:service_app/models/establishment_category.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/user_profile.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/services/user_profile_services.dart';
import 'package:service_app/views/appointment_pages/establishment_catalog_page.dart';

class EstablishmentCategoryPage extends StatefulWidget {
  final UserInfo clientUserInfo;
  final EstablishmentCategory establishmentCategory;

  const EstablishmentCategoryPage(
      {required this.clientUserInfo,
      required this.establishmentCategory,
      super.key});

  @override
  State<EstablishmentCategoryPage> createState() =>
      _EstablishmentCategoryPageState();
}

class _EstablishmentCategoryPageState extends State<EstablishmentCategoryPage> {
  late Future<List<UserProfile>> listaEstabelecimentos = Future.value([]);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var userProfiles = await UserProfileServices()
          .getByEstablishmentCategoryId(
              widget.establishmentCategory.establishmentCategoryId);

      if (userProfiles.isNotEmpty && mounted) {
        setState(() {
          listaEstabelecimentos = Future.value(userProfiles);
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar estabelecimentos: $e');
    }
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
              "Categoria",
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
      body: FutureBuilder<List<UserProfile>>(
        future: listaEstabelecimentos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar os dados"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                UserProfile establishmentProfile = snapshot.data![index];
                return GestureDetector(
                  onTap: () async {
                    await UserInfoServices()
                        .getUserInfoByUserId(establishmentProfile.userId)
                        .then((UserInfo establishmentUserInfo) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EstablishmentCatalogPage(
                              clientUserInfo: widget.clientUserInfo,
                              establishmentUserInfo: establishmentUserInfo),
                        ),
                      );
                    });
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 0.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                              establishmentProfile.profileImage ??
                                  'URL_INVALIDA',
                              scale: 1.0,
                            ),
                            onBackgroundImageError: (exception, stackTrace) {
                              // Aqui você pode logar o erro se necessário
                            },
                            // Adicionando um filho ao CircleAvatar com a imagem de asset como fallback
                            child: establishmentProfile.profileImage == null
                                ? Image.asset('assets/testeCorte.jpeg',
                                    fit: BoxFit.cover)
                                : null,
                          ),
                          title: Text(establishmentProfile.commercialName!),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: [
                                Text(
                                  establishmentProfile.rating != null
                                      ? '${establishmentProfile.rating!.value.toStringAsFixed(1)} ★'
                                      : "Sem Avaliação", // Use a avaliação real aqui
                                  style:
                                      const TextStyle(color: Color(0xFFe6ac27)),
                                ),
                                Text('  ${widget.establishmentCategory.name}'),
                              ]),
                              const SizedBox(height: 4.0),
                            ],
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.grey[300]),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Nenhum dado disponível"));
          }
        },
      ),
    );
  }
}
