import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp(
    sharedPrefs: await SharedPreferences.getInstance()
  ));
}

class MainApp extends StatefulWidget {

  static const String _nameKey = "name";
  static const String _modeKey = "mode";
  final SharedPreferences sharedPrefs;
  const MainApp({super.key, required this.sharedPrefs});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {

    final TextEditingController controller = TextEditingController();

    bool   switchValue = widget.sharedPrefs.getBool(MainApp._modeKey)   ?? false;
    String displayName = widget.sharedPrefs.getString(MainApp._nameKey) ?? " ";

    void saveName(String name) {
      widget.sharedPrefs.setString(MainApp._nameKey, name);
      setState(() {
        controller.clear();
        displayName = name;
      });
    }

    void reset(TextEditingController controller) {
      setState(() {
        controller.clear();
        widget.sharedPrefs.remove(MainApp._nameKey); 
      });
    }

    void onSwitchToggle(bool value) {
      widget.sharedPrefs.setBool(MainApp._modeKey, value);
      setState(() {
        
      });
    }

    ThemeData getTheme(bool darkMode) {
      if (!darkMode) {
        return ThemeData.light(useMaterial3: true);
      } else {
        return ThemeData.dark(useMaterial3: true);
      }
    }

    return MaterialApp(
      theme: getTheme(switchValue),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Switch(value: switchValue, onChanged: (bool value) => onSwitchToggle(value))
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Flex(
                spacing: 32,
                mainAxisSize: MainAxisSize.min,
                direction: Axis.vertical,
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hint: Text("Enter your Name")
                    ),
                  ),
                  Text(displayName.trim().isNotEmpty ? "I remember you. Your name is $displayName" : " "),
                  ElevatedButton(onPressed: () => {saveName(controller.text)}, child: Text("Save your name")),
                  ElevatedButton(onPressed: () => {reset(controller)}, child: Text("Reset")),                 
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
