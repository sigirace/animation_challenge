class QuizCard {
  final int id;
  final String question;
  final String answer;

  QuizCard({
    required this.id,
    required this.question,
    required this.answer,
  });
}

final List<QuizCard> quizCards = [
  QuizCard(
    id: 1,
    question: "대한민국의 수도는?",
    answer: "서울",
  ),
  QuizCard(
    id: 2,
    question: "1 + 1 = ?",
    answer: "2",
  ),
  QuizCard(
    id: 3,
    question: "지구에서 가장 큰 대양은?",
    answer: "태평양",
  ),
  QuizCard(
    id: 4,
    question: "인간의 심장은 몇 개의 심방과 심실로 이루어져 있나?",
    answer: "2개의 심방과 2개의 심실",
  ),
  QuizCard(
    id: 5,
    question: "프로그래밍에서 Boolean이란?",
    answer: "참(true)과 거짓(false)을 나타내는 데이터 타입",
  ),
];
