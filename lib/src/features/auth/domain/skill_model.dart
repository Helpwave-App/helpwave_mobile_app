class Skill {
  final int idSkill;
  final String skillDesc;

  Skill({required this.idSkill, required this.skillDesc});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      idSkill: json['idSkill'],
      skillDesc: json['skillDesc'],
    );
  }
}
