import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../model/incident_model.dart';

class DetailsSecreen extends StatefulWidget {
  final Incident? incident;
  const DetailsSecreen({super.key, this.incident});

  @override
  State<DetailsSecreen> createState() => _DetailsSecreenState();
}

class _DetailsSecreenState extends State<DetailsSecreen> {
  Incident? _incident;

  @override
  void initState() {
    super.initState();
    _incident = widget.incident;
  }

  @override
  Widget build(BuildContext context) {
    if (_incident == null) {
      return  Scaffold(
        appBar: AppBar(
        title: const Text("Incident Details"),
        leading: IconButton(
          onPressed: () {
            Beamer.of(context).beamToNamed('/home/readincidents');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
        body: Center(child: Text("No incident data available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Incident Details"),
        leading: IconButton(
          onPressed: () {
            Beamer.of(context).beamToNamed('/home/readincidents');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title: ${_incident!.title}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Type: ${_incident!.type}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "Priority: ${_incident!.priority}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "Description: ${_incident!.description}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              _incident!.imageUrl != null
                  ? Image.network(_incident!.imageUrl!)
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              Text(
                "Created at: ${_incident!.createdAt}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
