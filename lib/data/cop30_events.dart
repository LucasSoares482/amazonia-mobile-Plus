class Cop30Event {
  const Cop30Event({
    required this.nome,
    required this.local,
    required this.horario,
  });

  final String nome;
  final String local;
  final String horario;
}

const List<Cop30Event> cop30OficialEvents = [
  Cop30Event(
    nome: 'Cerimônia de Abertura',
    local: 'Centro de Convenções Hangar',
    horario: '10 de novembro • 09:00',
  ),
  Cop30Event(
    nome: 'Painel Temático: Mudanças Climáticas e Amazônia',
    local: 'Estação das Docas – Auditório Paulo Mendes',
    horario: '10 de novembro • 14:00',
  ),
  Cop30Event(
    nome: 'Fórum Climático Global',
    local: 'Teatro da Paz',
    horario: '11 de novembro • 09:30',
  ),
  Cop30Event(
    nome: 'Cúpula da Juventude pelo Clima',
    local: 'Universidade Federal do Pará',
    horario: '11 de novembro • 15:00',
  ),
  Cop30Event(
    nome: 'Encontro de Líderes Indígenas',
    local: 'Museu Paraense Emílio Goeldi',
    horario: '12 de novembro • 10:00',
  ),
  Cop30Event(
    nome: 'Mesa-Redonda: Economia Verde e Amazônia',
    local: 'Casa das Onze Janelas',
    horario: '12 de novembro • 16:00',
  ),
  Cop30Event(
    nome: 'Show Cultural Amazônico',
    local: 'Ver-o-Peso – Praça do Pescador',
    horario: '13 de novembro • 19:30',
  ),
  Cop30Event(
    nome: 'Sessão Plenária Extraordinária',
    local: 'Centro de Convenções Hangar',
    horario: '14 de novembro • 09:00',
  ),
  Cop30Event(
    nome: 'Feira de Inovação Climática',
    local: 'Mangal das Garças',
    horario: '14 de novembro • 13:00',
  ),
  Cop30Event(
    nome: 'Cerimônia de Encerramento',
    local: 'Praça da República',
    horario: '15 de novembro • 18:00',
  ),
];
