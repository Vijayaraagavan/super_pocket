import 'package:flutter/material.dart';

// class Screen extends StatelessWidget {
//   String name;
//   String route;
//
//   Screen({required this.name, required this.route});
// }
class Screen extends StatelessWidget {
  String name;
  String route;
  Color color;
  Icon icon;

  Screen(
      {required this.name,
      required this.route,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 10),
              icon
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Assets'),
        centerTitle: true,
      ),
      body: Container(
        child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            // Generate 100 widgets that display their index in the List.
            children: [
              Screen(
                  name: 'Password Manager',
                  route: '/passPin',
                  color: Colors.red.shade300,
                  icon: Icon(Icons.key, color: Colors.white, size: 28)),
              Screen(
                  name: 'Transaction',
                  route: '/transaction',
                  color: Colors.green.shade300,
                  icon: Icon(Icons.account_balance,
                      color: Colors.white, size: 28)),
              Screen(
                  name: 'Timeline',
                  route: '/timeline',
                  color: Colors.blue.shade300,
                  icon: Icon(Icons.timeline, color: Colors.white, size: 28)),
              Screen(
                  name: 'Scheduler',
                  route: '/scheduler',
                  color: Colors.orangeAccent,
                  icon: Icon(Icons.schedule, color: Colors.white, size: 28))
            ]),
      ),
    );
  }
}
