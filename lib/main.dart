import 'package:flutter/material.dart';
import 'ad_blocker_ffi.dart'; 

void main() {
  runApp(const PrivacyBrowserApp());
}

class PrivacyBrowserApp extends StatelessWidget {
  const PrivacyBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navegador Privado',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const BrowserHomeScreen(),
    );
  }
}

class BrowserHomeScreen extends StatefulWidget {
  const BrowserHomeScreen({super.key});

  @override
  State<BrowserHomeScreen> createState() => _BrowserHomeScreenState();
}

class _BrowserHomeScreenState extends State<BrowserHomeScreen> {
  late final AdBlockerEngine _adBlocker;
  final TextEditingController _urlController = TextEditingController();
  
  String _statusMessage = 'Digite uma URL para testar o bloqueador nativo.';
  Color _statusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _adBlocker = AdBlockerEngine();
  }

  @override
  void dispose() {
    _adBlocker.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _testUrl() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    final bool isBlocked = _adBlocker.shouldBlock(url);

    setState(() {
      if (isBlocked) {
        _statusMessage = '🚫 BLOQUEADO PELO MOTOR NATIVO: $url';
        _statusColor = Colors.red;
      } else {
        _statusMessage = '✅ PERMITIDO: $url';
        _statusColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel de Privacidade - FFI Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL da Requisição',
                hintText: 'Ex: https://ads.g.doubleclick.net/...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _testUrl,
              child: const Text('Testar Requisição de Rede'),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              color: _statusColor.withOpacity(0.1),
              child: Text(
                _statusMessage,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _statusColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
