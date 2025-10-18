import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database/database_helper.dart';
import '../l10n/l10n.dart';
import '../models/redeem_item.dart';
import '../models/usuario.dart';
import '../models/wallet_transaction.dart';
import '../services/analytics_service.dart';
import '../services/wallet_service.dart';
import '../utils/app_state.dart';

class TelaCarteira extends StatefulWidget {
  const TelaCarteira({super.key});

  @override
  State<TelaCarteira> createState() => _TelaCarteiraState();
}

class _TelaCarteiraState extends State<TelaCarteira> {
  final _redeemCatalog = <RedeemItem>[
    RedeemItem(
      nome: 'Perfume 100ml',
      parceiro: 'Natura',
      custo: 500,
      descricao:
          'Escolha entre linhas Ekos ou Kaiak. Apresente o QR Code para validar o resgate.',
    ),
    RedeemItem(
      nome: 'Malbec 100ml',
      parceiro: 'O Boticário',
      custo: 600,
      descricao: 'Perfume masculino Malbec clássico. Sujeito à disponibilidade.',
    ),
    RedeemItem(
      nome: 'Perfumes Selecionados',
      parceiro: 'O Boticário',
      custo: 500,
      descricao:
          'Outras fragrâncias sustentáveis participantes da ação especial COP30.',
    ),
    RedeemItem(
      nome: 'Desconto Verde 20%',
      parceiro: 'Líder / Formosa / Mix Mateus',
      custo: 400,
      descricao:
          'Cupom de 20% válido em compras sustentáveis nos mercados parceiros.',
    ),
  ];

  List<WalletTransaction> _transacoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTransacoes();
    AnalyticsService.instance
      ..logScreenView('wallet')
      ..logEvent('wallet_view');
  }

  Future<void> _carregarTransacoes() async {
    final usuarioId = AppState.usuarioLogado?.id;
    if (usuarioId == null) {
      setState(() => _carregando = false);
      return;
    }

    final transacoes =
        await WalletService.instance.fetchTransactions(usuarioId);
    if (!mounted) return;

    setState(() {
      _transacoes = transacoes;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AppState.usuarioLogado!;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).drawerWallet),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        color: Colors.green.shade700,
        onRefresh: _carregarTransacoes,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildSaldoHeader(usuario.amacoins),
            const SizedBox(height: 16),
            _buildResumoRegras(),
            const SizedBox(height: 16),
            _buildRedeemSection(usuario),
            const SizedBox(height: 24),
            _buildHistoricoSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSaldoHeader(int saldo) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade700,
              Colors.green.shade500,
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          children: [
            const Text(
              'Saldo disponível',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.white, size: 36),
                const SizedBox(width: 8),
                Text(
                  '$saldo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'AmaCoins',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );

  Widget _buildResumoRegras() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Como ganhar AmaCoins?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Text('• 100 AmaCoins ao criar o perfil (boas-vindas sustentáveis)'),
              SizedBox(height: 4),
              Text('• +50 em eventos oficiais COP30 certificados'),
              SizedBox(height: 4),
              Text('• +30 em check-ins de pontos turísticos Amazônia Experience'),
            ],
          ),
        ),
      );

  Widget _buildRedeemSection(Usuario usuario) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trocas e parceiros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ..._redeemCatalog.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.green.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.redeem_outlined,
                            color: Color(0xFF0B7A4B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nome,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                item.parceiro,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.monetization_on,
                                  size: 16, color: Colors.green.shade800),
                              const SizedBox(width: 4),
                              Text(
                                '${item.custo}',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.descricao,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmarResgate(item, usuario),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.qr_code_2),
                        label: const Text('Gerar QR Code de troca'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildHistoricoSection() {
    if (_carregando) {
      return _buildHistoricoSkeleton();
    }

    if (_transacoes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Histórico da carteira',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Assim que você fizer seu primeiro check-in ou resgate, aparecerá aqui o histórico com todas as suas movimentações.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Histórico da carteira',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ..._transacoes.map(_buildTransacaoTile),
        ],
      ),
    );
  }

  Widget _buildTransacaoTile(WalletTransaction transacao) {
    final cor = transacao.isCredito
        ? Colors.green.shade600
        : Colors.red.shade600;
    final prefixo = transacao.isCredito ? '+' : '-';
    final data = transacao.data;
    final dataFormatada =
        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} '
        '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: transacao.isCredito
                  ? Colors.green.shade100
                  : Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transacao.isCredito ? Icons.arrow_downward : Icons.arrow_upward,
              color: cor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transacao.descricao,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  dataFormatada,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '$prefixo${transacao.valor.abs()}',
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarResgate(
    RedeemItem item,
    Usuario usuario,
  ) async {
    final saldoAtual = usuario.amacoins;
    if (saldoAtual < item.custo) {
      AnalyticsService.instance.logEvent(
        'wallet_redeem_error',
        properties: {
          'parceiro': item.parceiro,
          'item': item.nome,
          'motivo': 'saldo_insuficiente',
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Saldo insuficiente. Você precisa de ${item.custo} AmaCoins para esta troca.',
          ),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Confirmar resgate',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Ao confirmar, ${item.custo} AmaCoins serão debitados automaticamente da sua carteira.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                AnalyticsService.instance.logEvent(
                  'wallet_redeem_start',
                  properties: {
                    'parceiro': item.parceiro,
                    'item': item.nome,
                    'custo': item.custo,
                  },
                );
                Navigator.pop(context);
                _processarResgate(item, usuario);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.check),
              label: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processarResgate(
    RedeemItem item,
    Usuario usuario,
  ) async {
    final userId = usuario.id;
    if (userId == null) return;

    try {
      usuario.amacoins -= item.custo;
      await DatabaseHelper.instance.atualizarUsuario(usuario.toMap());
      await AppState.atualizarUsuario(usuario);

      await WalletService.instance.registrarDebito(
        userId: userId,
        descricao: 'Troca em ${item.parceiro}: ${item.nome}',
        valor: item.custo,
        contexto: {'parceiro': item.parceiro, 'item': item.nome},
      );

      AnalyticsService.instance.logEvent(
        'wallet_redeem_success',
        properties: {
          'parceiro': item.parceiro,
          'item': item.nome,
          'custo': item.custo,
        },
      );

      await _carregarTransacoes();

      if (!mounted) return;

      final payload = base64UrlEncode(
        utf8.encode(
          jsonEncode({
            'userId': userId,
            'item': item.nome,
            'parceiro': item.parceiro,
            'emitidoEm': DateTime.now().toIso8601String(),
          }),
        ),
      );

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'QR Code gerado!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Apresente no parceiro ${item.parceiro} para concluir o resgate.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              QrImageView(
                data: payload,
                version: QrVersions.auto,
                size: 220,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                '${item.nome} • ${item.custo} AmaCoins',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Código: ${payload.substring(0, 10)}...',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Fechar'),
              ),
            ],
          ),
        ),
      );
    } catch (_) {
      AnalyticsService.instance.logEvent(
        'wallet_redeem_error',
        properties: {
          'parceiro': item.parceiro,
          'item': item.nome,
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível completar o resgate com ${item.parceiro}.',
            ),
            backgroundColor: Colors.red.shade600,
          ),
        );
    }
  }

  Widget _buildHistoricoSkeleton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 18,
              width: 160,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            ...List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 12,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 16,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
