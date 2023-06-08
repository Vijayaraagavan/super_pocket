import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Line Events"),
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: const TextStyle(
            letterSpacing: 2.0, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(child: EntryList()),
      ),
    );
  }
}

class Entry {
  int id;
  DateTime datetime;
  String recency;
  String dateStr;
  String message;
  int category_id;

  Entry(this.id, this.datetime, this.recency, this.dateStr, this.message,
      this.category_id);
}

class EntryCard extends StatefulWidget {
  Entry entry;
  // const EntryCard({Key? key, Entry entry}) : super(key: key);
  EntryCard(this.entry, {super.key});
  @override
  State<EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {
  // Entry entry;
  // @override
  // void initState() {
  //   entry = widget.entry;
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Card(
              color: Theme.of(context).primaryColorLight,
              // color: Colors.orange[100],
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12), // Set the desired border radius
                side: BorderSide(
                  color: Theme.of(context)
                      .primaryColorLight, // Set the desired border color
                  width: 1, // Set the desired border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text(
                            widget.entry.recency,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18),
                          ),
                          Spacer(),
                          Text(
                            widget.entry.dateStr,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Text(
                      widget.entry.message,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: LinePainterSide(),
            child: Container(height: 1), // Adjust the height of the line
          ),
        ],
      ),
    );
  }
}

class EntryList extends StatefulWidget {
  const EntryList({Key? key}) : super(key: key);
  @override
  State<EntryList> createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  List<Entry> entries = [
    gen(1, "I dropped boruto", 2),
    gen(2, "I dropped boruto", 2)
  ];
  final GlobalKey _listViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        CustomPaint(
          painter: LinePainter(_listViewKey),
          child: Container(height: 1), // Adjust the height of the line
        ),
        () {
          int itemCount = 3;
          if (itemCount > 5) {
            return Expanded(
              child: ListView.builder(
                key: _listViewKey,
                itemCount: itemCount,
                itemBuilder: (BuildContext context, int index) {
                  return EntryCard(entries[0]);
                },
                // children: entries.map((e) => EntryCard(e)).toList(),
                //     children: [
                //       CustomPaint(
                //         painter: LinePainter(),
                //         child: Container(height: 50.0), // Adjust the height of the line
                //       ),
                //       EntryCard(entries[0]),
                //       // CustomPaint(
                //       //   painter: LinePainter(),
                //       //   child: Container(height: 50.0), // Adjust the height of the line
                //       // ),
                //       EntryCard(entries[1]),
                //       // CustomPaint(
                //       //   painter: LinePainter(),
                //       //   child: Container(height: 50.0), // Adjust the height of the line
                //       // ),
                //       EntryCard(entries[1]),
                //       EntryCard(entries[1]),
                //       EntryCard(entries[1]),
                //       EntryCard(entries[1]),
                //       EntryCard(entries[1]),
                //       EntryCard(entries[1]),
                //       EntryCard(entries[1]),
                //
                //     ]
              ),
            );
          } else {
            return ListView.builder(
              key: _listViewKey,
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return EntryCard(entries[0]);
              },
              // children: entries.map((e) => EntryCard(e)).toList(),
              //     children: [
              //       CustomPaint(
              //         painter: LinePainter(),
              //         child: Container(height: 50.0), // Adjust the height of the line
              //       ),
              //       EntryCard(entries[0]),
              //       // CustomPaint(
              //       //   painter: LinePainter(),
              //       //   child: Container(height: 50.0), // Adjust the height of the line
              //       // ),
              //       EntryCard(entries[1]),
              //       // CustomPaint(
              //       //   painter: LinePainter(),
              //       //   child: Container(height: 50.0), // Adjust the height of the line
              //       // ),
              //       EntryCard(entries[1]),
              //       EntryCard(entries[1]),
              //       EntryCard(entries[1]),
              //       EntryCard(entries[1]),
              //       EntryCard(entries[1]),
              //       EntryCard(entries[1]),
              //       EntryCard(entries[1]),
              //
              //     ]
            );
          }
        }(),

// Text("checking"),
//             Text("checking 233"),
      ],
    ));
  }
}

class LinePainter extends CustomPainter {
  final GlobalKey listViewKey;

  LinePainter(this.listViewKey);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange // Adjust the color of the line
      ..strokeWidth = 2.0;

    final listViewBox =
        listViewKey.currentContext?.findRenderObject() as RenderBox?;
    final startPoint = Offset(size.width / size.width + 20, 45);

    print(listViewBox?.size.height);
    final endPoint = Offset(
        size.width / size.width + 20, listViewBox!.size.height - 53 ?? 0);
    // final endPoint = Offset(size.width / size.width + 20, 4 * 92);

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;
}

class LinePainterSide extends CustomPainter {
  LinePainterSide();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange // Adjust the color of the line
      ..strokeWidth = 2.0;

    final startPoint = Offset(20, -45);
    final endPoint = Offset(65, -45);
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(LinePainterSide oldDelegate) => false;
}

Entry gen(id, msg, cat_id) {
  DateTime datetime = DateTime.now();
  var recency = DateFormat.yMMMd().format(DateTime.now());
  return Entry(1, datetime, "Yesterday", recency, msg, cat_id);
}
