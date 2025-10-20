import 'dart:ui';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/analytics_service.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';
import '../utils/app_state.dart';
import '../utils/image_resolver.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = AppState.usuarioLogado;
    if (usuario == null) {
      return const Drawer(
        child: Center(child: Text('Usuário não encontrado')),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeMode,
      builder: (context, themeMode, _) => ValueListenableBuilder<Locale>(
        valueListenable: LocaleService.instance.locale,
        builder: (context, locale, __) {
          final l10n = AppLocalizations.of(context);
          final itensComuns = _buildMenuComum();
          final itensAdministrador = _buildMenuAdministrador();
          final itensMenu = [
            ...itensComuns,
            if (usuario.isAdministrador) ...itensAdministrador,
          ];

          final isDark = themeMode == ThemeMode.dark;
          final idiomaAtual = LocaleService.instance.labelFor(locale);

          return Drawer(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF1E1E1E).withOpacity(0.95),
                              const Color(0xFF121212).withOpacity(0.94),
                            ]
                          : [
                              Colors.white.withOpacity(0.92),
                              Colors.white.withOpacity(0.82),
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DrawerHeader(
                          usuario.nome,
                          usuario.fotoPerfil,
                          usuario.isAdministrador,
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: itensMenu.length,
                            separatorBuilder: (_, __) =>
                                Divider(color: Colors.grey.shade200, height: 1),
                            itemBuilder: (context, index) {
                              final item = itensMenu[index];
                              return _buildDrawerItem(context, item);
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          value: isDark,
                          onChanged: (value) async {
                            await ThemeService.instance.toggleDarkMode(value);
                            AnalyticsService.instance.logEvent(
                              'settings_change_theme',
                              properties: {'modo': value ? 'dark' : 'light'},
                            );
                          },
                          title: Text(
                            l10n.drawerDarkMode,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          secondary: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            color: Colors.green.shade700,
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.language, color: Colors.green.shade700),
                          title: Text(
                            l10n.drawerLanguage(idiomaAtual),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          onTap: () => _mostrarSeletorIdioma(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _logout(context, l10n),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade100,
                              foregroundColor: Colors.red.shade700,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.logout),
                            label: Text(l10n.drawerLogout),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<_DrawerItem> _buildMenuComum() => [
        _DrawerItem(
          icone: Icons.home,
          label: (l10n) => l10n.drawerHome,
          rota: '/home',
        ),
        _DrawerItem(
          icone: Icons.person_outline,
          label: (l10n) => l10n.drawerProfile,
          rota: '/perfil',
        ),
        _DrawerItem(
          icone: Icons.account_balance_wallet_outlined,
          label: (l10n) => l10n.drawerWallet,
          rota: '/carteira',
        ),
        _DrawerItem(
          icone: Icons.qr_code_scanner,
          label: (l10n) => l10n.drawerCheckIn,
          rota: '/checkin',
        ),
        _DrawerItem(
          icone: Icons.emergency_share_outlined,
          label: (l10n) => l10n.drawerEmergency,
          rota: '/emergencia',
        ),
        _DrawerItem(
          icone: Icons.chat_bubble_outline,
          label: (l10n) => l10n.drawerChat,
          rota: '/chat',
        ),
      ];

  List<_DrawerItem> _buildMenuAdministrador() => [
        _DrawerItem(
          icone: Icons.group_outlined,
          label: (l10n) => l10n.drawerManageUsers,
          rota: '/admin/usuarios',
        ),
        _DrawerItem(
          icone: Icons.place_outlined,
          label: (l10n) => l10n.drawerManagePoints,
          rota: '/admin/pontos',
        ),
        _DrawerItem(
          icone: Icons.pie_chart_outline,
          label: (l10n) => l10n.drawerStatistics,
          rota: '/admin/estatisticas',
        ),
      ];

  Widget _buildDrawerItem(BuildContext context, _DrawerItem item) => ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E2A24)
                : Colors.green.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(item.icone, color: Colors.green.shade700),
        ),
        title: Text(
          item.label(AppLocalizations.of(context)),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, item.rota);
        },
      );

  void _logout(BuildContext context, AppLocalizations l10n) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.drawerLogoutTitle),
          content: Text(l10n.drawerLogoutMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.drawerCancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                await AppState.logout();
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: Text(
                l10n.drawerConfirm,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
}

Future<void> _mostrarSeletorIdioma(BuildContext context) async {
  final atual = LocaleService.instance.locale.value;
  final l10n = AppLocalizations.of(context);
  final selecionado = await showModalBottomSheet<Locale>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final bottomInset = MediaQuery.of(context).viewPadding.bottom;
      return SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
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
                l10n.dialogSelectLanguageTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...LocaleService.supportedLocales.map(
                (locale) => RadioListTile<Locale>(
                  value: locale,
                  groupValue: atual,
                  onChanged: (value) => Navigator.pop(context, value),
                  title: Text(LocaleService.instance.labelFor(locale)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (selecionado != null && selecionado != atual) {
    final messenger = ScaffoldMessenger.of(context);
    final sucesso =
        await LocaleService.instance.setLocale(selecionado);
    if (!sucesso) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.languageChangeError)),
        );
      return;
    }
    AnalyticsService.instance.logEvent(
      'settings_change_language',
      properties: {'idioma': selecionado.toLanguageTag()},
    );
  }
}

class _DrawerItem {
  const _DrawerItem({
    required this.icone,
    required this.label,
    required this.rota,
  });

  final IconData icone;
  final String Function(AppLocalizations) label;
  final String rota;
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader(this.nome, this.fotoPerfil, this.isAdmin);

  final String nome;
  final String? fotoPerfil;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final primeiroNome = nome.split(' ').first;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final avatarImage = resolveUserImage(fotoPerfil);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor:
                    isDark ? const Color(0xFF2C2C2C) : Colors.green.shade100,
                backgroundImage: avatarImage,
                child: avatarImage == null
                    ? Icon(Icons.person, size: 36, color: Colors.green.shade800)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .drawerGreeting(primeiroNome),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAdmin ? l10n.roleAdmin : l10n.roleUser,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              isAdmin ? Colors.orange.shade800 : Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.drawerSettingsHint,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
