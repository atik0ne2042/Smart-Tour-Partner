import 'package:flutter/material.dart';

class AllDataPage extends StatelessWidget {
  // স্যাম্পল ডাটা
  final List<Map<String, dynamic>> allRecords = [
    {'title': 'Bike Transport', 'amount': '150', 'date': '24 May 2024', 'type': 'transport'},
    {'title': 'Atik Hasan', 'amount': '500', 'date': '24 May 2024', 'type': 'notepad'},
    {'title': 'Bus Transport', 'amount': '40', 'date': '23 May 2024', 'type': 'transport'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F5),
      appBar: AppBar(
        title: Text("All Records", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: allRecords.length,
        itemBuilder: (context, index) {
          final data = allRecords[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16), // প্রতিটি আলাদা বক্স
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), // আধুনিক বক্স শেপ
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(data['date'], style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: data['type'] == 'transport' ? Colors.blue.shade50 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        data['type'].toString().toUpperCase(),
                        style: TextStyle(fontSize: 10, color: data['type'] == 'transport' ? Colors.blue : Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  "৳${data['amount']}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.indigo),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}