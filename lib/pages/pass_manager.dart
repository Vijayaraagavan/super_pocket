import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:super_project/models/storage_item.dart';

class Item {
  const Item(this.name, this.icon);

  final String name;

  final Icon icon;
}

class PassManager extends StatefulWidget {
  // const PassManager({Key? key}) : super(key: key);

  @override
  State<PassManager> createState() => _PassManagerState();
}

class _PassManagerState extends State<PassManager> {
  List<PassEntry> passes = [];
  StorageService storageSer = StorageService();
  String dropdownValue = 'Dog';
  List users = [
    const Item(
        'Android',
        Icon(
          Icons.android,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'Flutter',
        Icon(
          Icons.flag,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'ReactNative',
        Icon(
          Icons.format_indent_decrease,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'iOS',
        Icon(
          Icons.mobile_screen_share,
          color: const Color(0xFF167F67),
        )),
  ];

  void dropDownAction(value) {
    switch (value) {
      case '1':
        {
          storageSer.deleteAllPass();
          Navigator.of(context).pop();
        }
    }
  }

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

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text('Password Manager'),
          leading: IconButton(icon: Icon(Icons.keyboard_backspace), onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName("/"));
          },),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: '1',
                      child: Text('Delete All'),
                    ),
                  ];
                },
                onSelected: (String value) {
                  setState(() {
                    dropDownAction(value);
                    // dropdownValue = value;
                  });
                },
                child: Icon(Icons.more_vert),
              ),
            ),
          ],
          // centerTitle: true,
        ),
        body: Visibility(
          visible: passes.length > 0,
          replacement: const Center(
            child: Text(
              'No saved passwords',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: Colors.grey),
            ),
          ),
          child: Container(
              child: Column(
            children: [
              DataTable(
                clipBehavior: Clip.antiAlias,
                columns: const [
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                () {
                                  if (p._passwordVisible) {
                                    return Expanded(
                                        child: Text(
                                      p.password,
                                    ));
                                  } else {
                                    return Text("********");
                                  }
                                }(),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                IconButton(
                                    onPressed: () {
                                      if (p.password.length > 8) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return PassForm.updater(
                                                  getEntries, storageSer, p);
                                            });
                                      } else {
                                        setState(() {
                                          p._passwordVisible =
                                              !p._passwordVisible;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      p._passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 18,
                                    )),
                                SizedBox(width: 0,),
                                Container(
                                  width: 30,
                                  child: IconButton(
                                      onPressed: () {
                                        deletePass(p);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 18,
                                      )),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return PassForm.updater(
                                                getEntries, storageSer, p);
                                          });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                      size: 18,
                                    ))
                              ],
                            ))
                          ]))
                      .toList();
                }(),
              ),
            ],
          )),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PassForm.updater(
                        getEntries, storageSer, PassEntry.empty());
                  });
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}

// void showPassDialog(ListPass p) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return PassForm(
//             getEntries: getEntries, storageSer: storageSer);
//       });
// }

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

  // PassEntry.empty() {
  //   id = '';
  //   userName = '';
  //   website = '';
  //   password = '';
  // }

  PassEntry.empty(
      {Key? key,
      this.id = '',
      this.userName = '',
      this.website = '',
      this.password = ''});
}

class PassForm extends StatefulWidget {
  // const PassForm({Key? key}) : super(key: key);

  Function getEntries;
  StorageService storageSer;
  PassEntry p = PassEntry.empty();
  PassForm({required this.getEntries, required this.storageSer});

  PassForm.updater(this.getEntries, this.storageSer, this.p);
  @override
  State<PassForm> createState() => _PassFormState();
}

class _PassFormState extends State<PassForm> {
  final _formKey = GlobalKey<FormState>();
  String username = 'djj';
  String website = '';
  String password = '';
  String buttonTxt = 'Add';
  TextEditingController _controllerUser = TextEditingController();
  TextEditingController _controllerPass = TextEditingController();
  TextEditingController _controllerWeb = TextEditingController();

  void initState() {
    super.initState();
    _controllerUser = TextEditingController(text: widget.p.userName);
    _controllerPass = TextEditingController(text: widget.p.password);
    _controllerWeb = TextEditingController(text: widget.p.website);
    if (widget.p.userName.length > 0) {
      buttonTxt = 'Update';
    }
  }

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
                    child: Text("$buttonTxt Password",
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
                        controller: _controllerUser,
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
                          widget.p.userName = value;
                        },
                      ),
                      TextFormField(
                        controller: _controllerWeb,
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
                          widget.p.website = value;
                        },
                      ),
                      TextFormField(
                        controller: _controllerPass,
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
                          widget.p.password = value;
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

                            StorageItem pay = StorageItem.update(
                                widget.p.id,
                                widget.p.userName,
                                widget.p.password,
                                widget.p.website);
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
                        child: Text(buttonTxt))
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
