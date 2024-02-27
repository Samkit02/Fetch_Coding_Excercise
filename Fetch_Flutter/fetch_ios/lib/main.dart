import 'package:fetch_ios/receipe_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dessert Recipes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DessertRecipesScreen(),
    );
  }
}

class DessertRecipesScreen extends StatefulWidget {
  @override
  _DessertRecipesScreenState createState() => _DessertRecipesScreenState();
}

class _DessertRecipesScreenState extends State<DessertRecipesScreen> {
  List<dynamic> desserts = [];

  @override
  void initState() {
    super.initState();
    fetchDessertRecipes();
  }

  Future<void> fetchDessertRecipes() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert'));
    if (response.statusCode == 200) {
      setState(() {
        desserts = json.decode(response.body)['meals'];
      });
    } else {
      throw Exception('Failed to load dessert recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dessert Recipes'),
      ),
      body: ListView.builder(
        itemCount: desserts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(desserts[index]['strMeal']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsScreen(mealId: desserts[index]['idMeal']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

