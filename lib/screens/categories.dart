import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Category {
  int id;
  String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<List<Category>> futureCategories;
  final _formKey = GlobalKey<FormState>();
  late Category selectedCategory;
  final CategoryNameController = TextEditingController();

  Future<List<Category>> fetchCategories() async {
    http.Response response =
        await http.get(Uri.parse('http://localhost/api/categories'));

    List categories = json.decode(response.body);

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future saveCategory() async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }
    String uri =
        'http://localhost/api/categories/' + selectedCategory.id.toString();
    await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: json.encode({
          'name': CategoryNameController.text,
        }));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: FutureBuilder<List<Category>>(
          future: futureCategories,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Category category = snapshot.data![index];
                  return ListTile(
                      title: Text(category.name),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          selectedCategory = category;
                          CategoryNameController.text = category.name;
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(children: <Widget>[
                                          TextFormField(
                                            controller: CategoryNameController,
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'enter category name';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Category Name',
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: Text('Save'),
                                            onPressed: () => saveCategory(),
                                          )
                                        ])));
                              });
                        },
                      ));
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ));
  }
}
