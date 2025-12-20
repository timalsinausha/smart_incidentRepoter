import 'dart:io';
import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_incident_repoter/custom/elevatedButton_custom.dart';
import 'package:smart_incident_repoter/model/incident_model.dart';
import 'package:smart_incident_repoter/providers/incidentProvider/add_incidentProvider.dart';
import 'package:smart_incident_repoter/providers/incidentProvider/incidentType_provider.dart';
import 'package:smart_incident_repoter/providers/userProvider/register_provider.dart';
import 'package:smart_incident_repoter/providers/incidentProvider/update_incident_provider.dart';

class AddIncidentScreen extends ConsumerStatefulWidget {
    final Incident? editingIncident;
  const AddIncidentScreen({super.key, this.editingIncident});

  @override
  ConsumerState<AddIncidentScreen> createState() => _AddIncidentScreenState();
}

class _AddIncidentScreenState extends ConsumerState<AddIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedIncidentType;
  String? _selectedPriority;
File? _imageFile;
String? _imageUrl;
  final List<String> _priorityList = ['Low', 'Medium', 'High'];

@override
void initState() {
  super.initState();

  final incident = widget.editingIncident;
  if (incident != null) {
    _titleController.text = incident.title;
    _descriptionController.text = incident.description;
    _selectedIncidentType = incident.type;
    _selectedPriority = incident.priority;

    _imageFile = null; 
    _imageUrl = incident.imageUrl; 
  }
}



  @override
  Widget build(BuildContext context) {
    final incidentTypesAsync = ref.watch(incidentTypesProvider);

    return Scaffold(
      appBar: AppBar(title:  Text(  widget.editingIncident == null ? "Add Incident" : "Update Incident",
                  ),leading:IconButton(onPressed: (){
        Beamer.of(context).beamToNamed('/home/readincidents');
      },icon: Icon(Icons.arrow_back_ios)) ,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Text("Add Image")),
                    SizedBox(height: 10),
                  GestureDetector(
                    onTap: pickImage,
                    child: Center(
                      child: DottedBorder(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 200,
                            width: 120,
                            color: Colors.white,
                            child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : (_imageUrl != null
                                ? Image.network(_imageUrl!, fit: BoxFit.cover)
                                :const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.upload),
                                      Text("Upload Image"),
                                    ],
                                  )),
                          ),
                        ),
                      ),
                    ),
                  ),
            
            
                  const  SizedBox(height: 15),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter title" : null,
                  ),
                  const SizedBox(height: 16),

                  incidentTypesAsync.when(
                    data: (types) {
                      return DropdownButtonFormField<String>(
                        value: _selectedIncidentType,
                        hint: const Text("Select Incident Type"),
                        items: types
                            .map((type) => DropdownMenuItem(
                                  value: type.name,
                                  child: Text(type.name),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedIncidentType = val),
                        validator: (value) => value == null
                            ? "Please select incident type"
                            : null,
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) =>
                        Text('Failed to load incident types: $err'),
                  ),
                  const SizedBox(height: 16),
            
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter description" : null,
                  ),
                  const SizedBox(height: 16),
            
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    hint: const Text("Select Priority"),
                    items: _priorityList
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedPriority = val),
                    validator: (value) =>
                        value == null ? "Please select priority" : null,
                  ),
                  const SizedBox(height: 24),
          
              ElevetedButton_custom(
                  onPressed: () async {
                    final controller = ref.read(incidentAddControllerProvider.notifier);
                    final user = ref.read(currentUserProvider);

                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User not logged in")),
                      );
                      return;
                    }

                    if (!_formKey.currentState!.validate()) return;

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      String? finalImageUrl = widget.editingIncident?.imageUrl;
                      if (_imageFile != null) {
                        await controller.uploadImageToCloudinary(
                          "https://api.cloudinary.com/v1_1/drpc16odd/image/upload",
                          "ojyjfkig",
                        );

                        if (controller.imageUrl == null) {
                          Navigator.of(context).pop(); 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Image upload failed")),
                          );
                          return;
                        }
                        finalImageUrl = controller.imageUrl;
                      }

                      // Create incident object
                      final incident = Incident(
                        id: widget.editingIncident?.id ?? UniqueKey().toString(),
                        userId: user['id'],
                        title: _titleController.text,
                        type: _selectedIncidentType!,
                        description: _descriptionController.text,
                        priority: _selectedPriority!,
                        imageUrl: finalImageUrl,
                        createdAt: widget.editingIncident?.createdAt ?? DateTime.now(),
                      );

                      // Save or update
                      if (widget.editingIncident == null) {
                        await controller.addIncidentInFirebase(incident);
                      } else {
                        await ref
                            .read(incidentUpdateControllerProvider.notifier)
                            .updateIncidentInFirebse(incident);
                      }

                      Navigator.of(context).pop(); 

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.editingIncident == null
                              ? "Incident created successfully"
                              : "Incident updated successfully"),
                        ),
                      );

                      // Reset form
                      _formKey.currentState!.reset();
                      _titleController.clear();
                      _descriptionController.clear();
                      setState(() {
                        _selectedIncidentType = null;
                        _selectedPriority = null;
                        _imageFile = null;
                        Future.microtask(() {
                          Beamer.of(context).beamToNamed('/home/readincidents');
                        });
                      });
                    } catch (e) {
                      Navigator.of(context).pop(); // close loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to save incident: $e")),
                      );
                    }
                  },
                  child: Text(
                    widget.editingIncident == null ? "Save Incident" : "Update Incident",
                  ),
                ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
   if (pickedFile != null) {
    final file = File(pickedFile.path);
    setState(() {
      _imageFile = file;
      _imageUrl = null;
    });
   ref.read(incidentAddControllerProvider.notifier).setImage(file);
   }
}


}
