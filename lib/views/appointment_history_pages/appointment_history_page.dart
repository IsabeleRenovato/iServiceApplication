import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/appointment.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/appointment_services.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/views/appointment_history_pages/review_page.dart';

class AppointmentHistoryPage extends StatefulWidget {
  final UserInfo userInfo;

  const AppointmentHistoryPage({required this.userInfo, super.key});

  @override
  State<AppointmentHistoryPage> createState() => _AppointmentHistoryPageState();
}

class _AppointmentHistoryPageState extends State<AppointmentHistoryPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<Appointment>> appointmentsFuture;

  @override
  void initState() {
    super.initState();
    appointmentsFuture = fetchAppointments();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<List<Appointment>> fetchAppointments() async {
    try {
      var services = await AppointmentServices().getAllAppointments(
          widget.userInfo.userRole.userRoleId,
          widget.userInfo.userProfile!.userProfileId);
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
    return Scaffold(
      appBar: AppBar(
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
      body: FutureBuilder<List<Appointment>>(
        future: appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2864ff)));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar os dados"));
          } else if (snapshot.hasData) {
            var scheduled = snapshot.data!
                .where((a) => a.appointmentStatusId == 1)
                .toList();
            var finished = snapshot.data!
                .where((a) => a.appointmentStatusId == 2)
                .toList();
            var canceled = snapshot.data!
                .where((a) => a.appointmentStatusId == 3)
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                AppointmentListView(
                    userInfo: widget.userInfo,
                    appointments: scheduled,
                    showCancelarButton: true,
                    onUpdated: refreshData),
                AppointmentListView(
                    userInfo: widget.userInfo,
                    appointments: finished,
                    showAvaliarButton: true,
                    onUpdated: refreshData),
                AppointmentListView(
                    userInfo: widget.userInfo,
                    appointments: canceled,
                    onUpdated: refreshData),
              ],
            );
          } else {
            return const Center(child: Text("Nenhum agendamento disponível"));
          }
        },
      ),
    );
  }
}

class AppointmentListView extends StatelessWidget {
  final UserInfo userInfo;
  final List<Appointment> appointments;
  final bool showCancelarButton;
  final bool showAvaliarButton;
  final VoidCallback onUpdated;

  const AppointmentListView(
      {required this.userInfo,
      required this.appointments,
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
        var showAvaliar = appointment.appointmentStatusId == 2 &&
            appointment.feedback == null;
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
                              await UserInfoServices()
                                  .getUserInfoByUserId(
                                      appointment.establishmentUserProfileId)
                                  .then((UserInfo establishmentUserInfo) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReviewPage(
                                          clientUserInfo: userInfo,
                                          establishmentUserInfo:
                                              establishmentUserInfo,
                                          appointment: appointment)),
                                );
                              });
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
                                              .cancelAppointment(
                                                  userInfo.userRole.userRoleId,
                                                  appointment.appointmentId)
                                              .then((bool status) {
                                            if (status) {
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
                              width: 340,
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
