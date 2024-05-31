import 'package:flutter/material.dart';
import 'package:service_app/models/establishment_category.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/establishment_category_services.dart';
import 'package:service_app/views/appointment_pages/establishment_category_page.dart';

class SearchPage extends StatefulWidget {
  final UserInfo userInfo;

  const SearchPage({required this.userInfo, super.key});

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

  @override
  void initState() {
    super.initState();
    fetchData();
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

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    _isSearchSelected = true;
                  });
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
                                          clientUserInfo: widget.userInfo,
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
}
