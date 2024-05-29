import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/appointment.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/appointment_services.dart';
import 'package:service_app/services/service_services.dart';
import 'package:service_app/views/appointment_pages/appointment_confirm.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dots_indicator/dots_indicator.dart';

class AppointmentPage extends StatefulWidget {
  final UserInfo clientUserInfo;
  final UserInfo establishmentUserInfo;
  final Service service;

  const AppointmentPage(
      {required this.clientUserInfo,
      required this.establishmentUserInfo,
      required this.service,
      super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime _selectedDay = DateTime.now();
  Future<List<String>> availableTimes = Future.value([]);
  String? _selectedTime;
  final PageController _pageController = PageController();
  double _currentIndex = 0;
  bool filledFields = false;
  String mensagemErro = '';

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    availableTimes = fetchAvailableTimes();
  }

  Future<List<String>> fetchAvailableTimes() async {
    try {
      var availableTimes = await ServiceServices().getAvailableTimes(
          widget.establishmentUserInfo.userProfile!.userProfileId,
          _selectedDay);
      return availableTimes;
    } catch (e) {
      debugPrint('Erro ao buscar serviços: $e');
      return [];
    }
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = _selectedTime != null && _selectedTime!.isNotEmpty;
      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(right: 55.0),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Selecione o',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' dia da semana ',
                      style: TextStyle(
                        color: Color(0xFF2864ff),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'e o',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' horário do atendimento',
                      style: TextStyle(
                        color: Color(0xFF2864ff),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 30 * 6)),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;

                      availableTimes = fetchAvailableTimes();
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontSize: 16),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.black),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.black),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.black),
                    weekendTextStyle: const TextStyle(color: Colors.black),
                    outsideTextStyle: const TextStyle(color: Colors.grey),
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xFF2864ff),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      border:
                          Border.all(color: const Color(0xFF2864ff), width: 1),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(color: Color(0xFF2864ff)),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.black),
                    weekendStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<String>>(
                future: availableTimes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                        color: Color(0xFF2864ff));
                  } else if (snapshot.hasError) {
                    return Text("Erro: ${snapshot.error}");
                  } else if (snapshot.data!.isEmpty) {
                    return const Text("Não há horários disponíveis",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red));
                  } else {
                    var times = snapshot.data ?? [];
                    int gridCount = (times.length / 8).ceil();
                    return gridCount > 0
                        ? Column(
                            children: [
                              SizedBox(
                                height: 120,
                                child: PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentIndex = index.toDouble();
                                    });
                                  },
                                  itemCount: gridCount,
                                  itemBuilder: (context, index) {
                                    int start = index * 8;
                                    int end = (start + 8 > times.length)
                                        ? times.length
                                        : start + 8;
                                    return GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 2,
                                      ),
                                      itemCount: end - start,
                                      itemBuilder: (context, i) {
                                        String time = times[start + i];
                                        return ChoiceChip(
                                          label: Text(time),
                                          selected: _selectedTime == time,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _selectedTime = time;
                                              filledFields =
                                                  _selectedTime != null &&
                                                      _selectedTime!.isNotEmpty;
                                              if (filledFields) {
                                                atualizarMensagemErro('');
                                              } else {
                                                atualizarMensagemErro(
                                                    'Por favor, selecione um horário antes de finalizar.');
                                              }
                                            });
                                          },
                                          selectedColor:
                                              const Color(0xFF2864ff),
                                          labelStyle: TextStyle(
                                            color: _selectedTime == time
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: _selectedTime == time
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                          backgroundColor: Colors.white,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              DotsIndicator(
                                dotsCount: gridCount,
                                position: _currentIndex,
                                decorator: const DotsDecorator(
                                  activeColor: Color(0xFF2864ff),
                                ),
                              ),
                            ],
                          )
                        : Container();
                  }
                },
              ),
              const SizedBox(height: 20),
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () async {
                  if (_selectedTime == null) {
                    atualizarMensagemErro(
                        'Por favor, selecione um horário antes de finalizar.');
                    return;
                  }
                  try {
                    DateFormat timeFormat = DateFormat("HH:mm");
                    DateTime time = timeFormat.parse(_selectedTime!);

                    DateTime startDateTime = DateTime(
                      _selectedDay.year,
                      _selectedDay.month,
                      _selectedDay.day,
                      time.hour,
                      time.minute,
                    );
                    DateTime endDateTime = startDateTime.add(
                        Duration(minutes: widget.service.estimatedDuration));

                    var request = Appointment(
                        appointmentId: 0,
                        serviceId: widget.service.serviceId,
                        clientUserProfileId:
                            widget.clientUserInfo.userProfile!.userProfileId,
                        establishmentUserProfileId: widget
                            .establishmentUserInfo.userProfile!.userProfileId,
                        appointmentStatusId: 1,
                        start: startDateTime,
                        end: endDateTime,
                        active: true,
                        deleted: false,
                        creationDate: DateTime.now(),
                        lastUpdateDate: DateTime.now());

                    await AppointmentServices()
                        .addAppointment(request)
                        .then((Appointment appointment) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => AppointmentConfirm(
                                  userInfo: widget.clientUserInfo,
                                )),
                        (Route<dynamic> route) => false,
                      );
                    }).catchError((e) {
                      atualizarMensagemErro('Erro ao registrar servidor: $e');
                    });
                  } catch (error) {
                    atualizarMensagemErro('Erro ao registrar servidor: $error');
                  }
                },
                color: filledFields ? const Color(0xFF2864ff) : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  "Finalizar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
