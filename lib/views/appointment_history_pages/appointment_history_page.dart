import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/utils/navigationbar.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/appointment.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/appointment_services.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/views/appointment_history_pages/review_page.dart';

class AppointmentHistoryPage extends StatefulWidget {
  const AppointmentHistoryPage({Key? key}) : super(key: key);

  @override
  State<AppointmentHistoryPage> createState() => _AppointmentHistoryPageState();
}

class _AppointmentHistoryPageState extends State<AppointmentHistoryPage>
    with TickerProviderStateMixin {
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

  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserInfo().then((_) {
      setState(() {
        appointmentsFuture = fetchAppointments();
        _isLoading = false;
      });
    });
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
      return const Scaffold(
        backgroundColor: Colors.white, // Define o fundo da tela como branco
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2864ff)),
        ),
      );
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              "Agendamentos",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Color(0xFF2864ff),
            indicatorColor: Color(0xFF2864ff),
            tabs: const [
              Tab(text: 'Agendado'),
              Tab(text: 'Finalizado'),
              Tab(text: 'Cancelado'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFF2864ff))) // Indicador de carregamento
            : FutureBuilder<List<Appointment>>(
                future: appointmentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(
                                0xFF2864ff))); // Indicador de carregamento enquanto espera
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text("Erro ao carregar os dados"));
                  } else if (snapshot.hasData) {
                    var scheduled = snapshot.data!
                        .where((a) => a.appointmentStatusId == 1)
                        .toList()
                      ..sort((a, b) => a.start.compareTo(b.start));

                    var inProgress = snapshot.data!
                        .where((a) => a.appointmentStatusId == 3)
                        .toList()
                      ..sort((a, b) => a.start.compareTo(b.start));

                    var finished = snapshot.data!
                        .where((a) => a.appointmentStatusId == 4)
                        .toList()
                      ..sort((a, b) => a.start.compareTo(b.start));

                    var canceled = snapshot.data!
                        .where((a) => a.appointmentStatusId == 5)
                        .toList()
                      ..sort((a, b) => a.start.compareTo(b.start));

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _userInfo!.userRole.userRoleId ==
                                2 // Condição para mostrar o nested TabController
                            ? DefaultTabController(
                                length: 2, // Número de abas secundárias
                                child: Column(
                                  children: [
                                    TabBar(
                                      controller: _nestedTabController,
                                      labelColor: Color(0xFF2864ff),
                                      indicatorColor: Color(0xFF2864ff),
                                      tabs: const [
                                        Tab(text: 'Novo'),
                                        Tab(text: 'Em Andamento'),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: _nestedTabController,
                                        children: [
                                          AppointmentListView(
                                              userInfo: _userInfo!,
                                              appointments: scheduled,
                                              showIniciarButton: true,
                                              showCancelarButton: true,
                                              onUpdated: refreshData),
                                          AppointmentListView(
                                              userInfo: _userInfo!,
                                              appointments: inProgress,
                                              showEmAndamentoText: true,
                                              showFinalizarButton: true,
                                              onUpdated: refreshData),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : AppointmentListView(
                                userInfo: _userInfo!,
                                appointments: scheduled,
                                showIniciarButton: true,
                                showCancelarButton: true,
                                onUpdated: refreshData,
                              ),
                        AppointmentListView(
                            userInfo: _userInfo!,
                            appointments: finished,
                            showAvaliarButton: true,
                            onUpdated: refreshData),
                        AppointmentListView(
                            userInfo: _userInfo!,
                            appointments: canceled,
                            onUpdated: refreshData),
                      ],
                    );
                  } else {
                    return const Center(
                        child: Text("Nenhum agendamento disponível"));
                  }
                },
              ),
      ),
    );
  }
}

class AppointmentListView extends StatelessWidget {
  final UserInfo userInfo;
  final List<Appointment> appointments;
  final bool showIniciarButton;
  final bool showEmAndamentoText;
  final bool showFinalizarButton;
  final bool showCancelarButton;
  final bool showAvaliarButton;
  final VoidCallback onUpdated;

