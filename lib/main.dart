import 'package:flutter/material.dart';
import 'package:pokedex_flutter/data/graphql_gateway.dart';
import 'models/pokemon.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage> { 
  ScrollController _scrollController = new ScrollController();
 
  bool isLoading = false;
  bool reachedEnd = false;
  int nextRangeIndex = GraphQLGateway.QUERY_COUNT;
  List<Pokemon> pokemon = new List<Pokemon>();
 
  final gateway = new GraphQLGateway();
  void _getMoreData() async {
    if (reachedEnd){
      return;
    }
    
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
 
      final response = await gateway.getPokemonsRange(nextRangeIndex == GraphQLGateway.QUERY_COUNT ? 0 : nextRangeIndex, nextRangeIndex + GraphQLGateway.QUERY_COUNT);
      nextRangeIndex = nextRangeIndex + GraphQLGateway.QUERY_COUNT;
      if (response.length == 0){
        reachedEnd = true;
      }
      setState(() {
        isLoading = false;
        pokemon.addAll(response);
      });
    }
  }
 
  @override
  void initState() {
    this._getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }
 
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
 
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
 
  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: pokemon.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == pokemon.length) {
          return _buildProgressIndicator();
        } else {
          return new ListTile(
            title: Text((pokemon.elementAt(index).name)),
            onTap: () {
              print(pokemon[index]);
            },
          );
        }
      },
      controller: _scrollController,
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagination"),
      ),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}