import 'package:flutter/material.dart';

// --- GLOBAL NOTIFIERS ---
ValueNotifier<List<Map<String, dynamic>>> allExpenses = ValueNotifier([]);
ValueNotifier<List<Map<String, String>>> allNotes = ValueNotifier([]);
ValueNotifier<String> tripName = ValueNotifier("Cox's Bazar Trip 2026");
ValueNotifier<Map<String, String>> userData = ValueNotifier({
  "name": "Atik Hasan",
  "email": "atik.dev@example.com",
  "bio": "Software Engineer | Flutter Developer",
  "image": "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
});
ValueNotifier<ThemeMode> appTheme = ValueNotifier(ThemeMode.dark);
ValueNotifier<String> appLanguage = ValueNotifier("English");
ValueNotifier<String> selectedCurrency = ValueNotifier("৳");
ValueNotifier<bool> isAppLocked = ValueNotifier(false);

void main() {
  runApp(const ExpenseHomePage());
}

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});
  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appTheme,
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: theme,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF5F7FA),
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.black), backgroundColor: Colors.transparent, elevation: 0),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF050A18),
            cardColor: const Color(0xFF1A1F3D),
            appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white), backgroundColor: Colors.transparent, elevation: 0),
          ),
          home: Scaffold(
            body: _getBody(),
            bottomNavigationBar: _buildBottomNav(),
          ),
        );
      },
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0: return const HomeDashboard();
      case 1: return const ProfilePage();
      case 2: return const SettingsPage();
      default: return const HomeDashboard();
    }
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      backgroundColor: Theme.of(context).cardColor,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
        BottomNavigationBarItem(icon: Icon(Icons.settings_suggest_rounded), label: "SETTINGS"),
      ],
    );
  }
}

// ---------------- 1. DASHBOARD ----------------
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  void _renameTrip(BuildContext context) {
    final controller = TextEditingController(text: tripName.value);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rename Trip"),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () { tripName.value = controller.text; Navigator.pop(context); }, child: const Text("Update")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: allExpenses,
        builder: (context, List<Map<String, dynamic>> expenses, child) {
          double total = 0, food = 0, trans = 0, stay = 0, tickets = 0;
          for (var item in expenses) {
            double amt = double.tryParse(item['amount'].toString()) ?? 0;
            total += amt;
            if (item['category'] == "Transport") trans += amt;
            if (item['category'] == "Food") food += amt;
            if (item['category'] == "Stay") stay += amt;
            if (item['category'] == "Tickets") tickets += amt;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Let's Go", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDark?Colors.white:Colors.black)),
                  GestureDetector(
                    onTap: () => _renameTrip(context),
                    child: ValueListenableBuilder(
                      valueListenable: tripName,
                      builder: (context, name, _) => Row(children: [
                        Text(name, style: const TextStyle(color: Colors.blueAccent, fontSize: 14)),
                        const Icon(Icons.edit, size: 12, color: Colors.blueAccent),
                      ]),
                    ),
                  ),
                ]),
                const Icon(Icons.notifications_none, size: 28),
              ]),
              const SizedBox(height: 30),
              _buildSummaryCard(context, total, food, trans, stay, tickets),
              const SizedBox(height: 30),
              const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildGrid(context),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, double t, double f, double tr, double s, double tk) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(30)),
      child: Row(children: [
        Expanded(flex: 4, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Total Spent", style: TextStyle(color: Colors.grey, fontSize: 13)),
          ValueListenableBuilder(
            valueListenable: selectedCurrency,
            builder: (context, curr, _) => FittedBox(child: Text("$curr${t.toStringAsFixed(0)}", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blueAccent))),
          ),
        ])),
        Container(width: 1, height: 100, color: Colors.white10, margin: const EdgeInsets.symmetric(horizontal: 10)),
        Expanded(flex: 5, child: Column(children: [
          _miniRow("Food", f, Colors.orange),
          _miniRow("Trans", tr, Colors.blue),
          _miniRow("Stay", s, Colors.purpleAccent),
          _miniRow("Ticket", tk, Colors.tealAccent),
        ])),
      ]),
    );
  }

  Widget _miniRow(String l, double a, Color c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      Text("${selectedCurrency.value}${a.toStringAsFixed(0)}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: c)),
    ]),
  );

  Widget _buildGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15,
      children: [
        _catItem(context, "TRANSPORT", Icons.directions_bus, Colors.blue, const TransportPage()),
        _catItem(context, "FOOD", Icons.restaurant, Colors.orange, const FoodPage()),
        _catItem(context, "STAY", Icons.hotel, Colors.purple, const StayPage()),
        _catItem(context, "TICKETS", Icons.local_offer, Colors.tealAccent, const TicketsPage()),
        _catItem(context, "OTHER", Icons.edit_note, Colors.pinkAccent, const NotesPage()),
        _catItem(context, "ALL", Icons.layers, Colors.redAccent, const AllExpensesPage()),
      ],
    );
  }

  Widget _catItem(BuildContext context, String t, IconData i, Color c, Widget? p) => GestureDetector(
    onTap: () => p != null ? Navigator.push(context, MaterialPageRoute(builder: (context) => p)) : null,
    child: Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(i, color: c, size: 30),
        const SizedBox(height: 8),
        Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ]),
    ),
  );
}

