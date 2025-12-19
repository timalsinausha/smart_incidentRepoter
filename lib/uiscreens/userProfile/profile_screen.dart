import 'dart:io';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/model/credentials.dart';
import 'package:smart_incident_repoter/providers/profile_provider.dart';
import 'package:smart_incident_repoter/providers/profile_updatedProvider.dart';
import 'package:smart_incident_repoter/providers/register_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load user profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user != null && user['email'] != null) {
        ref.read(profileControllerProvider.notifier)
            .readUserFromFirebase(user['email']);
      }
    });
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          onPressed: () => Beamer.of(context).beamToNamed('/home/readincidents'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: profileState.when(
        data: (response) {
          final credential = response.data as Credential?;
          if (credential == null) {
            return const Center(child: Text("No profile data found"));
          }

          // Initialize name controller
          _nameController.text = credential.name ?? "";

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade400,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : (credential.imageUrl != null
                                ? NetworkImage(credential.imageUrl!)
                                : null),
                        child: (_imageFile == null && credential.imageUrl == null)
                            ? Text(
                                credential.name?.isNotEmpty == true
                                    ? credential.name![0].toUpperCase()
                                    : "?",
                                style: const TextStyle(
                                    fontSize: 40, color: Colors.white),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text("Email: ${credential.email}"),
                const SizedBox(height: 20),
                // Editable Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final user = ref.read(currentUserProvider);
                    if (user == null) return;

                    final controller =
                        ref.read(profileUpdateControllerProvider.notifier);

                    String? imageUrl = credential.imageUrl;

                    // Upload new image if selected
                    if (_imageFile != null) {
                      controller.setImage(_imageFile!);
                      await controller.uploadImageToCloudinary(
                        "https://api.cloudinary.com/v1_1/drpc16odd/image/upload",
                        "ojyjfkig",
                      );
                      imageUrl = controller.imageUrl;
                    }

                    // Create updated credential
                  final updatedCredential = Credential(
                  id: credential.id,
                  name: _nameController.text.trim(),
                  email: credential.email,
                  password: credential.password, // preserve existing password
                  imageUrl: imageUrl,
                );

                    // Call profile update
                    await controller.readUserFromFirebase(updatedCredential);
                  },
                  child: const Text("Save Changes"),
                ),
                // Listen for update status
                Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(profileUpdateControllerProvider);
                    return state.when(
                      data: (res) {
                        if (res.status == NetworkStatus.success) {
                          return const SizedBox.shrink();
                        } else if (res.status == NetworkStatus.error) {
                          return Text(
                            res.errorMessage ?? "Update failed",
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Text("Error: $e"),
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
