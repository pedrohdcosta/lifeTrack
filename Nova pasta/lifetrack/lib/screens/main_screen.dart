import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Track - Atividades'),
      ),
      body: ListView(
        children: [
          // Categorias de atividades
          ExpansionTile(
            title: const Text('Exercício'),
            children: [
              ListTile(
                title: const Text('Caminhada 30 Minutos'),
                subtitle: const Text('Duração estimada: 30 min'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Função ao clicar na atividade de exercício
                },
              ),
              ListTile(
                title: const Text('Corrida 5 km'),
                subtitle: const Text('Duração estimada: 45 min'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Função ao clicar na atividade de corrida
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Meditação'),
            children: [
              ListTile(
                title: const Text('Meditar 15 Minutos'),
                subtitle: const Text('Ajuda a reduzir o estresse'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Função ao clicar na atividade de meditação
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Desafios Semanais'),
            children: [
              ListTile(
                title: const Text('Beber 2 litros de água por dia'),
                subtitle: const Text('Progresso: 5/7 dias'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Função ao clicar no desafio
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Adicionar nova atividade personalizada
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Atividade Personalizada'),
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
