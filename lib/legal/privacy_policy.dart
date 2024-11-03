import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Effective Date: March 15, 2024',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection('1. Introduction', '''
Welcome to MotionG. We are committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner. This Privacy Policy outlines how we collect, use, and protect your information in compliance with the General Data Protection Regulation (GDPR).'''),
            _buildSection('2. Information We Collect', '''
We collect the following information when you register for our app:

Email Address: This is used for account creation and communication purposes.'''),
            _buildSection('3. Cookies', '''
We use cookies to enhance your experience on our app. Cookies are small text files stored on your device that help us provide essential functionality. We only use cookies that are necessary for the app to function properly. We do not use cookies to collect personal data.'''),
            _buildSection('4. How We Use Your Information', '''
We use your email address for the following purposes:

To create and manage your account.
To communicate with you regarding your account and app updates.'''),
            _buildSection('5. Data Retention', '''
We will retain your email address for as long as your account is active or as needed to provide you with our services. If you wish to delete your account, please contact us at [Your Contact Email]. '''),
            _buildSection('6. Your Rights', '''
Under the GDPR, you have the following rights regarding your personal data:

The right to access your personal data.
The right to rectify any inaccurate personal data.
The right to request the deletion of your personal data.
The right to restrict the processing of your personal data.
The right to data portability.
To exercise these rights, please contact us at support@MotionG.ai. '''),
            _buildSection('7. Contact Us', '''
If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:

MotionG
support@MotionG.ai'''),
            _buildSection('8. Changes to This Privacy Policy', '''
We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.'''),
            _buildSection('9. Contact Us', '''
If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:

www.MotinG.ai
support@MotionG.ai'''),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
