import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class HomePage extends StatefulWidget {
  final IOWebSocketChannel channel;

  HomePage(@required this.channel);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = TextEditingController();

  connectWebSocket() {
    if (editingController.text.isNotEmpty) {
      widget.channel.sink.add(editingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 32, horizontal: 18),
              child: TextFormField(
                controller: editingController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(90)))),
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                //active
                if (snapshot.connectionState.index == 2) {
                  return connected(snapshot.data);
                }
                return connecting(snapshot.connectionState.toString());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          connectWebSocket();
        },
        child: Icon(Icons.send),
      ),
    );
  }

  Widget connected(String data) {
    return Container(
      child: Center(
        child: Text(
          data,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget connecting(String state) {
    return Container(
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(),
          Text(
            state,
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
