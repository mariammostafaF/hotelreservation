import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'payment screen.dart'; // Import the PaymentScreen class
import 'custom_card.dart'; // Import the CustomCard class

class ReservationScreen extends StatefulWidget {
  final String restaurantName;
  final String destination;

  const ReservationScreen({
    Key? key,
    required this.restaurantName,
    required this.destination,
  }) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedArrivalDate;
  DateTime? selectedDepartureDate;
  TimeOfDay? selectedTime;
  int numberOfPeople = 1;
  bool isLoading = false;
  String? selectedRoomType;
  final List<String> roomTypes = ['Single', 'Double', 'Suite'];
  final List<String> roomImages = [
    'assets/single_room.jpg',
    'assets/deluxe_room.jpg',
    'assets/suite_room.jpg',
  ];

  Future<void> _selectDate(BuildContext context, bool isArrival) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      setState(() {
        if (isArrival) {
          selectedArrivalDate = picked;
          if (selectedDepartureDate != null &&
              selectedDepartureDate!.isBefore(picked)) {
            selectedDepartureDate = null;
          }
        } else {
          selectedDepartureDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _confirmReservation(BuildContext context) async {
    if (selectedArrivalDate == null ||
        selectedDepartureDate == null ||
        selectedTime == null ||
        selectedRoomType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields before proceeding!'),
        ),
      );
      return;
    }

    if (numberOfPeople < 1 || numberOfPeople > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Number of people must be between 1 and 20.'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final reservationDetails = {
      'restaurantName': widget.restaurantName,
      'destination': widget.destination,
      'arrivalDate': DateFormat('MMMM dd, yyyy').format(selectedArrivalDate!),
      'departureDate':
          DateFormat('MMMM dd, yyyy').format(selectedDepartureDate!),
      'time': selectedTime!.format(context),
      'people': numberOfPeople.toString(),
      'roomType': selectedRoomType!,
    };

    await Future.delayed(Duration(seconds: 2));

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentScreen(reservationDetails: reservationDetails),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Discard Changes?'),
                content: Text('Are you sure you want to discard your changes?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Yes'),
                  ),
                ],
              ),
            ) ??
            false;
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reserve at ${widget.restaurantName}'),
          backgroundColor: Colors.white,
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
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Make your reservation',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDateCard('Select Arrival Date', selectedArrivalDate,
                      () => _selectDate(context, true)),
                  _buildDateCard('Select Departure Date', selectedDepartureDate,
                      () => _selectDate(context, false)),
                  _buildTimeCard(),
                  _buildPeopleSelector(),
                  SizedBox(height: 20),
                  Text(
                    'Select Room Type:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: roomTypes.asMap().entries.map((entry) {
                      int index = entry.key;
                      String roomType = entry.value;
                      return CustomCard(
                        imagePath: roomImages[index],
                        title: roomType,
                        isSelected: selectedRoomType == roomType,
                        onTap: () {
                          setState(() {
                            selectedRoomType = roomType;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => _confirmReservation(context),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Confirm Reservation',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(String label, DateTime? date, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Colors.blueAccent),
        title: Text(
          date != null ? DateFormat('MMMM dd, yyyy').format(date) : label,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTimeCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.access_time, color: Colors.blueAccent),
        title: Text(
          selectedTime != null ? selectedTime!.format(context) : 'Select Time',
        ),
        onTap: () => _selectTime(context),
      ),
    );
  }

  Widget _buildPeopleSelector() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Number of People:",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (numberOfPeople > 1) numberOfPeople--;
                    });
                  },
                ),
                Text('$numberOfPeople', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      numberOfPeople++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
