import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For logout
import 'ProfileScreen.dart'; // Ensure this import is correct
import 'CategorySelection.dart'; // Ensure this import is correct
import 'login.dart'; // Ensure this import is correct

class DashboardScreen extends StatefulWidget {
  final String username; // Accepting username parameter
  final Map<String, String> reservationDetails; // Accepting reservation details

  const DashboardScreen({
    Key? key,
    required this.username,
    required this.reservationDetails,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedDestination;
  final List<String> destinations = [
    'Paris, France',
    'Tokyo, Japan',
    'New York, USA',
    'London, UK',
    'Sydney, Australia',
    'Rome, Italy',
    'Barcelona, Spain',
    'Cape Town, South Africa',
    'Dubai, UAE',
    'Rio de Janeiro, Brazil',
    'Bangkok, Thailand',
    'Amsterdam, Netherlands',
    'Seoul, South Korea',
    'Buenos Aires, Argentina',
    'Cairo, Egypt',
    'Istanbul, Turkey',
    'Athens, Greece',
    'San Francisco, USA',
    'Moscow, Russia',
  ];

  @override
  Widget build(BuildContext context) {
    // Extracting reservation details
    final reservation = widget.reservationDetails;
    final destination = reservation['destination'] ?? 'Not Available';
    final placeName = reservation['placeName'] ?? 'Not Available';
    final date = reservation['date'] ?? 'Not Available';
    final time = reservation['time'] ?? 'Not Available';
    final people = reservation['people'] ?? 'Not Available';

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    reservationDetails: {
                      'user': widget.username,
                      ...widget.reservationDetails,
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Latest Check-ins
                  _buildSectionCard(
                    title: 'Latest Check-ins',
                    children: [
                      _buildCheckInTile(
                        getDisplayName(widget.username),
                        'Hilton, Tokyo',
                        Colors.green,
                        'Paid',
                      ),
                      _buildCheckInTile(
                        getDisplayName(widget.username),
                        'Le Meridien, New York',
                        Colors.green,
                        'Paid',
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Current Reservation Details
                  _buildSectionCard(
                    title: 'Current Reservation Details',
                    children: [
                      _buildReservationList(
                          destination, placeName, date, time, people),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Destination Selection
                  Text(
                    'Select Destination:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildDestinationDropdown(),
                  SizedBox(height: 16),

                  // Confirm Destination Button
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue), // Set button color to blue
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 20.0)), // Optional padding
                      ),
                      onPressed: () {
                        if (selectedDestination == null ||
                            selectedDestination!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please select a destination!')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategorySelectionScreen(
                              destination: selectedDestination!,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Confirm Destination',
                        style: TextStyle(
                            color: Colors
                                .white), // Ensure text color contrasts with blue
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to logout: $e')),
            );
          }
        },
        label: Text('Logout'),
        icon: Icon(Icons.exit_to_app),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInTile(
      String name, String hotel, Color color, String status) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name),
      subtitle: Text(hotel),
      trailing: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDestinationDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedDestination,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      hint: Text('Select a Destination'),
      items: destinations.map((destination) {
        return DropdownMenuItem(
          value: destination,
          child: Text(destination),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedDestination = value;
        });
      },
    );
  }

  Widget _buildReservationList(String destination, String placeName,
      String date, String time, String people) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.restaurant, color: Colors.blue),
          title: Text('Restaurant Reservation: Not Available',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.blue),
          title: Text('Destination: $destination',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Place: $placeName'),
        ),
        ListTile(
          leading: Icon(Icons.calendar_today, color: Colors.blue),
          title: Text('Date: $date',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Time: $time, $people people'),
        ),
      ],
    );
  }

  String getDisplayName(String username) {
    // Extract name before @
    return username.split('@').first;
  }
}
