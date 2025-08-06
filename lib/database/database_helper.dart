import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  DatabaseHelper._();

  // Simulando banco de dados em memória para Web
  final List<Map<String, dynamic>> _usuarios = [];
  final List<Map<String, dynamic>> _checkins = [];
  int _usuarioIdCounter = 1;
  int _checkinIdCounter = 1;

  // Inicialização fake para manter compatibilidade
  Future<void> get database async {
    // Adiciona um usuário demo se não houver nenhum
    if (_usuarios.isEmpty) {
      await inserirUsuario({
        'nome': 'Demo',
        'email': 'demo@email.com',
        'senha': '1234',
        'amacoins': 100,
      });
    }
  }

  // Métodos CRUD
  Future<int> inserirUsuario(Map<String, dynamic> usuario) async {
    // Verifica se email já existe
    final existe = _usuarios.any((u) => u['email'] == usuario['email']);
    if (existe) throw Exception('Email já cadastrado');
    
    usuario['id'] = _usuarioIdCounter++;
    _usuarios.add(usuario);
    return usuario['id'];
  }

  Future<Map<String, dynamic>?> loginUsuario(String email, String senha) async {
    try {
      return _usuarios.firstWhere(
        (u) => u['email'] == email && u['senha'] == senha,
      );
    } catch (e) {
      return null;
    }
  }
  
  Future<Map<String, dynamic>?> getUsuario(int id) async {
    try {
      return _usuarios.firstWhere((u) => u['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<int> inserirCheckin(Map<String, dynamic> checkin) async {
    checkin['id'] = _checkinIdCounter++;
    _checkins.add(checkin);
    return checkin['id'];
  }
  
  Future<int> adicionarCheckin(int usuarioId, String local, String evento) async {
    return await inserirCheckin({
      'usuario_id': usuarioId,
      'local': local,
      'data': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> obterCheckins(int usuarioId) async {
    return _checkins
        .where((c) => c['usuario_id'] == usuarioId)
        .toList()
        .reversed
        .toList();
  }
  
  Future<List<Map<String, dynamic>>> getHistoricoCheckins(int usuarioId) async {
    return await obterCheckins(usuarioId);
  }

  Future<void> adicionarAmaCoins(int usuarioId, int coins) async {
    final usuario = _usuarios.firstWhere((u) => u['id'] == usuarioId);
    usuario['amacoins'] = (usuario['amacoins'] ?? 0) + coins;
  }
  
  Future<void> atualizarAmacoins(int usuarioId, int coins) async {
    await adicionarAmaCoins(usuarioId, coins);
  }
  
  Future<List<Map<String, dynamic>>> getEventos() async {
    return [
      {'id': 1, 'nome': 'Trilha Ecológica', 'descricao': 'Explore a natureza'},
      {'id': 2, 'nome': 'Oficina de Reciclagem', 'descricao': 'Aprenda a reciclar'},
      {'id': 3, 'nome': 'Visita Ribeirinha', 'descricao': 'Conheça a cultura local'},
    ];
  }
  
  Future<void> limparDatabase() async {
    _checkins.clear();
    _usuarios.clear();
    _usuarioIdCounter = 1;
    _checkinIdCounter = 1;
  }
}