// ---------------- 2. SETTINGS PAGE ----------------
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("App Settings")),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        ValueListenableBuilder(valueListenable: userData, builder: (context, data, _) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundImage: NetworkImage(data['image']!)),
            title: Text(data['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Syncing via Cloud Account", style: TextStyle(color: Colors.green, fontSize: 11)),
            trailing: const Icon(Icons.cloud_done, color: Colors.blueAccent),
          ),
        )),
        const SizedBox(height: 25),
        const Text("PREFERENCES", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
        SwitchListTile(secondary: const Icon(Icons.dark_mode), title: const Text("Dark Theme"), value: isDark, onChanged: (v) => appTheme.value = v ? ThemeMode.dark : ThemeMode.light),

        ListTile(
          leading: const Icon(Icons.translate),
          title: const Text("App Language"),
          subtitle: ValueListenableBuilder(valueListenable: appLanguage, builder: (context, l, _) => Text(l)),
          onTap: () => _showLangDialog(context),
        ),

        ListTile(
          leading: const Icon(Icons.currency_exchange),
          title: const Text("Currency Unit"),
          subtitle: ValueListenableBuilder(valueListenable: selectedCurrency, builder: (context, c, _) => Text(c)),
          onTap: () => _showCurrencyDialog(context),
        ),

        const SizedBox(height: 20),
        const Text("SECURITY & BACKUP", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
        ValueListenableBuilder(
          valueListenable: isAppLocked,
          builder: (context, locked, _) => SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text("Fingerprint App Lock"),
            value: locked,
            onChanged: (v) => isAppLocked.value = v,
          ),
        ),
        ListTile(leading: const Icon(Icons.file_download_outlined), title: const Text("Export Trip as CSV"), onTap: (){}),

        const Divider(height: 40),
        ListTile(
          leading: const Icon(Icons.info_outline_rounded),
          title: const Text("About Professional Manager"),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())),
        ),
      ]),
    );
  }

  void _showLangDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => SimpleDialog(title: const Text("Language Setup"), children: [
      SimpleDialogOption(onPressed: (){ appLanguage.value = "English"; selectedCurrency.value = "\$"; Navigator.pop(context); }, child: const Text("English (US)")),
      SimpleDialogOption(onPressed: (){ appLanguage.value = "Bengali (বাংলা)"; selectedCurrency.value = "৳"; Navigator.pop(context); }, child: const Text("Bengali (বাংলা)")),
    ]));
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => SimpleDialog(title: const Text("Select Currency"), children: [
      SimpleDialogOption(onPressed: (){ selectedCurrency.value = "৳"; Navigator.pop(context); }, child: const Text("BDT - ৳")),
      SimpleDialogOption(onPressed: (){ selectedCurrency.value = "\$"; Navigator.pop(context); }, child: const Text("USD - \$")),
    ]));
  }
}

// ---------------- 3. ABOUT PAGE ----------------
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About"), leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(children: [
          const Icon(Icons.auto_awesome_rounded, size: 70, color: Colors.blueAccent),
          const SizedBox(height: 20),
          const Text("Tour Manager Pro", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Version 2.5.0 (Stable Build)", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 30),
          const Text(
            "Designed for high-performance trip management and automated expense tracking. "
                "Built with Flutter SDK and Dart, featuring real-time state management and advanced biometric security.",
            textAlign: TextAlign.center, style: TextStyle(height: 1.6, fontSize: 14),
          ),
          const SizedBox(height: 40),
          const Divider(),
          const Text("LEAD ARCHITECT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          const Text("Atik Hasan", style: TextStyle(color: Colors.blueAccent, fontSize: 30, fontWeight: FontWeight.bold)),
          const Text("Software Engineer", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          const Text("Northern University Bangladesh", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 60),
          const Text("© 2026 Atik Dev Labs. All Rights Reserved.", style: TextStyle(fontSize: 10, color: Colors.grey)),
          const Text("Made with ❤️ in Bangladesh", style: TextStyle(fontSize: 10, color: Colors.blueAccent)),
        ]),
      ),
    );
  }
}

