import 'package:flutter/material.dart';
import '../components/func.dart';
import '../components/kite.dart';

class KitePage extends StatefulWidget {
  static const String id = 'kite_page';
  @override
  _KitePageState createState() => _KitePageState();
}

class _KitePageState extends State<KitePage> {
  String result = ''; // Variable to store the calculation result
  String dropdownValue = '10'; // Set the default dropdown value to '10'

  // A table of weight-to-kite-size mappings with weight ranges
  List<Map<String, dynamic>> table = [
    {'number': '40-50', 'value': '6'},
    {'number': '50-60', 'value': '8'},
    {'number': '60-70', 'value': '9'},
    {'number': '70-80', 'value': '10'},
    {'number': '80-90', 'value': '12'},
    {'number': '90-100', 'value': '14'},
    {'number': '100-110', 'value': '16'},
  ];

  String selectedWeightRange = '10'; // Initialize with the default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Kite(), // call the spinning image
              SizedBox(
                height: 20,
              ),
              Text(
                'Kite Size Calculator',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Please select your weight range: ',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 75,
                child: Center(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        // Update the selected weight range
                        selectedWeightRange = newValue;
                        // Look up the corresponding value from the table
                        result = findValueInTable(newValue);
                      });
                    },
                    items: table.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry['value'].toString(),
                        child: Text(entry['number'].toString()),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Center(
                // Center the DropdownButton
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 125.0,
                  height: 125.0,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$selectedWeightRange',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * Find and return a value from a table based on a specified 'value'.
   *
   * @param {String} value - The value to search for in the table.
   * @returns {String} The corresponding value found in the table, or an empty string if not found.
   */
  String findValueInTable(String value) {
    for (var entry in table) {
      if (value == entry['value'].toString()) {
        return entry['value'].toString();
      }
    }
    return '';
  }
}