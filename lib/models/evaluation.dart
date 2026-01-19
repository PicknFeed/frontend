class Evaluation {
  final int id;
  final String evaluator; // company
  final String target;    // person
  final int score;        // 1 ~ 5
  final String comment;
  final String createdAt;

  Evaluation({
    required this.id,
    required this.evaluator,
    required this.target,
    required this.score,
    required this.comment,
    required this.createdAt,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      evaluator: json['evaluator'],
      target: json['target'],
      score: json['score'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }
}
