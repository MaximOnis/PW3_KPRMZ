import 'package:flutter/material.dart';
import 'solar_calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Profit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.orangeAccent,
        ),
      ),
      home: const SolarProfitScreen(),
    );
  }
}

class SolarProfitScreen extends StatefulWidget {
  const SolarProfitScreen({super.key});

  @override
  State<SolarProfitScreen> createState() => _SolarProfitScreenState();
}

class _SolarProfitScreenState extends State<SolarProfitScreen> {
  final _pcController = TextEditingController();
  final _sigma1Controller = TextEditingController();
  final _sigma2Controller = TextEditingController();
  final _priceController = TextEditingController();

  SolarProfitResults? results;

  void calculate() {
    double pc = double.tryParse(_pcController.text) ?? 0;
    double s1 = double.tryParse(_sigma1Controller.text) ?? 0;
    double s2 = double.tryParse(_sigma2Controller.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0;

    setState(() {
      results = SolarProfitCalculator.calculate(pc, s1, s2, price);
    });
  }

  void clear() {
    setState(() {
      _pcController.clear();
      _sigma1Controller.clear();
      _sigma2Controller.clear();
      _priceController.clear();
      results = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Калькулятор"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: calculate,
            heroTag: "calc",
            child: const Icon(Icons.calculate),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: clear,
            backgroundColor: Colors.redAccent,
            heroTag: "clear",
            child: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _buildCard(
              child: Column(
                children: [
                  _input("Потужність (МВт)", _pcController, Icons.flash_on),
                  _input("σ₁", _sigma1Controller, Icons.show_chart),
                  _input("σ₂", _sigma2Controller, Icons.trending_down),
                  _input("Ціна (грн/кВт·год)", _priceController, Icons.attach_money),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (results != null)
              _resultFullCard(results!)
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _input(String hint, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orangeAccent),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF020617),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _resultFullCard(SolarProfitResults r) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "ДО ВДОСКОНАЛЕННЯ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.white),

          _row("Потужність", "${r.pd} МВт"),
          _row("Без небалансів", "${r.deltaW1Per}%"),
          _row("W1", "${r.w1} МВт·год"),
          _row("W2", "${r.w2} МВт·год"),
          _row("Прибуток", "${r.p1} тис. грн"),
          _row("Штраф", "${r.sh1} тис. грн"),
          _row("Збиток", "${r.loss} тис. грн"),

          const SizedBox(height: 15),

          const Text(
            "ПІСЛЯ ВДОСКОНАЛЕННЯ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.white),

          _row("Без небалансів", "${r.deltaW2Per}%"),
          _row("W3", "${r.w3} МВт·год"),
          _row("W4", "${r.w4} МВт·год"),
          _row("Прибуток", "${r.p2} тис. грн"),
          _row("Штраф", "${r.sh2} тис. грн"),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _row(
              "ФІНАЛЬНИЙ ПРИБУТОК",
              "${r.p} тис. грн",
              isBold: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              )),
          Text(value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pcController.dispose();
    _sigma1Controller.dispose();
    _sigma2Controller.dispose();
    _priceController.dispose();
    super.dispose();
  }
}