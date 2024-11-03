import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Информация о коктейлях',
      theme: ThemeData(
        canvasColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Функция для эмуляции длительной загрузки данных
Future<String> fetchCocktailData(String cocktailName) async {
  await Future.delayed(const Duration(seconds: 2));
  return "Данные о коктейле '$cocktailName' загружены";
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Коктейли')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyCocktailsScreen()),
            );
          },
          child: const Text('Посмотреть коктейли'),
        ),
      ),
    );
  }
}

class MyCocktailsScreen extends StatefulWidget {
  const MyCocktailsScreen({super.key});

  @override
  _MyCocktailsScreenState createState() => _MyCocktailsScreenState();
}

class _MyCocktailsScreenState extends State<MyCocktailsScreen> {
  final List<String> cocktailNames = [
    'Мохито',
    'Маргарита',
    'Пина Колада',
    'Куба Либре',
    'Космополитен'
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список коктейлей')),
      body: Center(
        child: CocktailDetailButton(cocktailName: cocktailNames[_selectedIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: cocktailNames
            .map((name) => BottomNavigationBarItem(
          icon: const Icon(Icons.local_drink),
          label: name,
        ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CocktailDetailButton extends StatefulWidget {
  final String cocktailName;

  const CocktailDetailButton({super.key, required this.cocktailName});

  @override
  _CocktailDetailButtonState createState() => _CocktailDetailButtonState();
}

class _CocktailDetailButtonState extends State<CocktailDetailButton> {
  bool isLoading = false;

  Future<void> _loadCocktailDetails(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final data = await fetchCocktailData(widget.cocktailName);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CocktailDetailScreen(
          title: widget.cocktailName,
          description: data,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
        onPressed: () => _loadCocktailDetails(context),
        child: Text('Подробнее о ${widget.cocktailName}'),
      ),
    );
  }
}

class CocktailDetailScreen extends StatelessWidget {
  final String title;
  final String description;

  const CocktailDetailScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Назад'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
