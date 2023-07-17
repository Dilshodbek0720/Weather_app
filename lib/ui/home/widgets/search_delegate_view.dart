import 'package:flutter/material.dart';

class SearchDelegateView extends SearchDelegate {
  SearchDelegateView({required this.suggestionList});

  final List<String> suggestionList;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
        child: Text(
          query,
          style: const TextStyle(fontSize: 24),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = suggestionList.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
      //["Olmazor","Samarqand","Moscow"]
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          suggestions.length,
              (index) => GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7), color: Colors.black),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                suggestions[index],
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            onTap: () {
              query = suggestions[index];
              //showResults(context);
              close(context, query);
            },
          ),
        ),
      ),
    );
  }
}