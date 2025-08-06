import 'package:flutter/material.dart';
import '../utils/app_state.dart';
import '../utils/responsive.dart';

// Tela Home Responsiva
class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = AppState.usuarioLogado;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${usuario?.nome ?? 'Usuário'}'),
        elevation: 2,
        actions: [
          if (usuario != null)
            Chip(
              avatar: const Icon(Icons.monetization_on, size: 16),
              label: Text('${usuario.amacoins} AmaCoins'),
              backgroundColor: Colors.amber.shade100,
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              AppState.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.count(
            padding: Responsive.padding(context),
            crossAxisCount: Responsive.gridCount(context),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: Responsive.isMobile(context) ? 1.2 : 1.0,
            children: [
              _buildCard(context, Icons.map, 'Mapa', '/mapa', Colors.blue),
              _buildCard(context, Icons.check_circle, 'Check-in', '/checkin', Colors.green),
              _buildCard(context, Icons.event, 'Eventos', '/eventos', Colors.orange),
              _buildCard(context, Icons.history, 'Histórico', '/historico', Colors.purple),
              _buildCard(context, Icons.wallet, 'Carteira', '/carteira', Colors.amber),
              _buildCard(context, Icons.person, 'Perfil', '/perfil', Colors.teal),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String route, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: Responsive.fontSize(context,
                  mobile: 48,
                  tablet: 56,
                  desktop: 64,
                ),
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela Mapa Simples
class TelaMapa extends StatelessWidget {
  const TelaMapa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 100, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Mapa em desenvolvimento'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/checkin'),
              icon: const Icon(Icons.location_on),
              label: const Text('Fazer Check-in'),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela Carteira Simples
class TelaCarteira extends StatelessWidget {
  const TelaCarteira({super.key});

  @override
  Widget build(BuildContext context) {
    final amacoins = AppState.usuarioLogado?.amacoins ?? 0;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Carteira')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              '$amacoins',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Text('AmaCoins', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// Tela Eventos Simples
class TelaEventos extends StatelessWidget {
  const TelaEventos({super.key});

  @override
  Widget build(BuildContext context) {
    final eventos = [
      'Trilha Ecológica',
      'Oficina de Reciclagem',
      'Visita Ribeirinha',
    ];
    
    return Scaffold(
      appBar: AppBar(title: const Text('Eventos')),
      body: ListView.builder(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.event, color: Colors.green),
            title: Text(eventos[index]),
            subtitle: const Text('Toque para saber mais'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Evento: ${eventos[index]}')),
              );
            },
          );
        },
      ),
    );
  }
}

// Tela Perfil Simples
class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = AppState.usuarioLogado;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              usuario?.nome ?? 'Usuário',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(usuario?.email ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                AppState.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

// Telas não implementadas ainda
class TelaQuiz extends StatelessWidget {
  const TelaQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: const Center(child: Text('Quiz em desenvolvimento')),
    );
  }
}

class TelaChatbot extends StatelessWidget {
  const TelaChatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: const Center(child: Text('Chatbot em desenvolvimento')),
    );
  }
}