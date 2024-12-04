import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HydrationScreen extends StatelessWidget {
  const HydrationScreen({super.key});

  Future<void> _saveHydrationData(double liters) async {
    try {
      // Obtendo o usuário atualmente logado
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Salvando a quantidade de água e a data no Firestore
        await FirebaseFirestore.instance.collection('hydration').add({
          'userId': user.uid, // UID do usuário para referencia
          'email': user.email, // E-mail do usuário para consultas
          'liters': liters,
          'date': DateTime.now(), // Salvando a data e hora atuais
        });

        print(
            'Dados de hidratação salvos com sucesso para o usuário: ${user.email}');
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      // Tratar erros de salvamento, se necessário
      print('Erro ao salvar os dados de hidratação: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? 'unknown_user';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidratação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Quantos litros de água você consumiu hoje?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _saveHydrationData(1.0); // Função para registrar 1 litro
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('1 Litro'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveHydrationData(2.0); // Função para registrar 2 litros
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('2 Litros'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveHydrationData(3.0); // Função para registrar 3 litros
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('3 Litros'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Seu Histórico de Consumo de Água:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Listagem de dados de hidratação do Firestore usando StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hydration')
                    .where('email', isEqualTo: userEmail)
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('Nenhum registro encontrado.'));
                  }

                  // Se houver dados, liste-os
                  final hydrationDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: hydrationDocs.length,
                    itemBuilder: (context, index) {
                      final data =
                          hydrationDocs[index].data() as Map<String, dynamic>;
                      final liters = data['liters'] ?? 0.0;
                      final date = (data['date'] as Timestamp).toDate();

                      return ListTile(
                        leading:
                            const Icon(Icons.local_drink, color: Colors.blue),
                        title: Text('$liters Litros'),
                        subtitle: Text(
                            'Data: ${date.day}/${date.month}/${date.year}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
