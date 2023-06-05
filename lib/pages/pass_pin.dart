import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:super_project/services/storage_service.dart';

class PassPin extends StatefulWidget {
  const PassPin({Key? key}) : super(key: key);

  @override
  State<PassPin> createState() => _PassPinState();
}

class _PassPinState extends State<PassPin> {
  TextEditingController newTextEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  StorageService storageSer = StorageService();

  @override
  void dispose() {
    newTextEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  int mode = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passcode Login'),
      ),
      body: Container(
        margin:EdgeInsets.only(left:20,right:20),
        child:SingleChildScrollView(
          child:Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),

              SizedBox(
                height: 80.0,
              ),
              Text(
                'Enter Pin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: PinCodeFields(
                  controller: newTextEditingController,
                  length: 4,
                  // fieldBorderStyle: FieldBorderStyle.Square,
                  responsive: false,
                  fieldHeight:40.0,
                  fieldWidth: 40.0,
                  borderWidth:1.0,
                  activeBorderColor: Colors.pink,
                  activeBackgroundColor: Colors.pink.shade100,
                  // borderRadius: BorderRadius.circular(10.0),
                  keyboardType: TextInputType.number,
                  autoHideKeyboard: false,
                  fieldBackgroundColor: Colors.black12,
                  borderColor: Colors.black38,
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  onComplete: (output) {
                    // Your logic with pin code
                    if (mode == 1) {
                      storageSer.validatePin(output).then((resp) {
                        print('pin ver $resp');
                        if (resp == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                showCloseIcon: true,
                                content: Text("passcode verified"),
                                backgroundColor:  Colors.green,
                              )
                          );
                          Navigator.pushNamed(context, '/passManager');
                        } else if (resp == 2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                showCloseIcon: true,
                                content: Text("passcode mismatch"),
                                backgroundColor: Colors.red,
                              )
                          );
                          dispose();
                        } else {
                          print('show snack');
                          mode = 2;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                showCloseIcon: true,
                                content: Text("No password set. Create new"),
                                backgroundColor: Colors.red,
                              )
                          );

                        }
                      });
                    } else {
                      showDialog(context: context, builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("Confirm Password"),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  storageSer.createPassPin(output);
                                  Navigator.of(context).pop();
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
                            actionsPadding: EdgeInsets.only(right: 15, bottom: 10)
                        );
                      });
                    }

                  },
                ),
              ),
              SizedBox(
                height: 80.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
