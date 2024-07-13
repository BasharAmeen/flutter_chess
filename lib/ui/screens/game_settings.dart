import 'package:flutter/material.dart';
 
class GameSettings extends StatefulWidget {
  const GameSettings({super.key});

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: []),
    );
  }
}

// Column percentIndicatorMaker() {
//   return Column(
//     children: [
//       CircularPercentIndicator(
//         radius: 90,
//         animation: true,
//         animationDuration: 500,
//         center: const Icon(
//           Icons.health_and_safety,
//           size: 50,
//         ),
//         lineWidth: 7,
//         percent: _value,
//       ),
//       LinearPercentIndicator(
//         width: 140.0,
//         lineHeight: 14.0,
//         percent: _value,
//         backgroundColor: Colors.grey,
//         progressColor: Colors.blue,
//       ),
//       const SizedBox(
//         height: 100,
//       ),
//       Slider(
//         value: _value,
//         onChanged: (a) => setState(() => _value = a),
//         divisions: 10,
//         min: 0,
//         max: 1,
//       ),
//     ],
//   );
// }
