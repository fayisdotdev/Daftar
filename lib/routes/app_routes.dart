import 'package:daftar/features/reports/screens/reports_screen.dart';
import 'package:flutter/material.dart';

import 'package:daftar/features/home/home_screen.dart';
import 'package:daftar/features/inventory/screens/inventory_list_screen.dart';
import 'package:daftar/features/customers/screens/customers_list_screen.dart';
import 'package:daftar/features/invoice/screens/invoice_list_screen.dart';


class AppRoutes {
  static const String home = '/';
  static const String inventory = '/inventorylist';
  static const String invoice = '/invoicelist';
  static const String customers = '/customerslist';
  static const String reports = '/reports';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    inventory: (context) => const InventoryListScreen(),
    // Add other routes once screens are created
    invoice: (context) => const InvoiceListScreen(),
    customers: (context) => const CustomersListScreen(),
    reports: (context) => const ReportsScreen(),
  };
}