  const AppointmentListView(
      {required this.userInfo,
      required this.appointments,
      this.showIniciarButton = false,
      this.showEmAndamentoText = false,
      this.showFinalizarButton = false,
      this.showCancelarButton = false,
      this.showAvaliarButton = false,
      required this.onUpdated, // Default é false
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        var appointment = appointments[index];
        var showAvaliar = appointment.appointmentStatusId == 4 &&
            appointment.feedback == null;

        var showIniciar =
            appointment.appointmentStatusId == 1 && showIniciarButton;
        var showEmAndamento =
            appointment.appointmentStatusId == 3 && showEmAndamentoText;
        var showFinalizar =
            appointment.appointmentStatusId == 3 && showFinalizarButton;
        var showCancelar =
            appointment.appointmentStatusId == 1 && showCancelarButton;

        final String formattedDate =
            DateFormat('dd/MM/yyyy').format(appointment.start);
        final String formattedTime =
            DateFormat('HH:mm').format(appointment.start);
        final String duration =
            appointment.end.difference(appointment.start).inMinutes.toString();

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
                    ListTile(
                      title: Text(
                          userInfo.userRole.userRoleId == 3
                              ? appointment.establishmentUserInfo!.userProfile!
                                  .commercialName!
                              : appointment.clientUserInfo!.user.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Serviço: ${appointment.service!.name}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Duração: $duration",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month,
                                color: Colors.black54),
                            const SizedBox(width: 5),
                            Text(formattedDate),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled,
                                color: Colors.black54),
                            const SizedBox(width: 5),
                            Text(formattedTime),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (showAvaliar &&
                            userInfo.userRole.userRoleId == 3 &&
                            showAvaliarButton) // Verifica se showAvaliar é true
                          InkWell(
                            onTap: () async {
                              try {
                                await UserInfoServices()
                                    .getUserInfoByUserId(
                                        appointment.establishmentUserProfileId)
                                    .then((UserInfo establishmentUserInfo) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewPage(
                                            appointment: appointment)),
                                  );
                                });
                              } catch (e) {
                                // Você pode mostrar um alerta ou logar o erro
                                print(
                                    'Erro ao obter informações do usuário: $e');
                              }
                            },
                            child: Container(
                              width: 340,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2864ff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Avaliar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (showIniciar &&
                            userInfo.userRole.userRoleId == 2 &&
                            showIniciarButton)
                          InkWell(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Iniciar agendamento"),
                                    content: const Text(
                                        "Tem certeza de que deseja iniciar o agendamento?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          await AppointmentServices()
                                              .updateAppointmentStatus(
                                                  3, appointment.appointmentId)
                                              .then((bool appointment) {
                                            if (appointment) {
                                              Navigator.of(context).pop();
                                              onUpdated();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Serviço iniciado',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          });
                                        },
                                        child: const Text("Sim"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Não"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 165,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2864ff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Iniciar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (showCancelar)
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Cancelar agendamento"),
                                    content: const Text(
                                        "Tem certeza de que deseja cancelar o agendamento?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          await AppointmentServices()
                                              .updateAppointmentStatus(
                                                  5, appointment.appointmentId)
                                              .then((bool appointment) {
                                            if (appointment) {
                                              Navigator.of(context).pop();
                                              onUpdated();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Serviço cancelado',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          });
                                        },
                                        child: const Text("Sim"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Não"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width:
                                  userInfo.userRole.userRoleId == 2 ? 165 : 340,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(100, 216, 218, 221),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (showEmAndamento)
                          Text(
                            "Em Andamento",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        SizedBox(height: 10),
                        if (showFinalizar)
                          InkWell(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Finalizar agendamento"),
                                    content: const Text(
                                        "Tem certeza de que deseja finalizar o agendamento?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          await AppointmentServices()
                                              .updateAppointmentStatus(
                                                  4, appointment.appointmentId)
                                              .then((bool appointment) {
                                            if (appointment) {
                                              Navigator.of(context).pop();
                                              onUpdated();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Serviço finalizado',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          });
                                        },
                                        child: const Text("Sim"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Não"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 360,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2864ff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Finalizar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
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

enum AppointmentStatusEnum {
  novo,
  confirmado,
  iniciado,
  finalizado,
  cancelado,
}
