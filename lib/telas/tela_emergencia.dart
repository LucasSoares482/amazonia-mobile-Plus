import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class TelaEmergencia extends StatelessWidget {
  const TelaEmergencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergência'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Padding(
        padding: Responsive.padding(context),
        child: ListView(
          children: [
            const Text(
              'Contatos de Emergência',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ..._buildContactList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContactList() {
    final contacts = [
      {'title': 'Polícia Turística', 'phone': '190'},
      {'title': 'Polícia Militar', 'phone': '191'},
      {'title': 'Delegacia da Mulher', 'phone': '180'},
      {'title': 'Embaixada dos EUA', 'phone': '+55 61 3312-7000'},
      {'title': 'Embaixada do Reino Unido', 'phone': '+55 61 3329-2300'},
      {'title': 'Hospital Central', 'phone': '+55 91 3241-1234'},
      {'title': 'Bombeiros', 'phone': '193'},
      {'title': 'Embaixada da França', 'phone': '+55 61 3222-3999'},
      {'title': 'Embaixada da Alemanha', 'phone': '+55 61 3442-7000'},
      {'title': 'Embaixada do Japão', 'phone': '+55 61 3442-4200'},
      {'title': 'Hospital Municipal', 'phone': '+55 91 3234-5678'},
      {'title': 'Hospital Infantil', 'phone': '+55 91 3221-8765'},
      {'title': 'Hospital da Mulher', 'phone': '+55 91 3245-6789'},
      {'title': 'Hospital de Emergência', 'phone': '+55 91 3212-3456'},
      {'title': 'SAMU', 'phone': '192'},
      {'title': 'Defesa Civil', 'phone': '199'},
      {'title': 'Embaixada da Itália', 'phone': '+55 61 3442-9900'},
      {'title': 'Embaixada de Portugal', 'phone': '+55 61 3032-9600'},
      {'title': 'Embaixada da Espanha', 'phone': '+55 61 3443-9900'},
      {'title': 'Embaixada da China', 'phone': '+55 61 3443-1700'},
      {'title': 'Hospital Universitário', 'phone': '+55 91 3241-4321'},
      {'title': 'Hospital Psiquiátrico', 'phone': '+55 91 3223-4567'},
      {'title': 'Hospital Ortopédico', 'phone': '+55 91 3232-1234'},
      {'title': 'Hospital Oftalmológico', 'phone': '+55 91 3243-5678'},
      {'title': 'Hospital Cardiológico', 'phone': '+55 91 3224-8765'},
      {'title': 'Hospital Oncológico', 'phone': '+55 91 3245-4321'},
      {'title': 'Hospital Pediátrico', 'phone': '+55 91 3234-8765'},
      {'title': 'Hospital Geriátrico', 'phone': '+55 91 3221-5678'},
      {'title': 'Hospital de Traumatologia', 'phone': '+55 91 3243-1234'},
    ];

    return contacts
        .map(
          (contact) => _buildContactCard(contact['title']!, contact['phone']!),
        )
        .toList();
  }

  Widget _buildContactCard(String title, String phone) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.phone, color: Colors.green, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(phone),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: () {
            // Implementar funcionalidade de chamada
          },
        ),
      ),
    );
  }
}
