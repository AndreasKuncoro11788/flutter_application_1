import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/client/PenggunaClient.dart';
import 'package:flutter_application_1/entity/Pengguna.dart';
import 'package:flutter_application_1/view/editProfile.dart';

// Provider untuk mengambil data pengguna login
final profileProvider = FutureProvider<Pengguna>((ref) async {
  return await Penggunaclient.fetchCurrentUser();
});


class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var listener = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: listener.when(
        data: (pengguna) => _buildProfileContent(context, ref, pengguna),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, WidgetRef ref, Pengguna pengguna) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Profile
          Container(
            height: 318,
            color: const Color(0xFFFB3286),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 26),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFD9D9D9),
                  backgroundImage: NetworkImage(
                    'https://storage.googleapis.com/a1aa/image/r2zxfcEaRKRIQyJ93rkhZOGaF5nkwCef8wobNoQ7cCHDOcJnA.jpg',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  pengguna.namaPengguna,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Nomor Akun : ${pengguna.id}',
                  style: const TextStyle(
                    color: Color(0xFFD9D9D9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Data Pengguna
          _buildDataContainer(Icons.person, pengguna.namaPengguna, 'Nama Pengguna'),
          _buildDataContainer(Icons.person, pengguna.nomorIdentitas, 'Nomor Identitas'),
          _buildDataContainer(Icons.email, pengguna.email, 'Email'),
          _buildDataContainer(Icons.phone, pengguna.nomorTelepon, 'Nomor Telepon'),
          const SizedBox(height: 20),

          // Tombol Edit Profile
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB3286),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Editprofile()),
              ).then((_) => ref.refresh(profileProvider)); // Refresh data setelah edit
            },
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Tombol Logout
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _showLogoutDialog(context),
            child: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: 304,
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Yakin ingin Logout?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tidak'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF27C767),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              // Tambahkan logika logout di sini
                              print('Akun Berhasil Logout');
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget Container untuk Data Pengguna
  Widget _buildDataContainer(IconData icon, String mainText, String subText) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subText,
                style: const TextStyle(
                  color: Color(0xFF696969),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
