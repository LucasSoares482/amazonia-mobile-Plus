// database/database_helper.dart - Banco de dados simulado corrigido
/// Classe helper para gerenciar o banco de dados simulado
class DatabaseHelper {
  /// Construtor privado para Singleton
  DatabaseHelper._();
  
  /// Instância única do database helper
  static final DatabaseHelper instance = DatabaseHelper._();

  // Simulando banco de dados em memória
  final List<Map<String, dynamic>> _usuarios = [];
  final List<Map<String, dynamic>> _checkins = [];
  final List<Map<String, dynamic>> _eventos = [];
  int _usuarioIdCounter = 1;
  int _checkinIdCounter = 1;
  int _eventoIdCounter = 1;

  /// Getter para inicializar o banco de dados
  Future<void> get database async {
    if (_usuarios.isEmpty) {
      // Criar eventos padrão para demonstração
      await _criarEventosDemo();
    }
  }

  Future<void> _criarEventosDemo() async {
    // Eventos criados por responsável demo (ID 2)
    final eventosDemo = [
      {
        'id': _eventoIdCounter++,
        'titulo': 'Festival Cultural da Amazônia',
        'descricao': 'Grande festival com música, dança e gastronomia típica da região amazônica.',
        'endereco': 'Estação das Docas, Belém - PA',
        'data_inicio': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        'data_fim': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        'amacoins': 50,
        'responsavel_id': 2,
        'foto_path': null,
      },
      {
        'id': _eventoIdCounter++,
        'titulo': 'Trilha Ecológica no Mangal',
        'descricao': 'Caminhada guiada pela natureza do Mangal das Garças com observação da fauna local.',
        'endereco': 'Mangal das Garças, Belém - PA',
        'data_inicio': DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
        'data_fim': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        'amacoins': 30,
        'responsavel_id': 2,
        'foto_path': null,
      },
      {
        'id': _eventoIdCounter++,
        'titulo': 'Workshop de Artesanato Regional',
        'descricao': 'Aprenda técnicas tradicionais de artesanato paraense com mestres artesãos.',
        'endereco': 'Casa das Artes, Belém - PA',
        'data_inicio': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        'data_fim': DateTime.now().add(const Duration(days: 2, hours: 4)).toIso8601String(),
        'amacoins': 40,
        'responsavel_id': 2,
        'foto_path': null,
      },
    ];

    _eventos.addAll(eventosDemo);
  }

  // Métodos de usuário
  /// Insere um novo usuário no banco
  Future<int> inserirUsuario(Map<String, dynamic> usuario) async {
    // Verifica se email já existe
    final existe = _usuarios.any((u) => u['email'] == usuario['email']);
    if (existe) throw Exception('Email já cadastrado');

    usuario['id'] = _usuarioIdCounter++;
    _usuarios.add(usuario);
    return usuario['id'];
  }

  /// Realiza login do usuário
  Future<Map<String, dynamic>?> loginUsuario(String email, String senha) async {
    try {
      return _usuarios.firstWhere(
        (u) => u['email'] == email && u['senha'] == senha,
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtém usuário por ID
  Future<Map<String, dynamic>?> getUsuario(int id) async {
    try {
      return _usuarios.firstWhere((u) => u['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Atualiza dados do usuário
  Future<void> atualizarUsuario(Map<String, dynamic> usuario) async {
    final index = _usuarios.indexWhere((u) => u['id'] == usuario['id']);
    if (index != -1) {
      _usuarios[index] = usuario;
    }
  }

  // Métodos de eventos
  /// Insere novo evento
  Future<int> inserirEvento(Map<String, dynamic> evento) async {
    evento['id'] = _eventoIdCounter++;
    _eventos.add(evento);
    return evento['id'];
  }

  /// Obtém todos os eventos
  Future<List<Map<String, dynamic>>> obterEventos() async => List.from(_eventos);

  /// Obtém eventos de um responsável específico
  Future<List<Map<String, dynamic>>> obterEventosResponsavel(int responsavelId) async =>
      _eventos.where((e) => e['responsavel_id'] == responsavelId).toList();

  /// Atualiza um evento
  Future<void> atualizarEvento(Map<String, dynamic> evento) async {
    final index = _eventos.indexWhere((e) => e['id'] == evento['id']);
    if (index != -1) {
      _eventos[index] = evento;
    }
  }

  /// Exclui um evento
  Future<void> excluirEvento(int eventoId) async {
    _eventos.removeWhere((e) => e['id'] == eventoId);
  }

  // Métodos de check-in
  /// Insere um novo check-in
  Future<int> inserirCheckin(Map<String, dynamic> checkin) async {
    checkin['id'] = _checkinIdCounter++;
    _checkins.add(checkin);
    return checkin['id'];
  }

  /// Adiciona um check-in
  Future<int> adicionarCheckin(int usuarioId, String local, String evento) async =>
      inserirCheckin({
        'usuario_id': usuarioId,
        'local': local,
        'evento': evento,
        'data': DateTime.now().toIso8601String(),
      });

  /// Obtém check-ins do usuário
  Future<List<Map<String, dynamic>>> obterCheckins(int usuarioId) async =>
      _checkins
          .where((c) => c['usuario_id'] == usuarioId)
          .toList()
          .reversed
          .toList();

  /// Obtém histórico de check-ins
  Future<List<Map<String, dynamic>>> getHistoricoCheckins(int usuarioId) async =>
      obterCheckins(usuarioId);

  /// Adiciona AmaCoins ao usuário
  Future<void> adicionarAmaCoins(int usuarioId, int coins) async {
    final usuarioIndex = _usuarios.indexWhere((u) => u['id'] == usuarioId);
    if (usuarioIndex != -1) {
      _usuarios[usuarioIndex]['amacoins'] = 
          (_usuarios[usuarioIndex]['amacoins'] ?? 0) + coins;
    }
  }

  /// Atualiza AmaCoins do usuário
  Future<void> atualizarAmacoins(int usuarioId, int coins) async {
    await adicionarAmaCoins(usuarioId, coins);
  }

  /// Limpa todo o banco de dados
  Future<void> limparDatabase() async {
    _checkins.clear();
    _usuarios.clear();
    _eventos.clear();
    _usuarioIdCounter = 1;
    _checkinIdCounter = 1;
    _eventoIdCounter = 1;
  }
}