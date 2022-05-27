import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> _getUsers() async {

    // var data = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = await http.get(Uri.parse('https://randomuser.me/api/?results=10'));

    var jsonData = json.decode(data.body)['results'];
    List<User> users = [];

    for(var u in jsonData){

      User user = User( u["name"]["first"], u["email"], u["phone"],
          u["picture"]["large"]);

      users.add(user);

    }

    print(users.length);

    return users;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print(snapshot.data);
            if(snapshot.data == null){
              return Container(
                  child: Center(
                      child: Text("Loading...")
                  )
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card (child:ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data[index].picture)),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: (){
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                      );
                    },
                  ));
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {

  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User details"),
      ),
      body: Column(
        children: [
          Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                  backgroundImage:
                  NetworkImage(user.picture))
          ),
          SizedBox(height: 20,),
          Text('name : ${user.name}'),
          SizedBox(height: 20,),
          Text('email : ${user.email}'),
          SizedBox(height: 20,),
          Text('phone : ${user.phone}'),
        ],
      ),
    );
  }
}


class User {
  final String name;
  final String email;
  final String phone;
  final String picture;


  User(this.name, this.email,this.phone,this.picture);

}