import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final CollectionReference mealsCollection =
      FirebaseFirestore.instance.collection('meals');
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _addMeal(String name, String details) async {
    if (user != null) {
      await mealsCollection.add({
        'userId': user!.uid,
        'name': name,
        'details': details,
        'date': DateTime.now(),
      });
    }
  }

  Future<void> _editMeal(
      String docId, String newName, String newDetails) async {
    await mealsCollection.doc(docId).update({
      'name': newName,
      'details': newDetails,
    });
  }

  Future<void> _deleteMeal(String docId) async {
    await mealsCollection.doc(docId).delete();
  }

  void _showMealDialog(
      {String? docId, String? initialName, String? initialDetails}) {
    String name = initialName ?? '';
    String details = initialDetails ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(docId == null ? 'Adicionar Refeição' : 'Editar Refeição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Nome da Refeição'),
                onChanged: (value) {
                  name = value;
                },
                controller: TextEditingController(text: initialName),
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Detalhes da Refeição'),
                onChanged: (value) {
                  details = value;
                },
                controller: TextEditingController(text: initialDetails),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (docId == null) {
                  _addMeal(name, details);
                } else {
                  _editMeal(docId, name, details);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Track - Refeições'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: mealsCollection
                  .where('userId', isEqualTo: user?.uid)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma refeição cadastrada.'));
                }

                final mealDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: mealDocs.length,
                  itemBuilder: (context, index) {
                    final data = mealDocs[index].data() as Map<String, dynamic>;
                    final docId = mealDocs[index].id;
                    final name = data['name'] ?? 'Sem nome';
                    final details = data['details'] ?? 'Sem detalhes';

                    return Card(
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(details),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                _showMealDialog(
                                    docId: docId,
                                    initialName: name,
                                    initialDetails: details);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteMeal(docId);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _showMealDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Refeição'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
