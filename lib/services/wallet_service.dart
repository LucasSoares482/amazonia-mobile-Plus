import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/wallet_transaction.dart';

/// Service responsável por sincronizar e persistir as transações da carteira.
class WalletService {
  WalletService._internal();

  static final WalletService instance = WalletService._internal();

  static const _storage = FlutterSecureStorage();
  static const _transactionsKeyPrefix = 'wallet_transactions_';
  static const _uuid = Uuid();

  static const AndroidOptions _androidOptions =
      AndroidOptions(encryptedSharedPreferences: true);
  static const IOSOptions _iosOptions =
      IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  static const MacOsOptions _macOsOptions = MacOsOptions();
  static const LinuxOptions _linuxOptions = LinuxOptions();
  static const WebOptions _webOptions = WebOptions();

  Future<List<WalletTransaction>> fetchTransactions(String userId) async {
    final key = _storageKey(userId);
    final raw = await _storage.read(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );

    if (raw == null) return [];

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) =>
            WalletTransaction.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }

  Future<void> saveTransactions(
    String userId,
    List<WalletTransaction> transactions,
  ) async {
    final key = _storageKey(userId);
    final jsonList = transactions.map((e) => e.toJson()).toList();
    await _storage.write(
      key: key,
      value: jsonEncode(jsonList),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );
  }

  Future<WalletTransaction> registrarCredito({
    required String userId,
    required String descricao,
    required int valor,
    Map<String, dynamic>? contexto,
  }) async {
    final transacao = WalletTransaction(
      id: _uuid.v4(),
      tipo: 'credito',
      descricao: descricao,
      valor: valor,
      data: DateTime.now(),
      contexto: contexto,
    );

    final transacoes = await fetchTransactions(userId);
    transacoes.insert(0, transacao);
    await saveTransactions(userId, transacoes);
    return transacao;
  }

  Future<WalletTransaction> registrarDebito({
    required String userId,
    required String descricao,
    required int valor,
    Map<String, dynamic>? contexto,
  }) async {
    final transacao = WalletTransaction(
      id: _uuid.v4(),
      tipo: 'debito',
      descricao: descricao,
      valor: -valor.abs(),
      data: DateTime.now(),
      contexto: contexto,
    );

    final transacoes = await fetchTransactions(userId);
    transacoes.insert(0, transacao);
    await saveTransactions(userId, transacoes);
    return transacao;
  }

  String _storageKey(String userId) => '$_transactionsKeyPrefix$userId';
}
