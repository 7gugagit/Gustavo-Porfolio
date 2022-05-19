import 'package:flutter/material.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';


/// The home page for the website, land here from the login screen
/// gridview with 5 squares, can access dashboard, articles, news and events,
/// depots, and account management.

class Home extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar
        (
        leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }
        ),
        title: Text("Milk Matters"),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: Center(
        child: GridView.count(
          primary: false,
          childAspectRatio: size.width/size.height,
          //childAspectRatio: 1.0,
          padding: const EdgeInsets.all(100),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            SingleChildScrollView(
              child: Container( //dashboard
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: const Text("Dashboard",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("View milk to be picked up, and browse user suggested articles",
                        textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/dash');
                          print("Going to dashboard!");
                        },
                        child: Text("Go to Dashboard"),
                      ),
                    )
                  ],
                ),
                color: Colors.pink[100],
              ),
            ),
            SingleChildScrollView(
              child: Container( //Articles
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: const Text("Articles",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("View and edit articles for viewing on the mobile app",
                        textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/articles');
                        },
                        child: Text("Go to Articles"),
                      ),
                    )
                  ],
                ),
                color: Colors.pink[200],
              ),
            ),
            SingleChildScrollView(
              child: Container( //News and Events
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: const Text("News and Events",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("View and edit news items for viewing on the mobile app",
                        textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: RaisedButton(
                        onPressed: () {
                          print("Going to news!");
                          Navigator.pushNamed(context, '/newsAndEvents');
                        },
                        child: Text("Go to News and Events"),
                      ),
                    )
                  ],
                ),
                color: Colors.pink[100],
              ),
            ),
            SingleChildScrollView(
              child: Container( //Depots
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: const Text("Depots",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("View and edit depots for viewing on the mobile app",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/depots');
                          print("Going to depots!");
                        },
                        child: Text("Go to Depots"),
                      ),
                    )
                  ],
                ),
                color: Colors.pink[200],
              ),
            ),
            SingleChildScrollView(
              child: Container( //Account Management
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: const Text("Account Management",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Manage donor numbers, create staff accounts, and reset staff passwords here",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/accountManagement');
                          print("Going to account man!");
                        },
                        child: Text("Go to Account Management"),
                      ),
                    )
                  ],
                ),
                color: Colors.pink[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
  }