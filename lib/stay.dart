import 'package:flutter/material.dart';

import 'main.dart'; // ValueNotifier access korar jonno dorkar

class StayPage extends StatefulWidget {
  const StayPage({super.key});

  @override
  State<StayPage> createState() => _StayPageState();
}

class _StayPageState extends State<StayPage> {
  // Input Controllers
  final TextEditingController _hotelController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Local Stay Expense List
  final List<Map<String, dynamic>> stayExpenses = [];

  void _addStayExpense() {
    if (_hotelController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      setState(() {
        // 1. Local page list update
        stayExpenses.add({
          "hotel": _hotelController.text,
          "amount": _amountController.text,
        });

        // 2. GLOBAL LIST UPDATE (ALL page-er jonno)
        allExpenses.value = [
          ...allExpenses.value,
          {
            "category": "Stay", // ALL page-e heading hobe eita
            "title": _hotelController.text,
            "amount": _amountController.text,
          }
        ];

        // Input clear
        _hotelController.clear();
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
        title: Text("Stay Details",
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
                  // Icon Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.hotel, color: Colors.purpleAccent, size: 50),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildLabel("Hotel / Resort Name"),
                  _buildTextField(_hotelController, "e.g. Ocean Blue Resort / Hostel", Icons.bed_outlined, isDark),

                  const SizedBox(height: 20),

                  _buildLabel("Total Rent"),
                  _buildTextField(_amountController, "0.00", Icons.payments_outlined, isDark, isNumber: true),

                  const SizedBox(height: 30),

                  // Add Button - Local + Global update hobe
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _addStayExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("ADD TO LIST",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Stay History List Section
                  if (stayExpenses.isNotEmpty) ...[
                    const Text("Stay Entries",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 15),
                    _buildStayList(isDark),
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
  Widget _buildStayList(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stayExpenses.length,
      itemBuilder: (context, index) {
        final item = stayExpenses[index];
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
                    backgroundColor: Colors.purpleAccent,
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Text(item['hotel'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                ],
              ),
              Text("₹${item['amount']}",
                  style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 18)),
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
          prefixIcon: Icon(icon, color: Colors.purpleAccent, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}