import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/establishment_employee.dart';
import 'package:service_app/services/establishment_employee_services.dart';
import 'package:service_app/utils/navigationbar.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/appointment.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/appointment_services.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/views/appointment_history_pages/review_page.dart';

class EmployeesListPage extends StatefulWidget {
  const EmployeesListPage({Key? key}) : super(key: key);

  @override
  State<EmployeesListPage> createState() => _EmployeesListPageState();
}

class _EmployeesListPageState extends State<EmployeesListPage>
    with TickerProviderStateMixin {
  Future<List<EstablishmentEmployee?>> _establishmentEmployeeFuture =
      Future.value([]);
  TabController? _tabController;
  TabController? _nestedTabController;
  late UserInfo? _userInfo;
  bool _isLoading = true;
  int _currentIndex = 2;
  late Future<List<Appointment>> appointmentsFuture;
  Map<String, dynamic> payload = {};

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
    _nestedTabController = TabController(vsync: this, length: 2);
    appointmentsFuture = fetchAppointments();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
    fetchUserInfo().then((_) {
      setState(() {
        appointmentsFuture = fetchAppointments();
        _isLoading = false;
      });
    });
  }

  Future<void> fetchData() async {
    try {
      var tokenProvider = Provider.of<TokenProvider>(context, listen: true);
      payload = Jwt.parseJwt(tokenProvider.token!);
      List<EstablishmentEmployee?> serviceEmployees =
          await EstablishmentEmployeeServices().getEmployeeByUserProfileId();

      if (mounted) {
        setState(() {
          _establishmentEmployeeFuture = Future.value(serviceEmployees);
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar Service Categories: $e');
      if (mounted) {
        setState(() {
          _establishmentEmployeeFuture = Future.value([]);
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _nestedTabController?.dispose();
    super.dispose();
  }

  Future<UserInfo?> fetchUserInfo() async {
    Stopwatch stopwatch = Stopwatch()..start();
    var tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    var payload = Jwt.parseJwt(tokenProvider.token!);

    if (payload['UserId'] != null) {
      int userId = int.tryParse(payload['UserId'].toString()) ?? 0;
      try {
        UserInfo userInfo =
            await UserInfoServices().getUserInfoByUserId(userId);
        _userInfo = userInfo;
      } catch (e) {
        print("Error fetching user info: $e");
      }
    }
    stopwatch.stop();
    print('UserInfo ${stopwatch.elapsed}');
    return null;
  }

  Future<List<Appointment>> fetchAppointments() async {
    Stopwatch stopwatch = Stopwatch()..start();
    if (_userInfo == null) {
      print("nulo");
    }
    try {
      var services = await AppointmentServices().getAllAppointments(
          _userInfo!.userRole.userRoleId,
          _userInfo!.userProfile!.userProfileId);
      stopwatch.stop();
      print('Appointments ${stopwatch.elapsed}');
      return services;
    } catch (e) {
      debugPrint('Erro ao buscar serviços: $e');
      return [];
    }
  }

  void refreshData() {
    setState(() {
      appointmentsFuture = fetchAppointments();
    });
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
          child: Text(
            "Funcionários",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF2864ff))) // Indicador de carregamento
          : FutureBuilder<List<EstablishmentEmployee?>>(
              future: _establishmentEmployeeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2864ff)),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navegue para a página de cadastro de funcionários
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CadastroFuncionarioPage(),
                              ),
                            );
                          },
                          child: const Text('Cadastrar um funcionário'),
                          style: ElevatedButton.styleFrom(
                            // Cor do botão
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: EmployeeListView(
                          userInfo: _userInfo!,
                          employees: snapshot.data!,
                          onUpdated:
                              refreshData, // Chama refreshData para atualizar
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('Nenhuma categoria de serviço cadastrada.'),
                  );
                }
              },
            ),
    );
  }
}

class EmployeeListView extends StatelessWidget {
  final UserInfo userInfo;
  final List<EstablishmentEmployee?> employees;

  final VoidCallback onUpdated;

  const EmployeeListView(
      {required this.userInfo,
      required this.employees,
      required this.onUpdated, // Default é false
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        var employee = employees[index];
        final String formattedDate = employee!.dateOfBirth != null
            ? DateFormat('dd/MM/yyyy').format(employee!.dateOfBirth!)
            : 'Data não disponível';
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(top: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 25),
                        // Adicione o CircularAvatar aqui
                        CircleAvatar(
                          radius: 40, // Ajuste o tamanho conforme necessário
                          backgroundImage: employee!.employeeImage != null
                              ? NetworkImage(
                                  employee!.employeeImage ?? 'URL_INVALIDA',
                                  scale: 1.0,
                                )
                              : AssetImage('assets/images.png')
                                  as ImageProvider, // Ou use uma imagem local
                        ),
                        const SizedBox(
                            width: 10), // Espaçamento entre o avatar e o texto
                        Expanded(
                          child: ListTile(
                            title: Text(employee!.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(employee.document,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(formattedDate,
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {},
                          child: Container(
                            width: 165,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2864ff),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Editar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 165,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Excluir',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Exemplo de página de cadastro de funcionários
class CadastroFuncionarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Funcionário"),
      ),
      body: Center(
        child: Text(
            "Aqui você pode adicionar o formulário de cadastro de funcionários."),
      ),
    );
  }
}
