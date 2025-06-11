class Skill {
  final int idSkill;
  final String skillDesc;

  Skill({
    required this.idSkill,
    required this.skillDesc,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      idSkill: json['idSkill'],
      skillDesc: json['skillDesc'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          runtimeType == other.runtimeType &&
          idSkill == other.idSkill;

  @override
  int get hashCode => idSkill.hashCode;
}
