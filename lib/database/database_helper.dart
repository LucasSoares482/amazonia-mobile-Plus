import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper centralizado para manipular os dados armazenados no Firebase.
class DatabaseHelper {
  DatabaseHelper._();

  /// Instância singleton do helper.
  static final DatabaseHelper instance = DatabaseHelper._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usuariosRef =>
      _db.collection('usuarios');
  CollectionReference<Map<String, dynamic>> get _eventosRef =>
      _db.collection('eventos');
  CollectionReference<Map<String, dynamic>> get _checkinsRef =>
      _db.collection('checkins');

  /// Cria dados de demonstração (usuários e eventos) se ainda não existirem.
  Future<void> seedDemoData() async {
    final responsavel = await _buscarUsuarioPorEmail('responsavel@test.com') ??
        await _criarUsuarioDemo(
          nome: 'Maria Responsável',
          email: 'responsavel@test.com',
          tipo: 'responsavel',
        );

    await _buscarUsuarioPorEmail('visitador@test.com') ??
        await _criarUsuarioDemo(
          nome: 'João Visitador',
          email: 'visitador@test.com',
          tipo: 'visitador',
          amacoins: 150,
        );

    final possuiEventos = await _eventosRef.limit(1).get();
    if (possuiEventos.docs.isNotEmpty) return;

    final agora = DateTime.now();
    final eventosDemo = [
      {
        'titulo': 'Festival Cultural da Amazônia',
        'descricao':
            'Grande festival com música, dança e gastronomia típica da região amazônica.',
        'endereco': 'Estação das Docas, Belém - PA',
        'data_inicio':
            agora.add(const Duration(days: 1)).toIso8601String(),
        'data_fim':
            agora.add(const Duration(days: 3)).toIso8601String(),
        'amacoins': 50,
        'responsavel_id': responsavel['id'],
        'foto_path': null,
      },
      {
        'titulo': 'Trilha Ecológica no Mangal',
        'descricao':
            'Caminhada guiada pela natureza do Mangal das Garças com observação da fauna local.',
        'endereco': 'Mangal das Garças, Belém - PA',
        'data_inicio':
            agora.add(const Duration(hours: 6)).toIso8601String(),
        'data_fim':
            agora.add(const Duration(days: 1)).toIso8601String(),
        'amacoins': 30,
        'responsavel_id': responsavel['id'],
        'foto_path': null,
      },
      {
        'titulo': 'Workshop de Artesanato Regional',
        'descricao':
            'Aprenda técnicas tradicionais de artesanato paraense com mestres artesãos.',
        'endereco': 'Casa das Artes, Belém - PA',
        'data_inicio':
            agora.add(const Duration(days: 2)).toIso8601String(),
        'data_fim': agora
            .add(const Duration(days: 2, hours: 4))
            .toIso8601String(),
        'amacoins': 40,
        'responsavel_id': responsavel['id'],
        'foto_path': null,
      },
    ];

    for (final evento in eventosDemo) {
      await _eventosRef.add(evento);
    }
  }

  Future<Map<String, dynamic>> _criarUsuarioDemo({
    required String nome,
    required String email,
    required String tipo,
    int amacoins = 0,
  }) async {
    final dados = {
      'nome': nome,
      'email': email,
      'senha': '1234',
      'tipo': tipo,
      'amacoins': amacoins,
    };
    final id = await inserirUsuario(dados);
    return {...dados, 'id': id};
  }

  Future<Map<String, dynamic>?> _buscarUsuarioPorEmail(String email) async {
    final snapshot = await _usuariosRef
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return {...doc.data(), 'id': doc.id};
  }

  /// Insere um novo usuário no Firestore.
  Future<String> inserirUsuario(Map<String, dynamic> usuario) async {
    final existente =
        await _usuariosRef.where('email', isEqualTo: usuario['email']).limit(1).get();
    if (existente.docs.isNotEmpty) {
      throw Exception('Email já cadastrado');
    }

    final dados = {...usuario}..remove('id');
    dados['amacoins'] = dados['amacoins'] ?? 0;
    final doc = await _usuariosRef.add(dados);
    return doc.id;
  }

  /// Realiza o login de um usuário consultando por email e senha.
  Future<Map<String, dynamic>?> loginUsuario(
    String email,
    String senha,
  ) async {
    final snapshot = await _usuariosRef
        .where('email', isEqualTo: email)
        .where('senha', isEqualTo: senha)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return {...doc.data(), 'id': doc.id};
  }

  /// Obtém um usuário pelo ID do documento.
  Future<Map<String, dynamic>?> getUsuario(String id) async {
    final doc = await _usuariosRef.doc(id).get();
    if (!doc.exists) return null;
    return {...doc.data()!, 'id': doc.id};
  }

