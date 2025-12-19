import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/model/credentials.dart';
import 'package:smart_incident_repoter/providers/delete_incidentProvider.dart';
import 'package:smart_incident_repoter/providers/profile_provider.dart';
import 'package:smart_incident_repoter/providers/read_incident.dart';
import 'package:smart_incident_repoter/providers/register_provider.dart';
import 'package:smart_incident_repoter/router/app_router.dart';

import '../model/incident_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
void initState() {
  super.initState();

  Future.microtask(() {
    final user = ref.read(currentUserProvider);

    if (user != null && user['id'] != null) {
      ref.read(readIncidentControllerProvider.notifier)
          .readIncidentFromFirebase(user['id']);
    }
  });   
}

  @override
  Widget build(BuildContext context) {
    final incidentState = ref.watch(readIncidentControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: incidentState.when(
        data: (response) {
          final incidents = response.data as List<Incident>? ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20,bottom: 8,left: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Beamer.of(context).beamToNamed('/home/profile');
                      },
                      child:Consumer(
  builder: (context, ref, _) {
    final profileState = ref.watch(profileControllerProvider);

    return profileState.when(
      data: (response) {
        final credential = response.data as Credential?;

        if (credential == null) {
          return Row(
            children: const [
              CircleAvatar(
                radius: 25,
                child: Icon(Icons.person),
              ),
              SizedBox(width: 10),
              Text("User"),
            ],
          );
        }

        return Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade400,
              backgroundImage: credential.imageUrl != null
                  ? NetworkImage(credential.imageUrl!)
                  : null,
              child: credential.imageUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
                      const SizedBox(width: 10),
                      Text(
                        credential.name ?? "User",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
                loading: () =>const Row(
                  children:  [
                    CircleAvatar(
                      radius: 25,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text("Loading..."),
                  ],
                ),
                error: (e, st) =>const Row(
                  children: const [
                    CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.error),
                    ),
                    SizedBox(width: 10),
                    Text("Error"),
                  ],
                ),
              );
            },
          )
                      ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        Beamer.of(context).beamToNamed('/home/createincidents');
                      },
                      child: Container(
                       padding: EdgeInsets.all(5),
                        //width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black)
                        ),
                        child: Row(
                          children: [
                            Text("Create Incident"),
                            Icon(Icons.add,size: 14,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Padding(
               padding: const EdgeInsets.all(15.0),
               child: const   Text("Incident List"),
             ),
             
              Expanded(
                child: incidents.isEmpty
              ? const Center(child: Text("No incidents found")):
                 ListView.builder(
                  itemCount: incidents.length,
                  itemBuilder: (context, index) {
                    final incident = incidents[index];
                    return GestureDetector(
                      onTap: () {
                        Beamer.of(context).beamToNamed('/home/details');
                      },
                      child: Container(
                         decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 2), 
                          ),
                        ],
                      ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Row(
                              children: [
                                 Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: incident.imageUrl != null && incident.imageUrl!.isNotEmpty
                                      ? Image.network(
                                          incident.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Center(
                                              child: Text(
                                                "Image not uploaded",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            "Image not uploaded",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                ),
                               // Image.network(incident.imageUrl!,height: 100,width: 100,),
                              const  SizedBox(width: 10,),
                                Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(incident.title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                    const SizedBox(height: 8,),
                                      Text("${incident.type} • ${incident.priority}"),
                                      Text("${incident.createdAt.toLocal().toString().split(' ')[0]}"),
                                  ],
                                ),
                                Spacer(),
                                Column(children: [
                                  Container(
                                    height: 27,
                                    width: 27,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:Colors.white,
                                     border: Border.all(color: Colors.black),
                                    ),
                                    child: IconButton(
                                    onPressed: () async {
                                      final confirmed = await showDeleteConfirmationDialog(context);
                                      if (!confirmed) return;
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                      
                                      final controller = ref.read(incidentDeleteControllerProvider.notifier);
                                      await controller.updateIncidentInFirebse(incident.id!);
                                      Navigator.of(context).pop();
                                      final deleteState = ref.read(incidentDeleteControllerProvider);
                                      deleteState.when(
                                        data: (res) {
                                          if (res.status == NetworkStatus.success) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Incident deleted successfully")),
                                            );
                                            final user = ref.read(currentUserProvider);
                                            if (user != null && user['id'] != null) {
                                              ref.read(readIncidentControllerProvider.notifier)
                                                  .readIncidentFromFirebase(user['id']);
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(res.errorMessage ?? "Failed to delete")),
                                            );
                                          }
                                        },
                                        loading: () {},
                                        error: (e, st) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Error: $e")),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete, size: 12),
                                  )),
                                   const SizedBox(height: 5,),
                                   Container(
                                    height: 27,
                                    width: 27,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:Colors.white,
                                     border: Border.all(color: Colors.black),
                                    ),
                                    child: IconButton(onPressed: (){
                                       final incident = incidents[index];
                                       Beamer.of(context).beamToNamed(
                                      '/home/createincidents',
                                      routeState: incident,
                                    );
                                    }, icon: Icon(Icons.edit,size: 12,))),
                                ],)
                              ],
                            ),
                          ],),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Incident"),
      content: const Text("Are you sure you want to delete this incident?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Delete"),
        ),
      ],
    ),
  );

  return result ?? false; // returns false if user dismisses dialog
}

}
