import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/establishment_category.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/establishment_category_services.dart';
import 'package:service_app/services/service_services.dart';
import 'package:service_app/utils/navigationbar.dart';
import 'package:service_app/views/appointment_pages/establishment_category_page.dart';
import 'package:service_app/views/appointment_pages/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static final List<Color> colors = [
    Colors.pink,
    Colors.red,
    Color.fromARGB(255, 216, 198, 40),
    Colors.blue,
    Colors.green
  ];
  static final List<IconData> icons = [
    Icons.spa,
    Icons.content_cut,
    Icons.local_hospital,
  ];

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchSelected = false;
  late Future<List<EstablishmentCategory>> _categoryFuture = Future.value([]);
  int _currentPage = 2;
  int _totalPages = 1;
  int _pageSize = 1;
  String _searchText = "";
  bool _isLoading = true;
  late List<Service> _servicesList = [];
  int _currentIndex = 1;
  late UserInfo _userInfo;
  Map<String, dynamic> payload = {};
  Map<String, dynamic> initialData = {};

  @override
  void initState() {
    super.initState();
    fetchData().then((_) {
      fetchUserInfo().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  Future<void> fetchDataSearch() async {
    try {
      var services = await ServiceServices()
          .getServiceBySearch(_searchText, _currentPage, _pageSize);
      setState(() {
        _servicesList = services;
      });
    } catch (e) {
      debugPrint('Erro ao buscar serviços: $e');
      setState(() {
        _servicesList = [];
      });
    }
  }

  Future<void> fetchData() async {
    try {
      var establishmentCategories = await EstablishmentCategoryServices().get();
      if (establishmentCategories.isNotEmpty) {
        if (mounted) {
          setState(() {
            _categoryFuture = Future.value(establishmentCategories);
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar Special Schedules: $e');
    }
  }

  Future<void> fetchUserInfo() async {
    var tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    payload = Jwt.parseJwt(tokenProvider.token!);
    print(payload);
    if (payload['UserId'] != null) {
      int userId = int.tryParse(payload['UserId'].toString()) ?? 0;
      await UserInfoServices()
          .getUserInfoByUserId(userId)
          .then((UserInfo userInfo) {
        setState(() {
          _userInfo = userInfo;
        });
      }).catchError((e) {
        print('Erro ao buscar UserInfo: $e ');
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearch() {
    setState(() {
      _isLoading = true;
    });

    fetchDataSearch().then((_) {
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(
            userInfo: _userInfo,
            searchText: _searchText,
            servicesList: _servicesList, // Passar a lista para a próxima página
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white, // Define o fundo da tela como branco
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2864ff)),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Busca",
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
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _isSearchSelected ? Colors.grey[200] : Colors.grey[200],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: "Buscar",
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF2864ff)),
                  suffixIcon: _isSearchSelected
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _searchFocusNode.unfocus();
                            setState(() {
                              _isSearchSelected = false;
                              _searchText = "";
                            });
                          },
                          icon: const Icon(Icons.cancel,
                              color: Color(0xFF2864ff)),
                        )
                      : null,
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value; // Atualiza a variável
                    _isSearchSelected = true;
                  });
                  print(
                      "Texto atual do campo: $_searchText"); // Verifique se o texto está sendo atualizado
                },
                onSubmitted: (value) {
                  _onSearch();
                },
                onTap: () {
                  setState(() {
                    _isSearchSelected = true;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<EstablishmentCategory>>(
              future: _categoryFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var categories = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.9,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        var category = categories[index].name;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EstablishmentCategoryPage(
                                          clientUserInfo: _userInfo,
                                          establishmentCategory:
                                              categories[index])),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: SearchPage
                                  .colors[index % SearchPage.colors.length],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    SearchPage
                                        .icons[index % SearchPage.icons.length],
                                    size: 25,
                                    color: SearchPage.colors[
                                        index % SearchPage.colors.length],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  category,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Erro ao carregar dados"));
                } else {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF2864ff)));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed:
              _currentPage > 1 ? () => _loadPage(_currentPage - 1) : null,
          child: const Text('Anterior'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _currentPage < _totalPages
              ? () => _loadPage(_currentPage + 1)
              : null,
          child: const Text('Próximo'),
        ),
      ],
    );
  }

  void _loadPage(int page) {
    setState(() {
      _currentPage = page;
      //fetchData(page: page);
    });
  }
}
