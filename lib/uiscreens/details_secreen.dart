import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class DetailsSecreen extends StatefulWidget {
  const DetailsSecreen({super.key});

  @override
  State<DetailsSecreen> createState() => _DetailsSecreenState();
}

class _DetailsSecreenState extends State<DetailsSecreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Incident Details"),leading:IconButton(onPressed: (){
        Beamer.of(context).beamToNamed('/home/readincidents');
      },icon: Icon(Icons.arrow_back_ios)) ,),
      body: SafeArea(child: Column(
        children: [],
      )),
    );
  }
}