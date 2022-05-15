import 'package:flutter/material.dart';
import 'package:test01/utilities/my_colors.dart';

class ListOfPatientsScreen extends StatefulWidget {
  const ListOfPatientsScreen({Key? key}) : super(key: key);

  @override
  State<ListOfPatientsScreen> createState() => _ListOfPatientsScreenState();
}

class _ListOfPatientsScreenState extends State<ListOfPatientsScreen> {
  final List<String> _patients = [
    "adam",
    "ahmad",
    "tala",
    "naia",
    "mirai",
    "ali",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.myGrey,
      appBar: AppBar(
        backgroundColor: MyColor.myPink,
        title: const Text("List Of Waiting Patients"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, index) {
          return _card(_patients[index] , index);
        },
        itemCount: _patients.length,
      ),
    );
  }

  Widget _card(String name , int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          _cardHeader(name),
          _cardBody(),
          _line(),
          _cardTail(index),
        ],
      ),
    );
  }

  Widget _cardHeader(String name) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: CircleAvatar(
            backgroundColor: MyColor.myPink,
            radius: 32,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          name,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _cardBody() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: Text(
        "The medical condition that the patient complains of is...",
        style: TextStyle(
          fontSize: 20,
          height: 1.25,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _cardTail(int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          _patients.removeAt(index);
        });
      },
      child: Text(
        "DELETE",
        style: TextStyle(
          color: Colors.red.shade700,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.only(top: 16.0),
    );
  }
}
