import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:super_project/models/storage_item.dart';

class PassManager extends StatefulWidget {
  // const PassManager({Key? key}) : super(key: key);
  StorageService obj1 = StorageService();

  @override
  State<PassManager> createState() => _PassManagerState();
}

class _PassManagerState extends State<PassManager> {
  bool _passwordVisible = false;
  List<PassEntry> passes = [];
  //   PassEntry(
  //       id: 2,
  //       userName: "vijay",
  //       website: "youtube.com",
  //       password: "vijay@12888888888888883"),
  //   PassEntry(
  //       id: 3,
  //       userName: "Boruto4life",
  //       website: "git.ardhika.com",
  //       password: "1234567"),
  // ];
  StorageService storageSer = StorageService();
  // storageSer.readAllSecureData().then((resp) => print(resp));

  void getEntries() {
    storageSer.readAllPass().then((value) {
      List<PassEntry> resp = value.map((e) {
        print("gotcha, ${e.id}");
        return PassEntry(
            id: e.id,
            userName: e.username,
            website: e.website,
            password: e.password);
      }).toList();
      setState(() {
        passes = resp;
      });
    });
  }

  void deletePass(key) {
    // print('del is ${key.id} ${key.username}');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AlertDialog(
                title: Text("Delete this Password?"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      storageSer.deleteSecureData(key.id);
                      getEntries();
                      Navigator.of(context).pop();
                    },
                    child: Text("Yes"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  )
                ],
                actionsPadding: EdgeInsets.only(right: 15, bottom: 10)),
          );
        });
    // storageSer.deleteSecureData(p.userName);
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getEntries();
  }

  @override
  Widget build(BuildContext context) {
    void addPass(PassEntry p) {
      setState(() {
        passes.add(p);
      });
    }

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text('Password Manager'),
          centerTitle: true,
        ),
        body: Container(
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     ListPass(id: 2, userName: "vijay", website: "youtube.com", password: "vijay@123"),
            //     ListPass(id: 3, userName: "Boruto4life", website: "git.ardhika.com", password: "1234567"),
            //   ],
            // ),
            child: Column(
          children: [
            DataTable(
              clipBehavior: Clip.antiAlias,
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Website')),
                DataColumn(label: Text('Password'))
              ],
              rows: () {
                return passes
                    .map((p) => DataRow(cells: [
                          DataCell(Text(p.userName)),
                          DataCell(Text(p.website)),
                          DataCell(Row(
                            children: [
                              () {
                                if (p._passwordVisible) {
                                  return FittedBox(
                                      child: Text(
                                    p.password,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ));
                                } else {
                                  return Text("********");
                                }
                              }(),
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      p._passwordVisible = !p._passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    p._passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 18,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    deletePass(p);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 18,
                                  ))
                            ],
                          ))
                        ]))
                    .toList();
                //     [
                //   DataRow(cells: [
                //     DataCell(Text("Boruto4life")),
                //     DataCell(Text("git.ardhika.com")),
                //     DataCell(Row(
                //       children: [
                //         () {
                //           if (_passwordVisible) {
                //             return Text("31314141");
                //           } else {
                //             return Text("********");
                //           }
                //         }(),
                //         SizedBox(
                //           width: 5,
                //         ),
                //         IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 _passwordVisible = !_passwordVisible;
                //               });
                //             },
                //             icon: Icon(
                //               _passwordVisible
                //                   ? Icons.visibility_off
                //                   : Icons.visibility,
                //               size: 18,
                //             ))
                //       ],
                //     ))
                //   ])
                // ];
              }(),
            ),
            ElevatedButton(
                onPressed: () {
                  storageSer.deleteAllSecureData();
                },
                child: Text('Delete All'))
          ],
        )),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("open dialog");

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PassForm(
                        getEntries: getEntries, storageSer: storageSer);
                  });
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}

class ListPass extends StatefulWidget {
  // const ListPass({Key? key}) : super(key: key);

  int id;
  String userName;
  String website;
  String password;
  ListPass(
      {required this.id,
      required this.userName,
      required this.website,
      required this.password});

  @override
  State<ListPass> createState() => _ListPassState();
}

class _ListPassState extends State<ListPass> {
  // int id = (widget.id);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                ),
                Text(
                  widget.userName,
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Website',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                ),
                Text(
                  widget.website,
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                ),
                Text(
                  widget.password,
                  style: TextStyle(fontSize: 20),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PassEntry {
  String id;
  String userName;
  String website;
  String password;
  bool _passwordVisible = false;
  PassEntry(
      {required this.id,
      required this.userName,
      required this.website,
      required this.password});
}

class PassForm extends StatefulWidget {
  // const PassForm({Key? key}) : super(key: key);

  Function getEntries;
  StorageService storageSer;
  PassForm({required this.getEntries, required this.storageSer});
  @override
  State<PassForm> createState() => _PassFormState();
}

class _PassFormState extends State<PassForm> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String website = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 300,
          minHeight: 200,
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Title(
                    color: Colors.orangeAccent,
                    child: Text("Add Password",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: 'User Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          username = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.web_rounded),
                          labelText: 'Website',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'url required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          website = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.password),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'password required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close")),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );

                            StorageItem pay =
                                StorageItem(username, password, website);
                            widget.storageSer.writePass(pay);
                            widget.getEntries();
                            // widget.addPass(PassEntry(
                            //     id: 7,
                            //     userName: username,
                            //     website: website,
                            //     password: password));
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[500]),
                        child: Text("Add"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
