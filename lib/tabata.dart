import 'package:flutter/material.dart';
import 'package:tabata_timer/tabata_countdown.dart';

class TabataPage extends StatefulWidget {
  const TabataPage({super.key, required this.title});

  final String title;

  @override
  State<TabataPage> createState() => _TabataPageState();
}

class _TabataPageState extends State<TabataPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _work = 20;
  int _rest = 10;
  int _rounds = 8;
  int _cycles = 1;

  void setWork(int newWork) {
    setState(() {
      _work = newWork;
    });
  }

  void setRest(int newWork) {
    setState(() {
      _rest = newWork;
    });
  }

  void setRounds(int newWork) {
    setState(() {
      _rounds = newWork;
    });
  }

  void setCycles(int newWork) {
    setState(() {
      _cycles = newWork;
    });
  }

  String? Function(String?) numberValidator(void Function(int) setter) {
    return (value) {
      if (value == null) {
        return "Введите пожалуйста число";
      }
      int? number = int.tryParse(value);
      if (number == null) {
        return "Введите пожалуйста корректное число";
      }
      setter(number);
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 5,
                style: BorderStyle.solid,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text("Время работы", textScaleFactor: 48 / 18),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: _work.toString(),
                    validator: numberValidator(setWork),
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.blueAccent, fontSize: 40),
                  ),
                  const Text("Время отдыха", textScaleFactor: 48 / 18),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: _rest.toString(),
                    validator: numberValidator(setRest),
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.blueAccent, fontSize: 40),
                  ),
                  const Text("Число раундов", textScaleFactor: 48 / 18),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: _rounds.toString(),
                    validator: numberValidator(setRounds),
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.blueAccent, fontSize: 40),
                  ),
                  const Text("Число циклов", textScaleFactor: 48 / 18),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: _cycles.toString(),
                    validator: numberValidator(setCycles),
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.blueAccent, fontSize: 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TabataCountdownPage(
                            title: "Работа",
                            work: _work,
                            cycles: _cycles,
                            rest: _rest,
                            rounds: _rounds,
                          );
                        }));
                      },
                      child: const Text(
                        "Начать тренировку",
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
