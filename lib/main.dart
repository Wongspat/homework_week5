import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() => runApp(DimensionC137App());

class DimensionC137App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dimension C-137',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.cyanAccent,
              displayColor: Colors.cyanAccent,
              fontFamily: 'YourFontFamily', // Replace with your font family
            ),
      ),
      home: CharacterDirectory(),
    );
  }
}

class InterdimensionalCharacter {
  final String? designation;
  final String? vitalityStatus;
  final String? originSpecies;
  final String? imageLink;

  InterdimensionalCharacter({
    this.designation,
    this.vitalityStatus,
    this.originSpecies,
    this.imageLink,
  });

  factory InterdimensionalCharacter.fromJson(Map<String, dynamic> json) {
    return InterdimensionalCharacter(
      designation: json['name'],
      vitalityStatus: json['status'],
      originSpecies: json['species'],
      imageLink: json['image'],
    );
  }
}

class CharacterDirectory extends StatefulWidget {
  @override
  _CharacterDirectoryState createState() => _CharacterDirectoryState();
}

class _CharacterDirectoryState extends State<CharacterDirectory> {
  List<InterdimensionalCharacter>? beings;

  @override
  void initState() {
    super.initState();
    retrieveBeings();
  }

  Future<void> retrieveBeings() async {
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    try {
      final response = await dio.get('https://api.sampleapis.com/rickandmorty/characters');
      final List<dynamic> data = jsonDecode(response.data);

      setState(() {
        beings = data.map((json) => InterdimensionalCharacter.fromJson(json)).toList();
      });
    } catch (error) {
      print('Error retrieving data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick And Morty'),
        backgroundColor: Colors.deepPurple, // Example of changing app bar color
      ),
      body: beings == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: beings!.length,
              itemBuilder: (context, index) {
                var entity = beings![index];
                return EntityTile(entity: entity);
              },
            ),
    );
  }
}

class EntityTile extends StatelessWidget {
  final InterdimensionalCharacter entity;

  const EntityTile({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        entity.designation ?? 'Unknown Entity',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), // Adjusted font size for the list tile
      ),
      leading: entity.imageLink != null
          ? Image.network(entity.imageLink!, width: 60, height: 60) // Adjusted image size
          : SizedBox(width: 60, height: 60, child: Placeholder()),
      onTap: () => displayEntityDialog(context, entity),
    );
  }

  void displayEntityDialog(BuildContext context, InterdimensionalCharacter entity) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            entity.designation ?? 'Unknown Entity',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), // Increased font size for the dialog title
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Vitality Status: ${entity.vitalityStatus}',
                style: TextStyle(fontSize: 18.0), // Increased font size for the content
              ),
              SizedBox(height: 8), // Added some spacing
              Text(
                'Origin Species: ${entity.originSpecies}',
                style: TextStyle(fontSize: 18.0), // Increased font size for the content
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: TextStyle(fontSize: 18.0)), // Increased font size for the button
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
