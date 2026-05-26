import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/normal_custom_button.dart';
import '../../../../core/widgets/normal_custom_icon_button.dart';
import 'call_screen.dart';
import 'chat_screen.dart';

class RideConfirmedScreen extends StatefulWidget {
  const RideConfirmedScreen({super.key});

  @override
  State<RideConfirmedScreen> createState() => _RideConfirmedScreenState();
}

class _RideConfirmedScreenState extends State<RideConfirmedScreen> {
  String? _selectedProfile;

  void _onProfileSelected(String profileType) {
    setState(() {
      _selectedProfile = profileType;
    });
  }

  Widget _buildProfileOption({
    required String type,
    required String description,
    required String imagePath,
  }) {
    final isSelected = _selectedProfile == type;

    return GestureDetector(
      onTap: () => _onProfileSelected(type),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              // ignore: deprecated_member_use
              ? AppColors.context(context).primaryColor.withOpacity(0.08)
              : Colors.white12,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.context(context).primaryColor
                : Colors.grey.withOpacity(0.07),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.context(context).primaryColor.withOpacity(0.1)
                    : Colors.white12,
              ),
              child: Image.asset(imagePath, height: 30, width: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    'Your driver is coming in 3:00',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Driver Profile Card
              Divider(color: Colors.grey[700], thickness: 0.5),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  //  color: const Color(0xFF3B3B42),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/user6.png'),
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Max Johnson',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  "2.5 mi: 4140 Parker Rd".text12White(),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 5),
                              "4.9".text14White(),
                              " (127)".text12Grey(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/privet_car.png',
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[700], thickness: 0.5),
              SizedBox(height: 20),
              _buildProfileOption(
                type: "Cash",
                description: "Pay with cash after your ride",
                imagePath: 'assets/icons/dollarIcon.png',
              ),
              _buildProfileOption(
                type: "Wallet",
                description: "Balance: \$45.50",
                imagePath: 'assets/icons/walletIocn.png',
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    height: 51,
                    width: size.width * 0.7,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        hintText: 'Enter coupon code',
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  NormalCustomButton(
                    height: 51,
                    weight: size.width * 0.2,
                    text: "Apply",
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.grey[700], thickness: 1.5),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Total".text16White500(),
                    "\$32.50".text16White500(),
                  ],
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: NormalCustomIconButton(
                      icon: Icons.call_outlined,
                      iconSize: 30,
                      onPressed: () {
                        Get.to(CallScreen());
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: NormalCustomIconButton(
                      icon: Icons.messenger_outline,
                      iconSize: 30,
                      onPressed: () {
                        Get.to(ChatScreenRTH());
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    flex: 3,
                    child: NormalCustomButton(
                      height: 51,
                      fontSize: 18,
                      circularRadious: 30,
                      text: "Cencel Ride",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
