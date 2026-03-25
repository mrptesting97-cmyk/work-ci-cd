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
  bool _isLoading = false;

  final List<Map<String, String>> _icons = [
    {'name': 'DefaultIcon', 'label': 'Default'},
    {'name': 'IconOne', 'label': 'Hot Wheels'},
    {'name': 'IconTwo', 'label': 'Hot Wheels 2'},
  ];

  Future<void> _setIcon(String name) async {
    if (name == _current) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This icon is already active')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _channel.invokeMethod('setLauncherIcon', {'icon': name});
      setState(() {
        _current = name;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'App icon changed to: ${_icons.firstWhere((i) => i['name'] == name)['label']}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on PlatformException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message ?? "Failed to change icon"}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change App Icon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Click a button to change your app icon instantly',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _icons.map((iconData) {
                final iconName = iconData['name']!;
                final isActive = iconName == _current;

                return ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _setIcon(iconName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive ? Colors.blue : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  icon: _isLoading && isActive
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(
                          isActive ? Icons.check_circle : Icons.circle_outlined,
                          size: 18,
                        ),
                  label: Text(iconData['label']!),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info, color: Colors.blue[700], size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Current: ${_icons.firstWhere((i) => i['name'] == _current)['label']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
