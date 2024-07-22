// saves page with home FAB, scrollable array of saved scans, listing out their pulse and time saved.
import 'package:flutter/material.dart';
import 'package:medhacks/data/dataManager.dart';
import 'package:medhacks/types/Scan.dart';

class SavesPage extends StatefulWidget {

  const SavesPage({Key? key}) : super(key: key);

  @override
  _SavesPageState createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {

  late Future<List<Scan>> scans;
  final Set<Scan> _selectedScans = Set<Scan>();

  @override
  void initState() {
    super.initState();
    DataManager dataManager = DataManager();
    scans = dataManager.loadLocalScans();
  }

  void _toggleSelection(Scan scan) {
    setState(() {
      if (_selectedScans.contains(scan)) {
        _selectedScans.remove(scan);
      } else {
        _selectedScans.add(scan);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Set the background color of the App Bar to transparent
        backgroundColor: Colors.transparent,
        // Set the elevation to 0, removing the shadow
        elevation: 0,
        // remove the back button
        automaticallyImplyLeading: false,
        title: Text('Saved Scans', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FutureBuilder<List<Scan>>(
          future: scans,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No saved scans',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final scan = snapshot.data![index];
                  final isSelected = _selectedScans.contains(scan);

                  return ListTile(
                    title: Text(
                      'Pulse: ${scan.pulse}, Time: ${scan.dateTime}',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_box, color: Colors.white)
                        : Icon(Icons.check_box_outline_blank, color: Colors.white),
                    selected: isSelected,
                    onTap: () => _toggleSelection(scan),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Home 🏠", style: TextStyle(fontSize: 30)),
              ),
            ),
            SizedBox(width: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.6, end: 1.0)
                      .chain(CurveTween(curve: Curves.elasticOut))
                      .animate(animation),
                  child: child,
                );
              },
              child: _selectedScans.isNotEmpty ? Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: () {

                    DataManager dataManager = DataManager();
                    print("here");
                    scans = dataManager.deleteLocalScans(_selectedScans);
                    // refresh page
                    setState(() {
                      _selectedScans.clear();
                    });
                  },
                  child: const Text("Delete 🗑️", style: TextStyle(fontSize: 30)),
                ),
              ) : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

}