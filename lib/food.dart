import 'package:flutter/material.dart';

import 'main.dart'; // ValueNotifier access korar jonno eita dorkar

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  // Input Controllers
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Local Food Expense List (Sudhu ei page-e thakbe)
  final List<Map<String, dynamic>> foodExpenses = [];

  void _addFoodExpense() {
    if (_itemController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      setState(() {
        // 1. Local page list update
        foodExpenses.add({
          "item": _itemController.text,
          "amount": _amountController.text,
        });

        // 2. GLOBAL LIST UPDATE (ALL page-er jonno)
        allExpenses.value = [
          ...allExpenses.value,
          {
            "category": "Food", // Heading name
            "title": _itemController.text,
            "amount": _amountController.text,
          }
        ];

        // Input clear korar jonne
        _itemController.clear();
        _amountController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Food Details",
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Header (Food Theme)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.restaurant, color: Colors.orangeAccent, size: 50),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildLabel("What did you eat?"),
                  _buildTextField(_itemController, "e.g. Burger / Dinner at Cafe", Icons.fastfood_outlined, isDark),

                  const SizedBox(height: 20),

                  _buildLabel("Bill Amount"),
                  _buildTextField(_amountController, "0.00", Icons.receipt_long_outlined, isDark, isNumber: true),

                  const SizedBox(height: 30),

                  // Add Button - Local + Global add hobe
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _addFoodExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("ADD TO LIST",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Food History List Section
                  if (foodExpenses.isNotEmpty) ...[
                    const Text("Food Entries",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 15),
                    _buildFoodList(isDark),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Niche joma houya list UI
  Widget _buildFoodList(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foodExpenses.length,
      itemBuilder: (context, index) {
        final item = foodExpenses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Text(item['item'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                ],
              ),
              Text("₹${item['amount']}",
                  style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, bool isDark, {bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
          prefixIcon: Icon(icon, color: Colors.orangeAccent, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}