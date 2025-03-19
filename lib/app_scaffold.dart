// Agora, modifique a classe AppScaffold para gerenciar a navegação
import 'package:flutter/material.dart';
import 'package:gym_stats/signin_page.dart';
import 'package:gym_stats/login_page.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'home-page.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final String title;

  const AppScaffold({super.key, required this.body, required this.title});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOpacity = 0.0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final double opacity = offset < 100 ? offset / 100 : 1.0;
    if (opacity != _scrollOpacity) {
      setState(() {
        _scrollOpacity = opacity;
      });
    }
  }

  Widget _getBodyForIndex(int index) {
    switch (index) {
      case 0:
        return HomeContent();
      case 1:
        return LoginPage();
      case 3: // Assumindo que o botão Conta seja o índice 3
        return RegisterPage();
      default:
        return HomeContent();
    }
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Gym Stats';
      case 3:
        return 'Minha Conta';
      default:
        return 'Gym Stats';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final appBarColor =
        isDarkMode
            ? Color(0xFF121212).withOpacity(_scrollOpacity)
            : Colors.white.withOpacity(_scrollOpacity);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ImprovedBackgroundCurves(),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: appBarColor,
                elevation: _scrollOpacity * 4,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    _getTitleForIndex(_currentIndex),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  centerTitle: true,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: _getBodyForIndex(_currentIndex),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton(
                onPressed: () {},
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.add),
              )
              : null,
    );
  }
}

// Implementação do CustomBottomNavigationBar
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final selectedItemColor = Theme.of(context).colorScheme.primary;
    final unselectedItemColor =
        isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Progresso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Conta',
          ),
        ],
      ),
    );
  }
}

// Certifique-se de que ImprovedBackgroundCurves esteja implementado
class ImprovedBackgroundCurves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;

    return Container(
      height: 220,
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryColor.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 100,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tertiaryColor.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
