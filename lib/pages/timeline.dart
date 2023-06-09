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
  bool lastChild = false;

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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1, // number of children,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            CustomPaint(
              foregroundPainter: widget.entry.lastChild ? LinePainterDown(): LinePainterSide(),
              child: Container(
                height: 120,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  heightFactor: 1,
                  child: Card(
                    color: Theme.of(context).primaryColorLight,
                    // color: Colors.orange[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Set the desired border radius
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ), // Adjust the height of the line
            ),
            // CustomPaint(
            //   painter: LinePainterDown(),
            //   child: Container(height: 0), // Adjust the height of the line
            // ),
            SizedBox(height: 10)
          ],
        ); // Your child widget here;
      },
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
    gen(1, "I dropped boruto you shit head brign", 2),
    gen(
        2,
        "I dropped boruto you shit head brign it on i madara declare you the tronger in taijustu",
        2),
    genLast(3, "I dropped boruto you shit head brign", 3),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView(
            shrinkWrap: true,
            // children: entries.map((e) => EntryCard(e)).toList(),
            children: [
              SizedBox(height: 20),
              EntryCard(entries[0]),
              // CustomPaint(
              //   painter: LinePainter(),
              //   child: Container(height: 50.0), // Adjust the height of the line
              // ),
              EntryCard(entries[1]),
              // EntryCard(entries[1]),
              EntryCard(entries[1]),
              EntryCard(entries[1]),
              EntryCard(entries[1]),
              EntryCard(entries[2]),
              // EntryCard(entries[1]),
              // EntryCard(entries[1]),
              // EntryCard(entries[1]),
              // EntryCard(entries[1]),
            ]),
      ),
    );
  }
}

class LinePainterSide extends CustomPainter {
  LinePainterSide();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange // Adjust the color of the line
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(4, size.height / 2);
    path.lineTo(-40, size.height / 2);
    path.lineTo(-40, size.height * 1.59);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LinePainterSide oldDelegate) => false;
}

class LinePainterDown extends CustomPainter {
  LinePainterDown();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange // Adjust the color of the line
      ..strokeWidth = 2.0;

    final startPoint = Offset(4, size.height / 2);
    final endPoint = Offset(-40, size.height / 2);
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(LinePainterDown oldDelegate) => false;
}

Entry gen(id, msg, cat_id) {
  DateTime datetime = DateTime.now();
  var recency = DateFormat.yMMMd().format(DateTime.now());
  return Entry(1, datetime, "Yesterday", recency, msg, cat_id);
}

Entry genLast(id, msg, cat_id) {
  DateTime datetime = DateTime.now();
  var recency = DateFormat.yMMMd().format(DateTime.now());
  Entry last = Entry(1, datetime, "Yesterday", recency, msg, cat_id);
  last.lastChild = true;
  return last;
}