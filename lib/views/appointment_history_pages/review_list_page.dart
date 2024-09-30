import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/user_info_services.dart';

class ReviewListPage extends StatefulWidget {
  final int userId;

  const ReviewListPage({required this.userId, super.key});

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  List<Map<String, dynamic>> ratings = [];
  UserInfo? establishmentUserInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeedbacks().then((result) {
      setState(() {
        ratings = result;
        _isLoading = false;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchFeedbacks() async {
    try {
      UserInfo userInfo =
          await UserInfoServices().getUserInfoByUserId(widget.userId);
      establishmentUserInfo = userInfo;
      if (userInfo.userProfile!.rating != null) {
        List<Map<String, dynamic>> feedbacks =
            userInfo.userProfile!.rating!.feedback.map((feedback) {
          return {
            'name': feedback.name,
            'rating': feedback.rating,
            'date': DateFormat('dd/MM/yyyy').format(feedback.creationDate)
          };
        }).toList();
        return feedbacks;
      }
    } catch (e) {
      print('Erro ao buscar feedbacks: $e');
    }
    return []; // Retorna uma lista vazia se alguma condição não for atendida ou houver exceção
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white, // Define o fundo da tela como branco
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
              "Avaliações",
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFeedbacks(), // Chamada do método fetchFeedbacks
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Color(0xFF2864ff)));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar os dados"));
          } else if (snapshot.hasData) {
            ratings = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        establishmentUserInfo!.userProfile!.rating != null
                            ? establishmentUserInfo!.userProfile!.rating!.value
                                .toStringAsFixed(1)
                            : '0',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        establishmentUserInfo!.userProfile!.rating != null
                            ? '${establishmentUserInfo!.userProfile!.rating!.total} avaliações'
                            : 'Sem avaliações',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: ratings.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 0.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: ListTile(
                              title: Text(ratings[index]['name'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${ratings[index]['rating']} ',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  ...List.generate(
                                      5,
                                      (idx) => Icon(Icons.star,
                                          color: idx < ratings[index]['rating']
                                              ? Colors.orange
                                              : Colors.grey[300],
                                          size: 20)),
                                ],
                              ),
                              trailing: Text(ratings[index]['date'],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[300],
                            height: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Nenhum dado disponível"));
          }
        },
      ),
    );
  }
}
