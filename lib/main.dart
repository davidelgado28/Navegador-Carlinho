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
      title: 'Navegador Carlinho - Privacidade',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const PrivacyDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrivacyDashboardScreen extends StatefulWidget {
  const PrivacyDashboardScreen({super.key});

  @override
  State<PrivacyDashboardScreen> createState() => _PrivacyDashboardScreenState();
}

class _PrivacyDashboardScreenState extends State<PrivacyDashboardScreen> {
  late final AdBlockerEngine _adBlocker;
  final TextEditingController _urlController = TextEditingController();
  
  String _statusMessage = 'Insira uma URL acima para testar o bloqueador nativo de rede.';
  Color _statusColor = Colors.blueGrey;
  bool _isEngineLoaded = false;

  @override
  void initState() {
    super.initState();
    try {
      _adBlocker = AdBlockerEngine();
      _isEngineLoaded = true;
    } catch (e) {
      _isEngineLoaded = false;
      _statusMessage = 'Aviso: Motor C++ nativo rodando em modo simulação (Biblioteca binária não compilada nesta plataforma ainda).';
      _statusColor = Colors.orangeAccent;
    }
  }

  @override
  void dispose() {
    if (_isEngineLoaded) {
      _adBlocker.dispose();
    }
    _urlController.dispose();
    super.dispose();
  }

  void _testUrl() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    bool isBlocked = false;
    if (_isEngineLoaded) {
      isBlocked = _adBlocker.shouldBlock(url);
    } else {
      isBlocked = url.contains('ads') || url.contains('tracker') || url.contains('doubleclick');
    }

    setState(() {
      if (isBlocked) {
        _statusMessage = 'BLOQUEADO NATIVAMENTE!\nA requisição foi interceptada antes de sair da pilha de rede.';
        _statusColor = Colors.redAccent;
      } else {
        _statusMessage = 'PERMITIDO\nTráfego limpo e seguro.';
        _statusColor = Colors.greenAccent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ Painel de Privacidade - Navegador Carlinho'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      _isEngineLoaded ? Icons.security : Icons.info_outline,
                      color: _isEngineLoaded ? Colors.green : Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Motor C++/Rust (uBlock Engine)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          _isEngineLoaded ? 'Status: Ativo (C-API via FFI)' : 'Status: Modo de Teste de UI',
                          style: TextStyle(color: _isEngineLoaded ? Colors.greenAccent : Colors.orangeAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Simulador de Requisição Web (Network Interceptor)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de Destino',
                      hintText: 'Ex: https://ads.g.doubleclick.net/banner',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _testUrl,
                  icon: const Icon(Icons.bolt),
                  label: const Text('Testar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  border: Border.all(color: _statusColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _statusColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Dica: Teste URLs como "https://ads.g.doubleclick.net" ou "https://github.com"',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
