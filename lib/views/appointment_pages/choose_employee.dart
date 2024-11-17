import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/appointment.dart';
import 'package:service_app/models/establishment_employee.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/appointment_services.dart';
import 'package:service_app/services/establishment_employee_services.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:service_app/views/appointment_pages/appointment_confirm.dart';

class ChooseEmployeePage extends StatefulWidget {
  final Appointment appointment;
  final UserInfo clientUserInfo;
  final UserInfo establishmentUserInfo;

  const ChooseEmployeePage(
      {required this.appointment,
      required this.clientUserInfo,
      required this.establishmentUserInfo,
      super.key});

  @override
  State<ChooseEmployeePage> createState() => _ChooseEmployeePageState();
}

class _ChooseEmployeePageState extends State<ChooseEmployeePage> {
  String mensagemErro = '';
  bool filledFields = false;
  late List<EstablishmentEmployee> employees = [];
  EstablishmentEmployee? selectedEmployee;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<EstablishmentEmployee> serviceEmployees =
          await EstablishmentEmployeeServices().getListAvailableRequest(
              widget.appointment.serviceId, widget.appointment.start);

      serviceEmployees.sort((a, b) =>
          (a.name.toLowerCase() ?? '').compareTo(b.name.toLowerCase() ?? ''));

      if (mounted) {
        setState(() {
          employees = serviceEmployees;
          if (employees.isEmpty) {
            mensagemErro =
                'Não há funcionários disponíveis para o dia e horário escolhidos';
          } else {
            mensagemErro = '';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          employees = [];
          mensagemErro =
              'Erro ao buscar funcionários. Tente novamente mais tarde.';
        });
      }
    }
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
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
                            text: ' funcionário ',
                            style: TextStyle(
                              color: Color(0xFF2864ff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'desejado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (employees.isNotEmpty) ...[
                      Column(
                        children: employees.map((employee) {
                          return RadioListTile<EstablishmentEmployee>(
                            title: Text(employee.name),
                            value: employee,
                            groupValue: selectedEmployee,
                            onChanged: employee.isAvailable == true
                                ? (EstablishmentEmployee? value) {
                                    setState(() {
                                      selectedEmployee = value;
                                    });
                                  }
                                : null,
                            activeColor: employee.isAvailable == true
                                ? Color(0xFF2864ff)
                                : Colors.grey,
                          );
                        }).toList(),
                      ),
                    ] else ...[
                      Text(
                        mensagemErro,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 10),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        if (selectedEmployee == null) {
                          setState(() {
                            mensagemErro =
                                'Por favor, selecione um funcionário.';
                          });
                        } else {
                          setState(() {
                            mensagemErro = '';
                          });
                          widget.appointment.establishmentEmployeeId =
                              selectedEmployee!.establishmentEmployeeId;
                          await AppointmentServices()
                              .addAppointment(widget.appointment)
                              .then((Appointment appointment) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => AppointmentConfirm(
                                        clientUserInfo: widget.clientUserInfo,
                                        establishmentUserInfo:
                                            widget.establishmentUserInfo,
                                      )),
                              (Route<dynamic> route) => false,
                            );
                          }).catchError((e) {
                            atualizarMensagemErro(
                                'Erro ao registrar servidor: $e');
                          });
                        }
                      },
                      color: selectedEmployee != null
                          ? const Color(0xFF2864ff)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Avançar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          mensagemErro = '';
                        });
                        widget.appointment.establishmentEmployeeId = 0;

                        await AppointmentServices()
                            .addAppointment(widget.appointment)
                            .then((Appointment appointment) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => AppointmentConfirm(
                                clientUserInfo: widget.clientUserInfo,
                                establishmentUserInfo:
                                    widget.establishmentUserInfo,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }).catchError((e) {
                          atualizarMensagemErro(
                              'Erro ao registrar servidor: $e');
                        });
                      },
                      child: const Text(
                        "Pular",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
