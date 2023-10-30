import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        toolbarHeight: 70,
        elevation: 1,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "'Privacy Policy  Of Akshaya Center'\n \nWelcome to the Privacy Policy of Money Saver  (App) provided by Shahir Shibin P (Developer).This Privacy Policy outlines how we collect, use, and protect your personal information when you use our App. By using the App, you agree to the terms and practices described in this Privacy Policy\n\n1. Use of Information \n\n1.1 We use the information collected to show the data in your own Akshaya App.\n\n2. Data Security\n\n2.1 We take the security of your personal information seriously and implement reasonable measures to protect it. The App utilizes encryption techniques to secure and protect your sensitive data within your mobile device.\n2.2 While we strive to ensure the security of your data, no method of transmission or storage over the internet or mobile device is completely secure. Therefore, we cannot guarantee the absolute security of your information.\n\n3. User Contacts\n\n3.1 There is not need to contact numbers for use this application\n.\n4. Read/Write Storage\n\n4.1 Our mobile application requires access to your device's storage to store and retrieve data necessary for the application's functionality. We may collect and store data files, such as user preferences or locally cached content, on your device's storage. We do not access, read, or transfer any personal or sensitive information stored on your device without your consent.\n\n5.Account Deletion\n\n5.1 All your datas are stored in your device itself, so by clicking the 'Reset' button in the 'Homescreen' or by Uninstalling the App you can delete all your datas from the app and storage.\n\n6. Changes to the Privacy Policy\n\n6.1 The Developer reserves the right to update or modify this Privacy Policy at any time. Any changes will be effective immediately upon posting the updated Privacy Policy on the App. You are encouraged to review this Privacy Policy periodically to stay informed of any changes.\n\n7. Contact Us\n\n7.1 If you have any questions, concerns, or requests regarding this Privacy Policy or the handling of your personal information, please contact us at shibinshahir7@gmail.com. By using the App, you acknowledge that you have read, understood, and agree to the terms and practices described in this Privacy Policy.",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
