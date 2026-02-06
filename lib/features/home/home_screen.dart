import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Daftar"),),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/invoicelist');
                },
                child: const Text("Invoices nav done"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inventorylist');
                },
                child: const Text("Inventory nav done"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/customerslist');
                },
                child: const Text("Customers nav done"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/reports');
                },
                child: const Text("Reports nav done"),
              ),
               const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/loginscreen');
                },
                child: const Text("Login nav done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
