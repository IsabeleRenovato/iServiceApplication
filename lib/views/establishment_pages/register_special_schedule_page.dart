import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/special_schedule.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/special_schedule_services.dart';
import 'package:service_app/utils/text_field_utils.dart';

class RegisterSpecialSchedulePage extends StatefulWidget {
  final UserInfo userInfo;
  final int specialScheduleId;

  const RegisterSpecialSchedulePage(
      {required this.userInfo, required this.specialScheduleId, super.key});

  @override
  State<RegisterSpecialSchedulePage> createState() =>
      _RegisterSpecialSchedulePageState();
}

class _RegisterSpecialSchedulePageState
    extends State<RegisterSpecialSchedulePage> {
  TextEditingController timeStartController = TextEditingController();
  TextEditingController timeEndController = TextEditingController();
  TextEditingController timeBreakStartController = TextEditingController();
  TextEditingController timeBreakEndController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  String mensagemErro = '';
  bool filledFields = false;
  bool _update = false;

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime now = DateTime.now(); // Pega a data atual
    final DateTime tomorrow =
        DateTime(now.year, now.month, now.day + 1); // Calcula o dia de amanhã
    final DateTime sixMonthsLater = DateTime(
        now.year, now.month + 6, now.day); // Calcula a data de 6 meses à frente

    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: tomorrow, // Define a data inicial como amanhã
      firstDate: tomorrow, // Define a primeira data selecionável como amanhã
      lastDate:
          sixMonthsLater, // Define a última data selecionável como daqui a 6 meses
    );

    if (dataEscolhida != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(dataEscolhida);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    timeStartController.addListener(atualizarEstadoCampos);
    timeEndController.addListener(atualizarEstadoCampos);
    dateController.addListener(atualizarEstadoCampos);
    timeBreakStartController.addListener(atualizarEstadoCampos);
    timeBreakEndController.addListener(atualizarEstadoCampos);
  }

  Future<void> fetchData() async {
    if (widget.specialScheduleId > 0) {
      try {
        var specialSchedule =
            await SpecialScheduleServices().getById(widget.specialScheduleId);
        if (specialSchedule!.specialScheduleId > 0) {
          if (mounted) {
            setState(() {
              dateController.text =
                  DateFormat('dd/MM/yyyy').format(specialSchedule.date);
              timeStartController.text = specialSchedule.start;
              timeEndController.text = specialSchedule.end;
              timeBreakStartController.text = specialSchedule.breakStart!;
              timeBreakEndController.text = specialSchedule.breakEnd!;
            });
          }
        }
      } catch (e) {
        debugPrint('Erro ao buscar Special Schedules: $e');
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = timeStartController.text.isNotEmpty &&
          timeEndController.text.isNotEmpty &&
          dateController.text.isNotEmpty;
      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Horário em Dias Especiais",
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
            Navigator.pop(context, _update);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Selecione a data",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: dateController,
                  onTap: () => _selectedDate(context),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Selecione a data',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w100,
                    ),
                    prefixIcon: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.blue, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Selecione o horário de expediente",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Utils.buildTimePickerFormField(
                      context: context,
                      controller: timeStartController,
                      prefixIcon: Icons.access_time,
                      hintText: 'Início',
                    ),
                    const SizedBox(width: 10),
                    Utils.buildTimePickerFormField(
                      context: context,
                      controller: timeEndController,
                      prefixIcon: Icons.history_toggle_off,
                      hintText: 'Término',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Selecione o horário de intervalo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Utils.buildTimePickerFormField(
                      context: context,
                      controller: timeBreakStartController,
                      prefixIcon: Icons.access_time,
                      hintText: 'Início',
                    ),
                    const SizedBox(width: 10),
                    Utils.buildTimePickerFormField(
                      context: context,
                      controller: timeBreakEndController,
                      prefixIcon: Icons.history_toggle_off,
                      hintText: 'Término',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  mensagemErro,
                  style: const TextStyle(color: Colors.red),
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () async {
                    if (filledFields) {
                      try {
                        print(dateController.text);
                        DateFormat format =
                            DateFormat('dd/MM/yyyy'); // Criando o formato
                        DateTime dateConvert =
                            format.parse(dateController.text);
                        var request = SpecialSchedule(
                            specialScheduleId: widget.specialScheduleId,
                            establishmentUserProfileId:
                                widget.userInfo.userProfile!.userProfileId,
                            date: dateConvert,
                            start: timeStartController.text,
                            end: timeEndController.text,
                            breakStart: timeBreakStartController.text,
                            breakEnd: timeBreakEndController.text,
                            active: true,
                            deleted: false,
                            creationDate: DateTime.now(),
                            lastUpdateDate: DateTime.now());

                        await SpecialScheduleServices()
                            .save(request)
                            .then((SpecialSchedule schedule) {
                          _update = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Dados cadastrados com sucesso',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }).catchError((e) {
                          atualizarMensagemErro(
                              'Erro ao registrar servidor: $e');
                        });
                      } catch (error) {
                        atualizarMensagemErro(
                            'Erro ao registrar servidor: $error');
                      }
                    } else {
                      atualizarMensagemErro(
                          'Por favor, preencha todos os campos.');
                    }
                  },
                  color: filledFields ? const Color(0xFF2864ff) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Cadastrar",
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
      ),
    );
  }
}