// ---------------- 4. PROFILE PAGE ----------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final nameC = TextEditingController(text: userData.value['name']);
    final emailC = TextEditingController(text: userData.value['email']);
    final bioC = TextEditingController(text: userData.value['bio']);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(children: [
          CircleAvatar(radius: 55, backgroundImage: NetworkImage(userData.value['image']!)),
          const SizedBox(height: 30),
          TextField(controller: nameC, decoration: InputDecoration(labelText: "Full Name", filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
          const SizedBox(height: 15),
          TextField(controller: emailC, decoration: InputDecoration(labelText: "Email Address", filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
          const SizedBox(height: 15),
          TextField(controller: bioC, maxLines: 2, decoration: InputDecoration(labelText: "Bio/Role", filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () {
            userData.value = {...userData.value, "name": nameC.text, "email": emailC.text, "bio": bioC.text};
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Synced Globally!")));
          }, child: const Text("SAVE & SYNC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        ]),
      ),
    );
  }
}

// ---------------- REUSABLE EXPENSE PAGE WITH DELETE ----------------
Widget _expensePage(BuildContext context, String cat, String typeLabel) {
  final nameC = TextEditingController();
  final amtC = TextEditingController();

  void deleteExpense(Map<String, dynamic> item) {
    List<Map<String, dynamic>> currentList = List.from(allExpenses.value);
    currentList.remove(item);
    allExpenses.value = currentList;
  }

  return Scaffold(
    appBar: AppBar(
      title: Text("$cat Expenses"),
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
    ),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(20), child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          TextField(controller: nameC, decoration: InputDecoration(labelText: typeLabel, border: InputBorder.none)),
          const Divider(),
          TextField(controller: amtC, decoration: const InputDecoration(labelText: "Amount", border: InputBorder.none), keyboardType: TextInputType.number),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                if(nameC.text.isNotEmpty && amtC.text.isNotEmpty) {
                  allExpenses.value = [...allExpenses.value, {
                    "id": DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID for safety
                    "category": cat,
                    "title": nameC.text,
                    "amount": amtC.text
                  }];
                  nameC.clear(); amtC.clear();
                }
              }, child: const Text("ADD EXPENSE", style: TextStyle(color: Colors.white)))),
        ]),
      )),
      Expanded(child: ValueListenableBuilder(valueListenable: allExpenses, builder: (context, list, _) {
        final items = list.where((e) => e['category'] == cat).toList();
        return items.isEmpty
            ? const Center(child: Text("No expenses added yet", style: TextStyle(color: Colors.grey)))
            : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) => ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.money, color: Colors.white, size: 18)),
              title: Text(items[i]['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(cat, style: const TextStyle(fontSize: 12)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${selectedCurrency.value}${items[i]['amount']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 16)),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                    onPressed: () => deleteExpense(items[i]),
                  )
                ],
              ),
            ));
      }))
    ]),
  );
}

// ---------------- CATEGORY CLASSES ----------------
class TransportPage extends StatelessWidget { const TransportPage({super.key}); @override Widget build(BuildContext context) => _expensePage(context, "Transport", "Vehicle/Transport Name"); }
class FoodPage extends StatelessWidget { const FoodPage({super.key}); @override Widget build(BuildContext context) => _expensePage(context, "Food", "Food/Item Name"); }
class StayPage extends StatelessWidget { const StayPage({super.key}); @override Widget build(BuildContext context) => _expensePage(context, "Stay", "Hotel/Stay Name"); }
class TicketsPage extends StatelessWidget { const TicketsPage({super.key}); @override Widget build(BuildContext context) => _expensePage(context, "Tickets", "Ticket Type/Name"); }

class AllExpensesPage extends StatelessWidget {
  const AllExpensesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Expenses")),
      body: ValueListenableBuilder(valueListenable: allExpenses, builder: (context, list, _) {
        return list.isEmpty
            ? const Center(child: Text("History is empty"))
            : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => ListTile(
            title: Text(list[i]['title']),
            subtitle: Text(list[i]['category']),
            trailing: Text("${selectedCurrency.value}${list[i]['amount']}", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
        );
      }),
    );
  }
}

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Notepad"), leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context))),
    body: const Center(child: Text("Notes feature is active and syncing...")),
  );
}