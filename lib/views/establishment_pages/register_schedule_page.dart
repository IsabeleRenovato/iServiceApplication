import 'package:flutter/material.dart';
import 'package:service_app/models/schedule.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/schedule_services.dart';
import 'package:service_app/utils/text_field_utils.dart';

class RegisterSchedulePage extends StatefulWidget {
  final UserInfo userInfo;

  const RegisterSchedulePage({required this.userInfo, super.key});

  @override
  State<RegisterSchedulePage> createState() => _RegisterSchedulePageState();
}

class _RegisterSchedulePageState extends State<RegisterSchedulePage> {
  bool _isLoading = true;
  TextEditingController timeStartController = TextEditingController();
  TextEditingController timeEndController = TextEditingController();
  TextEditingController timeBreakStartController = TextEditingController();
  TextEditingController timeBreakEndController = TextEditingController();
  String mensagemErro = '';
  bool filledFields = false;
  int scheduleId = 0;
  _DiasDaSemanaState diasDaSemana = _DiasDaSemanaState();
  List<bool> _selectedDays = [false, false, false, false, false, false, false];

// Use isso para atualizar _selectedDays sempre que eles mudarem:
  void _updateSelectedDays(List<bool> selectedDays) {
    setState(() {
      _selectedDays = selectedDays;
    });
  }

// Método para obter os dias selecionados como string:
  String _getSelectedDaysAsString() {
    List<int> diasSelecionadosIndices = [];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) {
        diasSelecionadosIndices.add(i);
      }
    }
    return diasSelecionadosIndices.join(',');
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((_) {
      setState(() {
        _isLoading =
            false; // Atualiza o estado para refletir que o loading está completo
      });
    });
    timeStartController.addListener(atualizarEstadoCampos);
    timeEndController.addListener(atualizarEstadoCampos);
    timeBreakStartController.addListener(atualizarEstadoCampos);
    timeBreakEndController.addListener(atualizarEstadoCampos);
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = timeStartController.text.isNotEmpty &&
          timeEndController.text.isNotEmpty;
      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  Future<void> fetchData() async {
    if (widget.userInfo.userProfile != null) {
      try {
        Schedule? schedule = await ScheduleServices()
            .getByUserProfileId(widget.userInfo.userProfile!.userProfileId);
        if (schedule != null) {
          setState(() {
            initSelectedDays(schedule.days);
            timeStartController.text = schedule.start;
            timeEndController.text = schedule.end;
            timeBreakStartController.text = schedule.breakStart ?? "";
            timeBreakEndController.text = schedule.breakEnd ?? "";
            scheduleId = schedule.scheduleId;
            _updateSelectedDays(List.generate(
                7,
                (index) => schedule.days.split(',').contains(index
                    .toString()))); // Convertendo dias em formato de string para List<bool>
          });
        }
      } catch (e) {
        print('Error fetching schedule: $e');
      }
    }
  }

  void initSelectedDays(String? selectedDays) {
    // Primeiro, reinicie todos os valores para false
    _selectedDays.fillRange(0, _selectedDays.length, false);

    // Verifique se a string não é nula e não está vazia
    if (selectedDays != null && selectedDays.isNotEmpty) {
      var indices = selectedDays.split(',').map(int.parse);
      for (var index in indices) {
        if (index >= 0 && index < _selectedDays.length) {
          _selectedDays[index] = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF2864ff)));
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Horário de Funcionamento",
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
                    "Selecione os dias da semana",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DiasDaSemana(
                  onUpdateSelectedDays: _updateSelectedDays,
                  initialSelectedDays: _selectedDays,
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
                    "Selecione o horário de intervalo (Opcional)",
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
                      var request = Schedule(
                          scheduleId: scheduleId,
                          establishmentUserProfileId:
                              widget.userInfo.userProfile!.userProfileId,
                          days: _getSelectedDaysAsString(),
                          start: timeStartController.text,
                          end: timeEndController.text,
                          breakStart: timeBreakStartController.text,
                          breakEnd: timeBreakEndController.text,
                          active: true,
                          deleted: false,
                          creationDate: DateTime.now(),
                          lastUpdateDate: DateTime.now());

                      await ScheduleServices()
                          .save(request)
                          .then((Schedule schedule) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Dados editados com sucesso',
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
                      });
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

class DiasDaSemana extends StatefulWidget {
  final Function(List<bool>) onUpdateSelectedDays;
  final List<bool>
      initialSelectedDays; // Aceita uma lista de booleanos diretamente

  const DiasDaSemana({
    required this.onUpdateSelectedDays,
    required this.initialSelectedDays, // Agora é um parâmetro obrigatório
    super.key,
  });

  @override
  State<DiasDaSemana> createState() => _DiasDaSemanaState();
}

class _DiasDaSemanaState extends State<DiasDaSemana> {
  List<bool> _diasSelecionados =
      List.filled(7, false); // Inicialização direta com valores padrão.

  @override
  void initState() {
    super.initState();
    _diasSelecionados = List.from(widget.initialSelectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < 7; i++)
          GestureDetector(
            onTap: () {
              setState(() {
                _diasSelecionados[i] = !_diasSelecionados[i];
              });
              widget.onUpdateSelectedDays(_diasSelecionados);
            },
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: _diasSelecionados[i]
                    ? const Color(0xFF2864ff)
                    : Colors.white,
                border: Border.all(
                    color: _diasSelecionados[i]
                        ? const Color(0xFF2864ff)
                        : Colors.black54),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _nomeDiaSemana(i),
                style: TextStyle(
                    color: _diasSelecionados[i] ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  String _nomeDiaSemana(int index) {
    switch (index) {
      case 0:
        return 'Seg';
      case 1:
        return 'Ter';
      case 2:
        return 'Qua';
      case 3:
        return 'Qui';
      case 4:
        return 'Sex';
      case 5:
        return 'Sáb';
      case 6:
        return 'Dom';
      default:
        return '';
    }
  }

  String _getDiasSelecionados() {
    List<int> diasSelecionados = [];
    for (int i = 0; i < _diasSelecionados.length; i++) {
      if (_diasSelecionados[i]) {
        diasSelecionados.add(i);
      }
    }
    return diasSelecionados.join(', ');
  }
}
