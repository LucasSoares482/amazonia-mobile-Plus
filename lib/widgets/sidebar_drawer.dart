// widgets/sidebar_drawer.dart - Sidebar com navegação corrigida
import 'package:flutter/material.dart';
import '../utils/app_state.dart';

/// Widget do sidebar com navegação do aplicativo
class SidebarDrawer extends StatelessWidget {
  /// Construtor do sidebar drawer
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = AppState.usuarioLogado;
    
    if (usuario == null) {
      return const Drawer(
        child: Center(child: Text('Usuário não encontrado')),
      );
    }

    return Drawer(
      child: Column(
        children: [
          // Header do drawer
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green.shade400, Colors.green.shade800],
              ),
            ),
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: usuario.fotoPerfil != null
                        ? AssetImage(usuario.fotoPerfil!)
                        : null,
                    child: usuario.fotoPerfil == null
                        ? Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.green.shade600,
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    usuario.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    usuario.isVisitador ? 'Visitador' : 'Responsável',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (usuario.isVisitador) ...[
                  _buildDrawerItem(
                    context,
                    Icons.account_balance_wallet,
                    'Carteira',
                    '/carteira',
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.check_circle,
                    'Check-in',
                    '/checkin',
                  ),
                   _buildDrawerItem(
                    context,
                    Icons.chat,
                    'ChatBot',
                    '/chatbot',
                  ),
                   _buildDrawerItem(
                    context,
                    Icons.card_giftcard,
                    'Recompensas',
                    '/recompensas',
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.history,
                    'Histórico',
                    '/historico',
                  ),
                ],
                _buildDrawerItem(
                  context,
                  Icons.person,
                  'Perfil',
                  '/perfil',
                ),
                _buildDrawerItem(
                  context,
                  Icons.map,
                  'Mapa',
                  '/mapa',
                ),
                _buildDrawerItem(
                  context,
                  Icons.warning,
                  'Emergência',
                  '/emergencia',
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  Icons.logout,
                  'Sair',
                  null,
                  isLogout: true,
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String? route, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.green.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap ?? () {
        Navigator.pop(context); // Fecha o drawer
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  void _logout(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar saída'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              Navigator.pop(context); // Fecha o drawer
              AppState.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
}