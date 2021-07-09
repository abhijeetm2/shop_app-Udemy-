import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class TextFieldAutoComplete extends StatefulWidget {
  @override
  _TextFieldAutoCompleteState createState() => _TextFieldAutoCompleteState();
}

class _TextFieldAutoCompleteState extends State<TextFieldAutoComplete> {
  var _suggestionTextFiendController = TextEditingController();

  List suggestion = [
    'kalyan',
    'dombiwali',
    'koliwada',
    'andheri',
    'asangaon',
    'pune',
    'jalgaon',
    'nashik',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('demo textfield'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AutoCompleteTextField(
              clearOnSubmit: false,
              controller: _suggestionTextFiendController,
              itemSubmitted: (item) {
                return _suggestionTextFiendController.text = item.toString();
              },
              suggestions: suggestion,
              itemBuilder: (context, item) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    item.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
              itemSorter: (a, b) {
                return a.toString().compareTo(b.toString());
              },
              itemFilter: (item, query) {
                return item
                    .toString()
                    .toLowerCase()
                    .startsWith(query.toLowerCase());
              },
            )
          ],
        ),
      ),
    );
  }
}
