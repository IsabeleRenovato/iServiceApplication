import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:service_app/models/appointment.dart';
import 'package:service_app/models/feedback.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/feedback_services.dart';
import 'package:service_app/utils/clip_path_widget.dart';
import 'package:service_app/views/main_pages/client_main_page.dart';

class ReviewPage extends StatefulWidget {
  final UserInfo userInfo;
  final Appointment appointment;

  const ReviewPage(
      {required this.userInfo, required this.appointment, super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _rating = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const ClipPathWidget(),
            Positioned(
              top: 300,
              left: -187,
              child: Opacity(
                opacity: 0.9,
                child: Image.asset('assets/foto_perfil.png'),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                              color: Colors.white),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 50),
                        const Text(
                          'Avalie o serviço!',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                    ),
                    const SizedBox(height: 10),
                    const Text('Estabelecimento',
                        style: TextStyle(color: Colors.black, fontSize: 24)),
                    const SizedBox(height: 5),
                    const Text('Serviço',
                        style: TextStyle(color: Colors.black54, fontSize: 18)),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Duração',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16)),
                              Text('Valor',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16)),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Duração',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              Text('Valor',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Text('Como foi o seu atendimento?',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 10),
                          RatingBar.builder(
                            initialRating: _rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, index) {
                              return Icon(
                                _rating > index
                                    ? Icons.star
                                    : Icons.star_border,
                                color: _rating > index
                                    ? const Color(0xFF2864ff)
                                    : const Color(0xFF2864ff),
                              );
                            },
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          const TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(), // Borda padrão
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF2864ff), width: 2.0),
                              ),
                              labelText: 'Comentário adicional',
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () async {
                              var request = FeedbackModel(
                                  feedbackId: 0,
                                  appointmentId:
                                      widget.appointment.appointmentId,
                                  rating: _rating,
                                  active: true,
                                  deleted: false,
                                  creationDate: DateTime.now(),
                                  lastUpdateDate: DateTime.now());

                              await FeedbackServices()
                                  .addFeeback(request)
                                  .then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ClientMainPage(
                                            userInfo: widget.userInfo)));
                              });
                            },
                            color: const Color(0xFF2864ff),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: const Text("Estabelecimento",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
