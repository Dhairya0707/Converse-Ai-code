import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              print("called");
            },
            icon: const Icon(Icons.arrow_back_rounded)),
        title: const Text(
          'About Converse AI',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Empowering You to Create Custom Chatbots with Ease',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Welcome to Converse AI! Our mission is to help users like you create custom chatbots effortlessly. Whether you\'re looking to build a chatbot for customer service, personal assistance, or any other purpose, our intuitive platform provides the tools and guidance you need.',
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Our Vision:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'At Converse AI, we believe that chatbots have the potential to revolutionize the way we interact with technology. By making chatbot creation accessible to everyone, we aim to empower businesses and individuals to enhance their communication and efficiency.',
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'If you have any questions, feedback, or need support, please feel free to reach out to us. We\'re here to help you succeed with your chatbot projects.',
              ),
              const SizedBox(height: 10.0),
              InkWell(
                child: const Text(
                  'dhairyadarji025@gmail.com',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () => launch('mailto:dhairyadarji025@gmail.com'),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Thank you for choosing Converse AI. We look forward to seeing the amazing chatbots you create!',
              ),

              const SizedBox(height: 20.0), // Add spacing after email

              // Add the credit line
              const Text(
                'Created by Dhairya Darji with Love for Flutter',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
