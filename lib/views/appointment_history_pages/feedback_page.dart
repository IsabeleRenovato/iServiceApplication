import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:service_app/models/user_info.dart';

class FeedbackPage extends StatefulWidget {
  final UserInfo userInfo;

  const FeedbackPage({required this.userInfo, super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(height: 10),
                Text('Wasilij Smith',
                    style: TextStyle(color: Colors.black, fontSize: 24)),
                SizedBox(height: 5),
                Text('Serviço',
                    style: TextStyle(color: Colors.black54, fontSize: 18)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Duração',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                    Text('Valor',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Duração',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    Text('Valor',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 40),
                const Text('How is your trip?', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Additional comment',
                  ),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {},
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
    );
  }
}
