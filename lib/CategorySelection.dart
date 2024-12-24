import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Restaurant Reservation Page.dart'; // Adjust the path as necessary
import 'confirmation.dart'; // Adjust the path as necessary

class CategorySelectionScreen extends StatefulWidget {
  final String destination;

  const CategorySelectionScreen({Key? key, required this.destination})
      : super(key: key);

  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String selectedCategory = 'Hotel'; // Default category
  List<dynamic> places = [];
  bool isLoading = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    final String category = selectedCategory.toLowerCase();
    final String location = widget.destination;

    final String osmUrl =
        'https://nominatim.openstreetmap.org/search?q=$category+$location&format=json';

    try {
      final response = await http.get(Uri.parse(osmUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          places = data.map((place) {
            place['image'] =
                'https://via.placeholder.com/150'; // Dummy image URL
            return place;
          }).toList();
          isLoading = false;
        });
      } else {
        _handleError('Failed to load places.');
      }
    } catch (e) {
      _handleError('Error: $e');
    }
  }

  void _handleError(String message) {
    setState(() {
      isLoading = false;
      hasError = true;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Destination Info
                Text(
                  'Destination: ${widget.destination}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Category Selector
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ['Hotel', 'Restaurant'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                        _fetchPlaces();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                // Loading, Error, or Places List
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (hasError)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error fetching data. Please try again.',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _fetchPlaces,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (places.isEmpty)
                  const Center(
                    child: Text(
                      'No places found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];
                        final displayName = place['display_name'] ?? 'No name';
                        final split = displayName.split(',');
                        final name = split[0];
                        final address = split.length > 1
                            ? split.sublist(1).join(', ')
                            : 'Address not available';

                        return Card(
                          color: Colors.white.withOpacity(0.9),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.network(
                              place['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              address,
                              style: TextStyle(color: Colors.black54),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReservationScreen(
                                    destination: widget.destination,
                                    restaurantName: name,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                // Confirm Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (places.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationScreen(
                              destination: widget.destination,
                              restaurantName: '',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No places found!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Confirm Category',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
