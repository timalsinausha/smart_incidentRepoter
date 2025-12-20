import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/model/incident_type.dart';

final incidentTypesProvider = FutureProvider<List<IncidentType>>((ref) async {
  final response = await http.get(Uri.parse(
      'https://6943af4769b12460f3159d45.mockapi.io/incidentTypes'));

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((e) => IncidentType.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load incident types: ${response.statusCode}');
  }
});
