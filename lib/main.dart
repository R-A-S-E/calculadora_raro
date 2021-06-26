import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final options = [
    "AC",
    "%",
    "*",
    "/",
    "7",
    "8",
    "9",
    "-",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "=",
    "0",
    "."
  ];

  static const operation = const ['%', '/', '*', '-', '+', '='];
  var _result = "0";
  final _valor = [0.0, 0.0];
  int _valorindex = 0;
  var _currentOp;
  bool _apagao = false;
  String? _lastOptions;
  String opt = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 24, bottom: 50, left: 24),
                        child: Container(
                          child: Text(
                            _currentOp == null ? '' : '$_currentOp',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 24, bottom: 36, left: 80),
                        child: Text(
                          _result,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: StaggeredGridView.countBuilder(
                  padding: EdgeInsets.zero,
                  crossAxisCount: 4,
                  itemCount: 18,
                  itemBuilder: (BuildContext context, int index) => Material(
                    color: index == 15 ? Color(0xFFF57C00) : Color(0xFF212121),
                    child: InkWell(
                        onTap: () {
                          setState(() {});
                          opt = options.elementAt(index);
                          if (_modificouOperation(opt)) {
                            _currentOp = opt;
                            return;
                          }
                          if (opt == 'AC') {
                            _allClear();
                          } else if (operation.contains(opt)) {
                            _setOperation(opt);
                          } else {
                            _addDigito(opt);
                          }
                          _lastOptions = opt;
                        },
                        child: Center(
                          child: Text(
                            options[index],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                        )),
                  ),
                  staggeredTileBuilder: (int index) {
                    if (index == 15) {
                      return StaggeredTile.count(1, 2);
                    } else if (index == 16) {
                      return StaggeredTile.count(2, 1);
                    } else {
                      return StaggeredTile.count(1, 1);
                    }
                  },
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                )),
          ],
        ),
      ),
    );
  }

  _modificouOperation(String opc) {
    return operation.contains(_lastOptions) &&
        operation.contains(opt) &&
        _lastOptions != '=' &&
        opt != '=';
  }

  _setOperation(String newOperation) {
    bool igualaigual = newOperation == '=';
    if (_valorindex == 0) {
      if (!igualaigual) {
        _currentOp = newOperation;
        _valorindex = 1;
        _apagao = true;
      }
    } else {
      _valor[0] = _calculate();
      _valor[1] = 0.0;
      _result = _valor[0].toString();
      _result = _result.endsWith('.0') ? _result.split('.')[0] : _result;

      _currentOp = igualaigual ? null : newOperation;
      _valorindex = igualaigual ? 0 : 1;
      _apagao = !igualaigual;
    }
  }

  _addDigito(String digit) {
    final isDot = digit == '.';
    final wipeValue = (_result == '0' && !isDot) || _apagao;
    if (isDot && _result.contains('.') && !wipeValue) {
      return;
    }
    final emptyValue = isDot ? '0' : '';
    final currentValor = wipeValue ? emptyValue : _result;
    _result = currentValor + digit;
    _apagao = false;

    _valor[_valorindex] = double.tryParse(_result) ?? 0;
  }

  _allClear() {
    _result = '0';
    _valor.setAll(0, [0.0, 0.0]);
    _valorindex = 0;
    _currentOp = null;
    _apagao = false;
  }

  _calculate() {
    switch (_currentOp) {
      case '%':
        return _valor[0] % _valor[1];
      case '/':
        return _valor[0] / _valor[1];
      case '*':
        return _valor[0] * _valor[1];
      case '-':
        return _valor[0] - _valor[1];
      case '+':
        return _valor[0] + _valor[1];
      default:
        return _valor[0];
    }
  }
}
