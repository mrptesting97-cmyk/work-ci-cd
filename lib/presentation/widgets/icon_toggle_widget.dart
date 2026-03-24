import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IconToggleWidget extends StatefulWidget {
  const IconToggleWidget({Key? key}) : super(key: key);

  @override
  State<IconToggleWidget> createState() => _IconToggleWidgetState();
}

class _IconToggleWidgetState extends State<IconToggleWidget> {
  static const _channel = MethodChannel('app.icon');
  String _current = 'DefaultIcon';

  Future<void> _setIcon(String name) async {
    try {
      await _channel.invokeMethod('setLauncherIcon', {'icon': name});
      setState(() => _current = name);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Requested icon: $name')));
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Launcher Icon'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _setIcon('DefaultIcon'),
                  child: const Text('Default'),
                ),
                ElevatedButton(onPressed: () => _setIcon('IconOne'), child: const Text('Icon One')),
                ElevatedButton(onPressed: () => _setIcon('IconTwo'), child: const Text('Icon Two')),
              ],
            ),
            const SizedBox(height: 8),
            Text('Current selection: $_current'),
          ],
        ),
      ),
    );
  }
}
