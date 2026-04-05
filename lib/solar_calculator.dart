import 'dart:math';

class SolarProfitResults {
  // До вдосконалення
  final String pd;
  final String deltaW1Per;
  final String w1;
  final String d1;
  final String w2;
  final String p1;
  final String sh1;
  final String loss;

  // Після вдосконалення
  final String deltaW2Per;
  final String w3;
  final String d2;
  final String w4;
  final String p2;
  final String sh2;
  final String p;

  SolarProfitResults({
    required this.pd,
    required this.deltaW1Per,
    required this.w1,
    required this.d1,
    required this.w2,
    required this.p1,
    required this.sh1,
    required this.loss,
    required this.deltaW2Per,
    required this.w3,
    required this.d2,
    required this.w4,
    required this.p2,
    required this.sh2,
    required this.p,
  });
}

class SolarProfitCalculator {
  // Константи з HTML
  static const double delta = 5.0;          // Номінальна потужність P = 5 ± 0.25 МВт
  static const double deviation = 0.25;      // Відхилення ±0.25 МВт

  // Розрахунок нормального закону потужності
  static double calculatePd(double sigma) {
    if (sigma <= 0) return 0;

    // (P-Pc)^2 = (0.25)^2 = 0.0625
    double expDegree = 0.0625 / (2 * sigma * sigma);
    double pdNumerator = exp(expDegree);
    double pdDenominator = sigma * sqrt(2 * pi);

    return pdNumerator / pdDenominator;
  }

  static SolarProfitResults calculate(
      double pc,      // Середньодобова потужність (МВт)
      double sigma1,  // Середньоквадратичне відхилення (МВт)
      double sigma2,  // Зменшена похибка (МВт)
      double price,   // Вартість електроенергії (грн/кВт·год)
      ) {
    print('=== ДЕБАГ: РОЗРАХУНОК ПРИБУТКУ СЕС ===');
    print('Вхідні дані:');
    print('Pc = $pc МВт');
    print('σ₁ = $sigma1 МВт');
    print('σ₂ = $sigma2 МВт');
    print('Ціна = $price грн/кВт·год');

    // ========== ДО ВДОСКОНАЛЕННЯ ==========

    // 1. Нормальний закон потужності
    double pd = calculatePd(sigma1);
    print('\n1. pd (σ₁) = $pd МВт');

    // 2. Частка енергії без небалансів
    double deltaW1 = pd * 0.5;
    double deltaW1Per = deltaW1 * 100;
    print('2. ΔW₁ = $deltaW1 ($deltaW1Per%)');

    // 3. Енергія W1 (в межах допуску)
    double w1 = pc * 24 * deltaW1;
    print('3. W₁ = $w1 МВт·год');

    // 4. Частка енергії поза допуском
    double d1 = (1 - deltaW1) * 100;
    double w2 = pc * 24 * (1 - deltaW1);
    print('4. W₂ = $w2 МВт·год ($d1%)');

    // 5. Прибуток та штраф
    double p1 = w1 * price;
    double sh1 = w2 * price;
    double loss = sh1 - p1;
    print('5. П₁ = $p1 тис.грн, Ш₁ = $sh1 тис.грн, Збиток = $loss тис.грн');

    // ========== ПІСЛЯ ВДОСКОНАЛЕННЯ ==========

    // За даними з HTML: після вдосконалення Delta_W2 = 0.68 (68%)
    double deltaW2 = 0.68;
    double deltaW2Per = deltaW2 * 100;

    // Енергія в межах допуску
    double w3 = pc * 24 * deltaW2;

    // Енергія поза допуском
    double d2 = (1 - deltaW2) * 100;
    double w4 = pc * 24 * (1 - deltaW2);

    // Прибуток та штраф після вдосконалення
    double p2 = w3 * price;
    double sh2 = w4 * price;
    double profit = p2 - sh2;

    print('\n6. Після вдосконалення:');
    print('   ΔW₂ = $deltaW2 ($deltaW2Per%)');
    print('   W₃ = $w3 МВт·год');
    print('   W₄ = $w4 МВт·год');
    print('   П₂ = $p2 тис.грн, Ш₂ = $sh2 тис.грн');
    print('   Прибуток = $profit тис.грн');
    print('=====================================\n');

    return SolarProfitResults(
      // До вдосконалення
      pd: pd.toStringAsFixed(2),
      deltaW1Per: deltaW1Per.toStringAsFixed(0),
      w1: w1.toStringAsFixed(2),
      d1: d1.toStringAsFixed(0),
      w2: w2.toStringAsFixed(2),
      p1: p1.toStringAsFixed(2),
      sh1: sh1.toStringAsFixed(2),
      loss: loss.toStringAsFixed(2),

      // Після вдосконалення
      deltaW2Per: deltaW2Per.toStringAsFixed(0),
      w3: w3.toStringAsFixed(2),
      d2: d2.toStringAsFixed(0),
      w4: w4.toStringAsFixed(2),
      p2: p2.toStringAsFixed(2),
      sh2: sh2.toStringAsFixed(2),
      p: profit.toStringAsFixed(2),
    );
  }
}