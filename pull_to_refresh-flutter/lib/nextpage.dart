import 'package:flutter/material.dart';
import 'package:paystack_manager/models/transaction.dart';
import 'package:paystack_manager/paystack_pay_manager.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paystack Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //initiate payment button
            RaisedButton(
              onPressed: _processPayment,
              child: Text(
                "Pay",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() {
    try {
      PaystackPayManager(context: context)
        // Don't store your secret key on users device.
        // Make sure this is retrive from your server at run time
        ..setSecretKey("sk_test_d33410b6eef5834ffbbfe2001100cb3465d04b65")
        //accepts widget
        ..setCompanyAssetImage(
          Image(
            width: 210,
            height: 210,
            fit: BoxFit.cover,
            image: NetworkImage(
                "https://res.cloudinary.com/acctgen1/image/upload/v1612393902/TECH2-01_vw1fvg.png"),
          ),
        )
        ..setAmount(105000)
        // ..setReference("your-unique-transaction-reference")
        ..setReference(DateTime.now().millisecondsSinceEpoch.toString())
        ..setCurrency("NGN")
        ..setEmail("samuelbeebst@gmail.com")
        ..setFirstName("Samuel")
        ..setLastName("Adekunle")
        ..setMetadata(
          {
            "custom_fields": [
              {
                "value": "TechWithSam",
                "display_name": "Payment to",
                "variable_name": "payment_to"
              }
            ]
          },
        )
        ..onSuccesful(_onPaymentSuccessful)
        ..onPending(_onPaymentPending)
        ..onFailed(_onPaymentFailed)
        ..onCancel(_onPaymentCancelled)
        ..initialize();
    } catch (error) {
      print("Payment Error ==> $error");
    }
  }

  void _onPaymentSuccessful(Transaction transaction) {
    print("Transaction was successful");
    print("Transaction Message ===> ${transaction.message}");
    print("Transaction Refrence ===> ${transaction.refrenceNumber}");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Message: ${transaction.message}\nReference:${transaction.refrenceNumber}'),
      backgroundColor: Colors.black,
    ));
  }

  void _onPaymentPending(Transaction transaction) {
    print("Transaction is pendinng");
    print("Transaction Refrence ===> ${transaction.refrenceNumber}");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${transaction.refrenceNumber}'),
      backgroundColor: Colors.black,
    ));
  }

  void _onPaymentFailed(Transaction transaction) {
    print("Transaction failed");
    print("Transaction Message ===> ${transaction.message}");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${transaction.message}'),
      backgroundColor: Colors.black,
    ));
  }

  void _onPaymentCancelled(Transaction transaction) {
    print("Transaction was cancelled");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Transaction was cancelled'),
      backgroundColor: Colors.black,
    ));
  }
}
