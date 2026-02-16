import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';
import 'package:ridetohealthdriver/feature/historyAndProfile/presentation/driver_profile/controller/driver_profile_controller.dart';
import 'package:ridetohealthdriver/feature/auth/presentation/screens/account_security_screen.dart';
import 'package:ridetohealthdriver/feature/historyAndProfile/presentation/screens/notifications_screen.dart';
import 'package:ridetohealthdriver/feature/historyAndProfile/presentation/screens/privacy_policy_screen.dart';
import 'package:ridetohealthdriver/feature/historyAndProfile/presentation/screens/delete_account_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../app/screens/rating_review_screen.dart';
import '../driver_profile/screens/driver_profile_info_screen.dart';
import '../vehicle_profile/screens/vehicle_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController authController = Get.find<AuthController>();
  final driverProfileController = Get.put(DriverProfileController());
  // @override
  // void initState() {
  //   //Get.find<ProfileController>().getUserById();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: 'My Profile'.text20white(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(() {
                          final profile = driverProfileController
                              .driverProfile
                              .value
                              ?.profileData;
                          final imageUrl = profile?.profileImage;
                          return Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xffCE0000).withOpacity(0.8),
                                  Color(0xff7B0100).withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: ClipOval(
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.person_outline,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      'assets/images/user5.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        }),
                        SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () =>
                                  (driverProfileController
                                              .fullName
                                              .value
                                              .isNotEmpty
                                          ? driverProfileController
                                                .fullName
                                                .value
                                          : 'Unknown')
                                      .text22White(),
                            ),
                            SizedBox(height: 4),
                            Obx(
                              () =>
                                  (driverProfileController
                                              .email
                                              .value
                                              .isNotEmpty
                                          ? driverProfileController.email.value
                                          : '')
                                      .text14White(),
                            ),
                            Obx(
                              () =>
                                  (driverProfileController
                                              .phone
                                              .value
                                              .isNotEmpty
                                          ? driverProfileController.phone.value
                                          : '')
                                      .text14White(),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),

                        SizedBox(height: 4),
                        Spacer(),
                      ],
                    ),

                    Divider(color: Colors.white54, thickness: 0.5),
                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 6),
                                '4.9'.text14White(),
                              ],
                            ),
                            SizedBox(height: 4),
                            'Rating'.text14White(),
                          ],
                        ),

                        Spacer(),
                        Column(
                          children: [
                            SizedBox(width: 6),
                            '852'.text14White(),
                            SizedBox(height: 4),
                            'Riders'.text14White(),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            SizedBox(width: 6),
                            '17 jan 2023'.text14White(),
                            SizedBox(height: 4),
                            'Member since'.text14White(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Column(children: [Row(children: [
                        
                      ],
                    )]),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    //SizedBox(height: 12),
                    _buildMenuItem(
                      Icons.person_outline,
                      "Profile Information",
                      "Customize your profile",
                      onTap: () {
                        Get.to(() => DriverProfileInfoScreen());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.wallet_outlined,
                      "Vehicle Details",
                      "Term of services",
                      onTap: () {
                        Get.to(() => VehicleDetailsScreen());
                      },
                    ),

                    _divider(),
                    _buildMenuItem(
                      Icons.shield_outlined,
                      "Account Security",
                      "Change password & devices",
                      onTap: () {
                        Get.to(() => const AccountSecurityScreen());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.notifications_outlined,
                      "Manage Notifications",
                      "Customize alerts",
                      onTap: () {
                        Get.to(NotificationsScreen());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.help_outline,
                      "Rating Review",
                      "",
                      onTap: () {
                        Get.to(RatingsReviewsScreen());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.shield_outlined,
                      "Privacy policy",
                      'Privacy policy',
                      onTap: () {
                        Get.to(PrivacyPolicyScreen());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.delete_outline,
                      "Delete Account",
                      'Request account deletion',
                      color: const Color(0xffCE0000).withOpacity(0.8),
                      onTap: () {
                        Get.to(() => const DeleteAccountScreen());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.logout,
                      "Log Out",
                      'Sign out of your account',

                      color: Color(0xffCE0000).withOpacity(0.8),

                      onTap: () {
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: 400,
                              decoration: BoxDecoration(
                                color: Color(0xff303644),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white, // Default color
                                      ),
                                      children: [
                                        const TextSpan(text: "Are You Sure  "),
                                        TextSpan(
                                          text: "Log out",
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(text: " Your Account?"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  SizedBox(
                                    width: 350,

                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),

                                        backgroundColor: const Color(
                                          0xff3B82F6,
                                        ),
                                      ),
                                      onPressed: () async {
                                        await Get.find<AuthController>()
                                            .logOut();
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 350,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),

                                        backgroundColor: const Color(
                                          0xffEF4444,
                                        ),
                                      ),
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },

                      // onTap: () async{
                      //   await Get.find<AuthController>().logOut();
                      // },
                    ),
                    _divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle, {
    Color color = Colors.black54,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.white10,
      margin: const EdgeInsets.all(1),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xffD8D8D8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color == Color(0xffCE0000).withOpacity(0.8)
                ? Color(0xffCE0000).withOpacity(0.8)
                : Colors.white,
            fontSize: 16,
            fontFamily: 'outfit',
            fontWeight: FontWeight.bold,
          ),
        ),

        //title: title.text16White(),
        subtitle: subtitle.text12White(),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.context(context).iconColor,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _divider({Color color = const Color(0xffD8D8D8)}) {
    return Divider(
      height: 1,
      indent: 5,
      endIndent: 5,
      thickness: 0.1,
      color: color,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:rideztohealth/core/extensions/text_extensions.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     //Get.find<ProfileController>().getUserById();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     // final String today = DateFormat('d MMMM').format(DateTime.now());

//     //     if (profileController
//     //         .getUserByIdResponseModel
//     //         .userforProfile
//     //         .isBlank!) {
//     //       print('task is empty');
//     //       return Container(
//     //         height: size.height * 0.8,
//     //         width: size.width,
//     //         child: const Center(child: Text('No Task Found')),
//     //       );
//     //     }
//     //     if (profileController.getUserByIdResponseModel == null) {
//     //       print('TAsk is null');
//     //       return Container(
//     //         height: size.height * 0.8,
//     //         width: size.width,
//     //         child: const Center(child: Text('No Task Found')),
//     //       );
//     //     }
//     // return !profileController.getUserByIdisLoading
//     //     ?

//     return ColoredBox(
//       color: Color(0xFF438B92),
//       child: SafeArea(
//         child: Scaffold(
//           //backgroundColor: Color(0xffB0E0CF), // light gray-blue background
//           body: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // App bar title
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: 'My Profile'.text20Black(),
//                 ),
//               ),

//               // Profile Section
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.grey[200],
//                       child: ClipOval(
//                         child: Image.network(
//                           // profileController
//                           //         .getUserByIdResponseModel
//                           //         .userforProfile
//                           //         ?.avatar ??
//                           '',
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Center(
//                               child: Icon(
//                                 Icons.person_outline,
//                                 size: 30,
//                                 color: Colors.grey,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     // CircleAvatar(
//                     //   radius: 30,
//                     //   backgroundImage: NetworkImage(
//                     //     profileController
//                     //         .getUserByIdResponseModel
//                     //         .user!
//                     //         .avatar
//                     //         .toString(),
//                     //   ),
//                     //   // AssetImage(
//                     //   //   'assets/images/person.png',
//                     //   // ), // Your profile image
//                     // ),
//                     SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // (

//                         //   profileController
//                         //         .getUserByIdResponseModel
//                         //         .userforProfile!
//                         //         .name!
//                         //         )
//                         'John Doe'.text22White(),
//                         SizedBox(height: 4),
//                       ],
//                     ),
//                     Spacer(),
//                     // InkWell(
//                     //   onTap: () {
//                     //     // final profileUser =
//                     //     //     profileController
//                     //     //         .getUserByIdResponseModel
//                     //     //         .userforProfile;
//                     //     // if (profileUser != null) {
//                     //     //   Get.to(
//                     //     //     EditProfile(userProfile: profileUser),
//                     //     //   );
//                     //     // } else {
//                     //     //   Get.snackbar(
//                     //     //     'Error',
//                     //     //     'User data not loaded yet',
//                     //     //   );
//                     //     // }
//                     //   },
//                     //   child: Image.asset(
//                     //     'assets/icons/edit.png',
//                     //     height: 70,
//                     //     width: 70,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView(
//                     children: [
//                       SizedBox(height: 30),
//                       _buildMenuItem(
//                         Icons.info_outline,
//                         "About App",
//                         onTap: () {
//                           //Get.to(AboutAppScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.privacy_tip_outlined,
//                         "Privacy Policy",
//                         onTap: () {
//                           //Get.to(PrivacyPolicyScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.article_outlined,
//                         "Term & Condition",
//                         onTap: () {
//                           //Get.to(TearmAndConditonScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.lock_outline,
//                         "Change Password",
//                         onTap: () {
//                           // Get.to(ChangePasswordScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.notifications_outlined,
//                         "Notification",
//                         onTap: () {
//                           // Get.to(NotificationScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.logout,
//                         "Log Out",
//                         color: Colors.red,
//                         onTap: () {
//                           //Get.to(SignInScreen());
//                         },
//                       ),
//                       _divider(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//     // : Container(child: Center(child: CircularProgressIndicator()));
//   }

//   Widget _buildMenuItem(
//     IconData icon,
//     String title, {
//     Color color = const Color(0xFF438B92),
//     required VoidCallback onTap,

//     //VoidCallback   onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(
//         title,
//         style: TextStyle(color: color, fontSize: 16, fontFamily: 'outfit'),
//       ),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
//       onTap: onTap, // Handle navigation here
//     );
//   }

//   Widget _divider({Color color = const Color(0xFF438B92)}) {
//     return Divider(
//       height: 1,
//       indent: 20,
//       endIndent: 20,
//       thickness: 0.5,
//       color: color,
//     );
//   }
// }
