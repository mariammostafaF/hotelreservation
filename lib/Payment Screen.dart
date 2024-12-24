import 'package:flutter/material.dart';
import 'confirmation.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, String> reservationDetails;

  const PaymentScreen({Key? key, required this.reservationDetails})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String paymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    // Extract details and provide defaults if necessary
    final String placeName =
        widget.reservationDetails['placeName'] ?? 'Unknown Place';
    final String destination =
        widget.reservationDetails['destination'] ?? 'Unknown Destination';
    final String date = widget.reservationDetails['date'] ?? 'Unknown Date';
    final String time = widget.reservationDetails['time'] ?? 'Unknown Time';
    final String people = widget.reservationDetails['people'] ?? '1';

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.blueAccent,
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
                // Reservation Summary
                _buildReservationSummary(
                    placeName, destination, date, time, people),
                SizedBox(height: 20),

                // Credit Card Image
                _buildCreditCardImage(context),
                SizedBox(height: 20),

                // Payment Form
                _buildPaymentForm(),
                SizedBox(height: 20),

                // Confirm Payment Button
                _buildConfirmPaymentButton(context, destination, placeName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationSummary(String placeName, String destination,
      String date, String time, String people) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reservation Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          Text('Place Name: $placeName', style: TextStyle(fontSize: 16)),
          Text('Destination: $destination', style: TextStyle(fontSize: 16)),
          Text('Date: $date', style: TextStyle(fontSize: 16)),
          Text('Time: $time', style: TextStyle(fontSize: 16)),
          Text('Number of People: $people', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCreditCardImage(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/creditcard.png',
        width: MediaQuery.of(context).size.width * 0.5,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Method Dropdown
          Text('Payment Method',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)), // Change the color to white
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: paymentMethod,
            items: [
              DropdownMenuItem(
                  value: 'Credit Card', child: Text('Credit Card')),
              DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
            ],
            onChanged: (value) {
              setState(() {
                paymentMethod = value!;
              });
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              iconColor: Colors.white,
              hintStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          SizedBox(height: 20),

          // Card Number
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.credit_card,
                  color: Colors.white), // Change icon color to white
              labelStyle:
                  TextStyle(color: Colors.white), // Change label color to white
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white), // Set text color to white
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 16) {
                return 'Please enter a valid card number';
              }
              return null;
            },
          ),
          SizedBox(height: 20),

          // Expiry Date and CVV in Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date (MM/YY)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.calendar_today,
                        color: Colors.white), // Change icon color to white
                    labelStyle: TextStyle(
                        color: Colors.white), // Change label color to white
                  ),
                  keyboardType: TextInputType.datetime,
                  style:
                      TextStyle(color: Colors.white), // Set text color to white
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                      return 'Please enter a valid expiry date';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.lock,
                        color: Colors.white), // Change icon color to white
                    labelStyle: TextStyle(
                        color: Colors.white), // Change label color to white
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  style:
                      TextStyle(color: Colors.white), // Set text color to white
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 3) {
                      return 'Please enter a valid CVV';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmPaymentButton(
      BuildContext context, String destination, String placeName) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );

            // Simulate payment processing delay
            await Future.delayed(Duration(seconds: 2));

            // Close loading indicator and navigate to ConfirmationScreen
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmationScreen(
                  reservationDetails: widget.reservationDetails,
                  destination: destination,
                  placeName: placeName,
                ),
              ),
            );
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please fill in all fields correctly'),
              ),
            );
          }
        },
        child: Text('Confirm Payment',
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
