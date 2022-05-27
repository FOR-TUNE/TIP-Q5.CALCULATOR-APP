// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BillSplitter(),
  ));
}

class BillSplitter extends StatefulWidget {
  const BillSplitter({Key? key}) : super(key: key);

  @override
  _BillSplitterState createState() => _BillSplitterState();
}

class _BillSplitterState extends State<BillSplitter> {
  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(
          top:
              80.0), // Here we can use the "MediaQuery" function, see tutorial for sample.
      alignment: Alignment.center,
      color: Colors.white,
      child: ListView(
        // Here, it allows us to scroll up and down to see behind a keyboard pop up
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(20.5),
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.lightGreenAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text("Total Per Person",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Colors.green.shade900,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      "\$ ${calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                          color: Colors.green.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.blueGrey.shade100, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                // BILLAMOUNT ROW
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: Colors.green.shade900),
                  decoration: InputDecoration(
                    prefixText: "Bill Amount: ",
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  onChanged: (String value) {
                    try {
                      _billAmount = double.parse(value);
                    } catch (exception) {
                      _billAmount = 0.0;
                    }
                  },
                ),
                // SPLIT ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Split",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (_personCounter > 1) {
                                _personCounter--;
                              } else {
                                // do nothing
                              }
                            });
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Colors.lightGreenAccent.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Text(
                                "-",
                                style: TextStyle(
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "$_personCounter",
                          style: TextStyle(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _personCounter++;
                            });
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Colors.lightGreenAccent.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Text(
                                "+",
                                style: TextStyle(
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //TIP ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tip",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Text(
                          "\$ ${(calculateTotalTip(_billAmount, _personCounter, _tipPercentage)).toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          )),
                    ),
                  ],
                ),
                // Slider
                Column(
                  children: [
                    Text(
                      "$_tipPercentage%",
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                        min: 0,
                        max: 100,
                        activeColor: Colors.green.shade900,
                        inactiveColor: Colors.grey,
                        divisions: 20,
                        value: _tipPercentage.toDouble(),
                        onChanged: (double newvalue) {
                          setState(() {
                            _tipPercentage = newvalue.round();
                          });
                        })
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  calculateTotalPerPerson(double billAmount, int splitBy, int _tipPercentage) {
    var totalPerPerson =
        (calculateTotalTip(billAmount, splitBy, _tipPercentage) + billAmount) /
            splitBy;

    return totalPerPerson.toStringAsFixed(2);
  }

  calculateTotalTip(double billAmount, int splitBy, int tipPercentage) {
    double totalTip = 0.0;

    if (billAmount < 0.0 || billAmount.toString().isEmpty) {
      // no go
    } else {
      totalTip = (billAmount * tipPercentage) / 100;
    }

    return totalTip.toDouble();
  }
}
