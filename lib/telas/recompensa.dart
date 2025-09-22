import 'package:flutter/material.dart';

class TelaRecompensas extends StatefulWidget {
  const TelaRecompensas({super.key});

  @override
  State<TelaRecompensas> createState() => _TelaRecompensasState();
}

class _TelaRecompensasState extends State<TelaRecompensas> {
  final List<Map<String, dynamic>> recompensas = [
    {"nome": "Ingresso COP 30", "custo": 100},
    {"nome": "Camiseta COP 30", "custo": 50},
    {"nome": "Caneca Sustentável", "custo": 30},
  ];

  int amaCoins = 120;

  void _trocarRecompensa(int index) {
    final custo = (recompensas[index]["custo"] as num).toInt();

    if (amaCoins >= custo) {
      setState(() {
        amaCoins -= custo;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text("Você resgatou ${recompensas[index]["nome"]}!"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text("AmaCoins insuficientes!"),
        ),
      );
    }
  }

  void _cadastrarRecompensa() {
    showDialog(
      context: context,
      builder: (context) {
        final nomeController = TextEditingController();
        final custoController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Nova Recompensa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: custoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Custo em AmaCoins",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nome = nomeController.text;
                final custo = int.tryParse(custoController.text) ?? 0;
                if (nome.isNotEmpty && custo > 0) {
                  setState(() {
                    recompensas.add({"nome": nome, "custo": custo});
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Salvar"),
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
        backgroundColor: Colors.green.shade600,
        title: const Text("Recompensas"),
        actions: [
          IconButton(
            onPressed: _cadastrarRecompensa,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              "💰 Seu saldo: $amaCoins AmaCoins",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: recompensas.length,
              itemBuilder: (context, index) {
                final recompensa = recompensas[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(
                      recompensa["nome"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "${recompensa["custo"]} AmaCoins",
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () => _trocarRecompensa(index),
                      child: const Text("Trocar"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}