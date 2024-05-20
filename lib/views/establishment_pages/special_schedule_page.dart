import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/special_schedule.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/special_schedule_services.dart';
import 'package:service_app/views/establishment_pages/register_special_schedule_page.dart';

class SpecialSchedulePage extends StatefulWidget {
  final UserInfo userInfo;

  const SpecialSchedulePage({required this.userInfo, super.key});

  @override
  State<SpecialSchedulePage> createState() => _SpecialSchedulePageState();
}

class _SpecialSchedulePageState extends State<SpecialSchedulePage> {
  void refreshData() {
    fetchData();
  }

  Future<List<SpecialSchedule>> _specialScheduleFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<SpecialSchedule>? specialSchedules = await SpecialScheduleServices()
          .getByUserProfileId(widget.userInfo.userProfile!.userProfileId);

      if (mounted) {
        setState(() {
          _specialScheduleFuture = Future.value(specialSchedules);
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar Special Schedules: $e');

      if (mounted) {
        setState(() {
          _specialScheduleFuture = Future.value([]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Horário em Dia Especial",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () async {
                var _update = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterSpecialSchedulePage(
                            userInfo: widget.userInfo,
                            specialScheduleId: 0,
                          )),
                );
                if (_update) {
                  fetchData();
                }
              },
              child: Container(
                width: 390,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2864ff),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Adicionar um novo horário especial",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SpecialSchedule>>(
              future: _specialScheduleFuture, // Passa o futuro aqui
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Exibe um indicador de carregamento enquanto os dados estão sendo carregados
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Se houver um erro ao carregar os dados, exibe uma mensagem de erro
                  return const Center(child: Text("Erro ao carregar os dados"));
                } else if (snapshot.hasData) {
                  // Uma vez que os dados estão disponíveis, constrói a lista
                  return ListView.builder(
                    itemCount: snapshot.data!
                        .length, // Usa a contagem de itens do snapshot.data
                    itemBuilder: (context, index) {
                      // Usa o dado de snapshot.data[index] para passar ao SchedulesCard
                      return SchedulesCard(
                        userInfo: widget.userInfo,
                        specialDay: snapshot.data![index],
                        onUpdated: refreshData,
                        onDeleted: refreshData,
                      );
                    },
                  );
                } else {
                  // Caso não haja dados, exibe uma mensagem indicando que não há dados
                  return const Center(child: Text("Nenhum dado disponível"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SchedulesCard extends StatelessWidget {
  final UserInfo userInfo;
  final SpecialSchedule specialDay;
  final VoidCallback onUpdated;
  final VoidCallback onDeleted;

  const SchedulesCard({
    super.key,
    required this.userInfo,
    required this.specialDay,
    required this.onUpdated,
    required this.onDeleted, // Requer o callback como um parâmetro
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormat
                  .format(specialDay.date), // Acesso direto ao atributo 'date'
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2864ff),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Horário de funcionamento',
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  specialDay.start,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const Text(
                  " - ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  specialDay.end,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Horário de intervalo',
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  specialDay
                      .breakStart!, // Acesso direto ao atributo 'breakStart'
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const Text(
                  " - ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  specialDay.breakEnd!, // Acesso direto ao atributo 'breakEnd'
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterSpecialSchedulePage(
                          userInfo: userInfo,
                          specialScheduleId: specialDay.specialScheduleId,
                        ),
                      ),
                    );
                    if (result != null && result) {
                      onUpdated(); // Chama o callback após retornar com sucesso
                    }
                  },
                  child: Container(
                    width: 155,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2864ff),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Editar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var result = await SpecialScheduleServices()
                        .delete(specialDay.specialScheduleId);
                    if (result) {
                      onDeleted(); // Chama o callback após retornar com sucesso
                    }
                  },
                  child: Container(
                    width: 155,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(100, 216, 218, 221),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Remover",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
