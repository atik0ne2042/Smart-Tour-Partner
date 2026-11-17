import 'package:flutter/material.dart';

class TransportPage extends StatefulWidget {
  @override
  _TransportPageState createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  final List<Map<String, String>> _transportSlips = [];
  final List<Map<String, String>> _notepadNotes = [];
  final TextEditingController _amountController = TextEditingController();
  String _selectedMode = 'Bus';

  // নোটপ্যাড ডায়ালগ ফাংশন
  void _openNotepad() {
    TextEditingController nameController = TextEditingController();
    TextEditingController payController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Team Member Note",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: "Member Name", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(
                controller: payController,
                decoration: const InputDecoration(
                    labelText: "Amount", border: OutlineInputBorder()),
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.indigo),
              onPressed: () {
                if (nameController.text.isNotEmpty && payController.text.isNotEmpty) {
                  setState(() {
                    _notepadNotes.add({
                      'name': nameController.text,
                      'amount': payController.text
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Note", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transport Management"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNotepad,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.note_add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ট্রান্সপোর্ট ইনপুট কার্ড
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChoiceChip(
                          label: const Text("Bus"),
                          selected: _selectedMode == 'Bus',
                          onSelected: (val) => setState(() => _selectedMode = 'Bus'),
                        ),
                        ChoiceChip(
                          label: const Text("Bike"),
                          selected: _selectedMode == 'Bike',
                          onSelected: (val) => setState(() => _selectedMode = 'Bike'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                          labelText: "Price", prefixIcon: Icon(Icons.attach_money)),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            minimumSize: const Size(double.infinity, 45)),
                        onPressed: () {
                          if (_amountController.text.isNotEmpty) {
                            setState(() {
                              _transportSlips.add({
                                'mode': _selectedMode,
                                'amount': _amountController.text
                              });
                              _amountController.clear();
                            });
                          }
                        },
                        child: const Text("Save Slip", style: TextStyle(color: Colors.white))
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // স্লিপ লিস্ট সেকশন
            if (_transportSlips.isNotEmpty) ...[
              const Text("Transport Slips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transportSlips.length,
                itemBuilder: (context, index) {
                  final slip = _transportSlips[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(slip['mode'] == 'Bus' ? Icons.directions_bus : Icons.directions_bike),
                      title: Text("Mode: ${slip['mode']}"),
                      trailing: Text("৳${slip['amount']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),

            // নোটপ্যাড নোটস সেকশন
            if (_notepadNotes.isNotEmpty) ...[
              const Text("Team Member Notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notepadNotes.length,
                itemBuilder: (context, index) {
                  final note = _notepadNotes[index];
                  return Card(
                    color: Colors.amber.shade50,
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.indigo),
                      title: Text(note['name'] ?? ''),
                      subtitle: const Text("Contribution Note"),
                      trailing: Text("৳${note['amount']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}