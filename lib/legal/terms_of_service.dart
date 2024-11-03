import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service',
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
Welcome to MotionG. These Terms of Service ("Terms") govern your access to and use of our app and services. By using our app, you agree to comply with these Terms. If you do not agree with any part of these Terms, you must not use our app.'''),
            _buildSection('2. Eligibility', '''
You must be at least 13 years old to use our app. By using our app, you represent and warrant that you meet this eligibility requirement.'''),
            _buildSection('3. Account Registration', '''
To access certain features of our app, you may be required to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.'''),
            _buildSection('4. User Responsibilities', '''
You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account or any other breach of security.'''),
            _buildSection('5. Acceptable Use', '''
You agree not to use the app for any unlawful or prohibited purpose. You agree not to:

• Use the app in a manner that could damage, disable, overburden, or impair the app.
• Attempt to gain unauthorized access to any part of the app or any other systems or networks connected to the app.
• Use any automated means, including robots, spiders, or data mining tools, to access the app for any purpose without our express written permission.'''),
            _buildSection('6. Intellectual Property', '''
All content, features, and functionality of the app, including but not limited to text, graphics, logos, and software, are the exclusive property of MotionG or its licensors and are protected by copyright, trademark, and other intellectual property laws.'''),
            _buildSection('7. Termination', '''
We reserve the right to terminate or suspend your account and access to the app at our sole discretion, without notice, for conduct that we believe violates these Terms or is harmful to other users of the app, us, or third parties, or for any other reason.'''),
            _buildSection('8. Disclaimers', '''
The app is provided on an "as-is" and "as-available" basis. We make no representations or warranties of any kind, express or implied, regarding the operation of the app or the information, content, materials, or products included in the app.'''),
            _buildSection('9. Limitation of Liability', '''
To the fullest extent permitted by applicable law, MotionG shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from or related to your use of the app.'''),
            _buildSection('10. Changes to These Terms', '''
We may update these Terms from time to time. We will notify you of any changes by posting the new Terms on this page. Your continued use of the app after any changes to these Terms constitutes your acceptance of the new Terms.'''),
            _buildSection('11. Governing Law', '''
These Terms shall be governed by and construed in accordance with the laws of Hong Kong Special Administrative Region, without regard to its conflict of law principles.'''),
            _buildSection('12. Contact Us', '''
If you have any questions about these Terms, please contact us at:

MotionG
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