  /// Atualiza os dados do usuário no Firestore.
  Future<void> atualizarUsuario(Map<String, dynamic> usuario) async {
    final usuarioId = usuario['id']?.toString();
    if (usuarioId == null) throw Exception('ID do usuário não informado');

    final dados = {...usuario}..remove('id');
    await _usuariosRef.doc(usuarioId).update(dados);
  }

  /// Insere um novo evento.
  Future<String> inserirEvento(Map<String, dynamic> evento) async {
    final dados = {...evento}..remove('id');
    final doc = await _eventosRef.add(dados);
    return doc.id;
  }

  /// Obtém todos os eventos cadastrados.
  Future<List<Map<String, dynamic>>> obterEventos() async {
    final snapshot = await _eventosRef.get();
    final eventos = snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();

    eventos.sort((a, b) {
      final inicioA = DateTime.tryParse(a['data_inicio']?.toString() ?? '');
      final inicioB = DateTime.tryParse(b['data_inicio']?.toString() ?? '');
      if (inicioA == null || inicioB == null) return 0;
      return inicioA.compareTo(inicioB);
    });

    return eventos;
  }

  /// Obtém os eventos de um responsável específico.
  Future<List<Map<String, dynamic>>> obterEventosResponsavel(
    String responsavelId,
  ) async {
    final snapshot = await _eventosRef
        .where('responsavel_id', isEqualTo: responsavelId)
        .get();
    final eventos = snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();

    eventos.sort((a, b) {
      final inicioA = DateTime.tryParse(a['data_inicio']?.toString() ?? '');
      final inicioB = DateTime.tryParse(b['data_inicio']?.toString() ?? '');
      if (inicioA == null || inicioB == null) return 0;
      return inicioA.compareTo(inicioB);
    });

    return eventos;
  }

  /// Atualiza os dados do evento.
  Future<void> atualizarEvento(Map<String, dynamic> evento) async {
    final eventoId = evento['id']?.toString();
    if (eventoId == null) throw Exception('ID do evento não informado');

    final dados = {...evento}..remove('id');
    await _eventosRef.doc(eventoId).update(dados);
  }

  /// Exclui um evento pelo ID.
  Future<void> excluirEvento(String eventoId) async {
    await _eventosRef.doc(eventoId).delete();
  }

  /// Insere um check-in com dados completos.
  Future<String> inserirCheckin(Map<String, dynamic> checkin) async {
    final dados = {...checkin}..remove('id');
    final doc = await _checkinsRef.add(dados);
    return doc.id;
  }

  /// Cria um check-in com dados mínimos.
  Future<String> adicionarCheckin(
    String usuarioId,
    String local,
    String evento,
  ) async =>
      inserirCheckin({
        'usuario_id': usuarioId,
        'local': local,
        'evento': evento,
        'data': DateTime.now().toIso8601String(),
      });

  /// Obtém todos os check-ins do usuário.
  Future<List<Map<String, dynamic>>> obterCheckins(String usuarioId) async {
    final snapshot = await _checkinsRef
        .where('usuario_id', isEqualTo: usuarioId)
        .get();

    final checkins = snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();

    checkins.sort((a, b) {
      final dataA = DateTime.tryParse(a['data']?.toString() ?? '');
      final dataB = DateTime.tryParse(b['data']?.toString() ?? '');
      if (dataA == null || dataB == null) return 0;
      return dataB.compareTo(dataA);
    });

    return checkins;
  }

  /// Histórico de check-ins (mesmo comportamento do método principal).
  Future<List<Map<String, dynamic>>> getHistoricoCheckins(
    String usuarioId,
  ) =>
      obterCheckins(usuarioId);

  /// Incrementa a quantidade de AmaCoins do usuário.
  Future<void> adicionarAmaCoins(String usuarioId, int coins) async {
    await _usuariosRef.doc(usuarioId).update({
      'amacoins': FieldValue.increment(coins),
    });
  }

  /// Atualiza a quantidade de AmaCoins (mantém compatibilidade com API atual).
  Future<void> atualizarAmacoins(String usuarioId, int coins) =>
      adicionarAmaCoins(usuarioId, coins);

  /// Remove todos os dados do Firestore (uso administrativo).
  Future<void> limparDatabase() async {
    await _deleteAllDocs(_checkinsRef);
    await _deleteAllDocs(_eventosRef);
    await _deleteAllDocs(_usuariosRef);
  }

  Future<void> _deleteAllDocs(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    final snapshot = await collection.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
