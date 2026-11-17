import 'package:flutter/material.dart';

import 'main.dart'; // ValueNotifier access korar jonno dorkar



class TicketsPage extends StatefulWidget {

  const TicketsPage({super.key});



  @override

  State<TicketsPage> createState() => _TicketsPageState();

}



class _TicketsPageState extends State<TicketsPage> {

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();



  // Local list (Oi page-e thakar jonno)

  final List<Map<String, String>> paidList = [];



  void _addTicketEntry() {

    if (_nameController.text.isNotEmpty && _amountController.text.isNotEmpty) {

      setState(() {

        // 1. Local list update

        paidList.add({

          "name": _nameController.text,

          "amount": _amountController.text,

        });



        // 2. GLOBAL LIST UPDATE (Summary page-er jonno)

        allExpenses.value = [

          ...allExpenses.value,

          {

            "category": "Tickets", // ALL page-e heading hobe eita

            "title": _nameController.text,

            "amount": _amountController.text,

          }

        ];



        _nameController.clear();

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

        title: Text("Ticket Management",

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

                        color: Colors.teal.withOpacity(0.1),

                        shape: BoxShape.circle,

                      ),

                      child: const Icon(Icons.local_offer, color: Colors.tealAccent, size: 50),

                    ),

                  ),

                  const SizedBox(height: 30),



                  // Input Section

                  _buildLabel("Person Name"),

                  _buildTextField(_nameController, "Who paid?", Icons.person_outline, isDark),



                  const SizedBox(height: 20),



                  _buildLabel("Ticket Price"),

                  _buildTextField(_amountController, "0.00", Icons.confirmation_number_outlined, isDark, isNumber: true),



                  const SizedBox(height: 25),



                  // Add Button

                  SizedBox(

                    width: double.infinity,

                    height: 50,

                    child: OutlinedButton.icon(

                      onPressed: _addTicketEntry,

                      icon: const Icon(Icons.add, color: Colors.tealAccent),

                      label: const Text("ADD TO LIST", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),

                      style: OutlinedButton.styleFrom(

                        side: const BorderSide(color: Colors.tealAccent),

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                      ),

                    ),

                  ),



                  const SizedBox(height: 40),



                  // Paid List Section

                  const Text("Paid Members List", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),

                  const SizedBox(height: 15),



                  paidList.isEmpty

                      ? const Center(child: Text("No entries yet", style: TextStyle(color: Colors.white24)))

                      : ListView.builder(

                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: paidList.length,

                    itemBuilder: (context, index) {

                      return Container(

                        margin: const EdgeInsets.only(bottom: 10),

                        padding: const EdgeInsets.all(15),

                        decoration: BoxDecoration(

                          color: Colors.white.withOpacity(0.05),

                          borderRadius: BorderRadius.circular(15),

                          border: Border.all(color: Colors.white10),

                        ),

                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            Row(

                              children: [

                                const CircleAvatar(

                                  radius: 15,

                                  backgroundColor: Colors.tealAccent,

                                  child: Icon(Icons.check, size: 15, color: Colors.black),

                                ),

                                const SizedBox(width: 15),

                                Text(paidList[index]['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),

                              ],

                            ),

                            Text("₹${paidList[index]['amount']}", style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),

                          ],

                        ),

                      );

                    },

                  ),

                ],

              ),

            ),

          ),



          // Final Save Button

          Padding(

            padding: const EdgeInsets.all(20.0),

            child: SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed: () => Navigator.pop(context),

                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.tealAccent,

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

                ),

                child: const Text("SAVE ALL TICKETS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),

              ),

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildLabel(String text) {

    return Padding(

      padding: const EdgeInsets.only(left: 5, bottom: 8),

      child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey)),

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

          prefixIcon: Icon(icon, color: Colors.tealAccent, size: 22),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 15),

        ),

      ),

    );

  }

}