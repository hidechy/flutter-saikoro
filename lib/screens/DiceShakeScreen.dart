import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'dart:convert';

class DiceShakeScreen extends StatefulWidget {
  @override
  _DiceShakeScreenState createState() => _DiceShakeScreenState();
}

class _DiceShakeScreenState extends State<DiceShakeScreen> {
  String _diceKind = 'kind_10';
  String _diceNum = 'num_10';

  String _diceAnswer = "-";

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Shake the Dice'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _goDiceShakeScreen(),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.black.withOpacity(0.3),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('サイコロの種類'),
                    Row(
                      children: <Widget>[
                        _getChoiceChip(selectedChip: 'kind_6'),
                        _getChoiceChip(selectedChip: 'kind_10')
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.indigo),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('サイコロの数'),
                    Row(
                      children: <Widget>[
                        _getChoiceChip2(selectedChip: 'num_1'),
                        _getChoiceChip2(selectedChip: 'num_10')
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.indigo),
                Container(
                  height: 150,
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  child: (_diceAnswer != "")
                      ? Text(
                          '${_diceAnswer}',
                          style: TextStyle(
                              color: Colors.yellowAccent, fontSize: 80),
                        )
                      : null,
                ),
                RaisedButton(
                  child: Text('Shake the Dice'),
                  onPressed: () => _getDiceValue(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /**
   *
   */
  Widget _getChoiceChip({String selectedChip}) {
    var dispText = (selectedChip).replaceAll('kind_', '');

    return Container(
      margin: EdgeInsets.all(5),
      child: ChoiceChip(
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        selectedColor: Colors.blueAccent,
        label: Text(
          '${dispText}',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        selected: _diceKind == selectedChip,
        onSelected: (newValue) {
          setState(() {
            _diceKind = selectedChip;
          });
        },
      ),
    );
  }

  /**
   *
   */
  Widget _getChoiceChip2({String selectedChip}) {
    var dispText = (selectedChip).replaceAll('num_', '');

    return Container(
      margin: EdgeInsets.all(5),
      child: ChoiceChip(
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        selectedColor: Colors.blueAccent,
        label: Text(
          '${dispText}',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        selected: _diceNum == selectedChip,
        onSelected: (newValue) {
          setState(() {
            _diceNum = selectedChip;
          });
        },
      ),
    );
  }

  void _getDiceValue() async {
    String url = "http://toyohide.work/BrainLog/api/dice";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"diceKind": _diceKind, "diceNum": _diceNum});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      _diceAnswer = data['data']['sum'].toString();
    }

    setState(() {});
  }

  /**
   *
   */
  void _goDiceShakeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiceShakeScreen(),
      ),
    );
  }
}
