import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;

// first we need to set string for our public keys
String backendUrl = "https://example-app-flutter.herokuapp.com/";
String publicKey = "pk_test_cf43535ec686c3d97c21d65f1032484846d88c08";

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // its important to initialize the publickey right from the widget build
  @override
  void initState() {
    super.initState();
    PaystackPlugin.initialize(publicKey: publicKey);
  }

// checkout method that is card or bank
  CheckoutMethod _method;
  // loading indicator
  bool _inProgress = false;
  // card number and cvv
  String _cardNumber, _cvv;
  int _expiryMonth = 0, _expiryYear = 0, _radioValue = 0;
  // this is the dropdown items for our checkout methods
  var banks = ['Selectable', 'Bank', 'Card'];
  bool get _isLocal => _radioValue == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Check Out'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 10),
          Text('Initalize transaction from',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              )),
          Row(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: RadioListTile<int>(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChanged,
                  title: Text('Local'),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: RadioListTile<int>(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChanged,
                  title: Text('Server'),
                ),
              ),
            ],
          ),
          Divider(thickness: 1.5),
          SizedBox(height: 20),
          Text(
            'Choose a checkout method: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          // creating a loading indicator to show when the checkout starts
          // we need a dropdown to select between bank and card

          _inProgress
              ? Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: DropdownButtonHideUnderline(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Select checkout',
                              hintStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            isEmpty: _method == null,
                            child: DropdownButton<CheckoutMethod>(
                              value: _method,
                              isDense: true,
                              onChanged: (CheckoutMethod value) {
                                setState(() {
                                  _method = value;
                                });
                              },
                              items: banks.map((String value) {
                                return DropdownMenuItem<CheckoutMethod>(
                                  value: _selectMethod(value),
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () => _handleCheckout(context),
                            textColor: Colors.white,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                            child: Text(
                              'Checkout'.toUpperCase(),
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ]),
      ),
    );
  }

  showSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('$msg'),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.blue,
        onPressed: () {
          _scaffoldKey.currentState.removeCurrentSnackBar();
        },
      ),
    ));
  }

  void _handleRadioValueChanged(int value) {
    setState(() {
      return _radioValue = value;
    });
  }

  _handleCheckout(BuildContext context) async {
    if (_method == null) {
      showSnackBar('Select checkout method first');

      return;
    }

    if (_method != CheckoutMethod.card && _isLocal) {
      showSnackBar('Select server initialization method at the top');

      return;
    }
    setState(() => _inProgress = true);

    Charge charge = Charge()
      ..amount = 2000 * 100 // In base currency
      ..email = 'samuelbeebest@gmail.com'
      ..card = _getCardFromUI();

    if (!_isLocal) {
      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      charge.accessCode = accessCode;
    } else {
      charge.reference = _getReference();
    }

    try {
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        logo: MyLogo(),
      );
      print('Response = ${response.status}');
      showSnackBar('Response = ${response.status}');
      if (response.message == 'Success' || response.status == true) {
        setState(() => _inProgress = false);
        showSnackBar('Payment successful!');
      } else if (response.message == 'Transaction terminated') {
        setState(() => _inProgress = false);
        showSnackBar('Transaction terminated!');
      } else {
        setState(() => _inProgress = false);
        showSnackBar('Transaction not completed!');
      }
    } catch (e) {
      setState(() => _inProgress = false);
      showSnackBar("Error occured, Try again.");

      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  Future<String> _fetchAccessCodeFrmServer(String reference) async {
    String url = '$backendUrl/new-access-code';
    String accessCode;
    try {
      print("Access code url = $url");
      http.Response response = await http.get(url);
      accessCode = response.body;
      print('Response for access code = $accessCode');
    } catch (e) {
      setState(() => _inProgress = false);
      print('$reference'
          'There was a problem getting a access code form the backend: $e');
    }

    return accessCode;
  }
}

CheckoutMethod _selectMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
}

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://res.cloudinary.com/acctgen1/image/upload/v1612393902/TECH2-01_vw1fvg.png')),
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
    );
  }
}
