import 'package:flutter/material.dart';

class ShopkeeperPaymentInfo extends StatefulWidget {
  const ShopkeeperPaymentInfo({super.key});

  @override
  State<ShopkeeperPaymentInfo> createState() => _ShopkeeperPaymentInfoState();
}

class _ShopkeeperPaymentInfoState extends State<ShopkeeperPaymentInfo> {
  final GlobalKey _key = GlobalKey<FormState>();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _easypaisaOrJazzCashController = TextEditingController();
  final TextEditingController _accountTitleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopkeeper Payment Info"),
      ),
      body: Form(child: Column(
        children: [
          TextFormField(controller:_emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email address",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email address";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _accountTitleController,
            decoration: const InputDecoration(
              labelText: "Account Title",
              hintText: "Enter your account title",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your account title";
              }
              return null;
            },
          ),
          TextFormField(
            key:_key,
            controller: _cnicController,
            decoration: const InputDecoration(
              labelText: "CNIC",
              hintText: "Enter your CNIC number",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your CNIC number";
              }
              return null;
            },
          ),
           TextFormField(
            controller: _accountTitleController,
            decoration: const InputDecoration(
              labelText: "Account Title",
              hintText: "Enter your account title",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your account title";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _easypaisaOrJazzCashController,
            decoration: const InputDecoration(
              labelText: "Easypaisa or JazzCash",
              hintText: "Enter your Easypaisa or JazzCash number",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your Easypaisa or JazzCash number";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if ((_key.currentState as FormState).validate()) {
                // Perform the action to save the payment info
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment info saved")),
                );
              }
            },
            child: const Text("Next"),
          ),
        ],
      )
      )
    );
  }
}