import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../models/car_model.dart';
import '../../widgets/tefe_coin_widget.dart';

class ProfilSayfasi extends StatefulWidget {
  @override
  _ProfilSayfasiState createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          TefeCoinWidget(),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = UserModel.fromMap(
            Map<String, dynamic>.from(snapshot.data?.data() as Map<String, dynamic>? ?? {}),
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(userData),
                SizedBox(height: 24),
                _buildSection('Araçlarım', Icons.directions_car),
                _buildCarsList(userData.cars),
                SizedBox(height: 24),
                if (userData.role == 'user')
                  _buildBecomeMechanicButton()
                else if (userData.role == 'usta')
                  _buildMechanicProfile(userData.mechanicProfile),
                SizedBox(height: 24),
                _buildSection('Hesap Ayarları', Icons.settings),
                _buildSettingsButtons(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Araç ekleme sayfasına yönlendir
        },
        child: Icon(Icons.add),
        tooltip: 'Araç Ekle',
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: user.photoUrl.isNotEmpty
              ? NetworkImage(user.photoUrl)
              : null,
          child: user.photoUrl.isEmpty
              ? Icon(Icons.person, size: 40)
              : null,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                user.email,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                user.phone,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // Profil düzenleme sayfasına yönlendir
          },
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarsList(List<CarModel> cars) {
    if (cars.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('Henüz araç eklenmemiş'),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('${car.brand} ${car.model}'),
            subtitle: Text('${car.year} - ${car.plateNumber}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Araç düzenleme sayfasına yönlendir
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBecomeMechanicButton() {
    return Card(
      child: InkWell(
        onTap: () {
          // Usta başvuru formuna yönlendir
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.engineering, size: 32, color: Colors.blue),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usta Olmak İster misiniz?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Hemen başvurun ve kazanmaya başlayın',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMechanicProfile(Map<String, dynamic>? mechanicProfile) {
    if (mechanicProfile == null) return SizedBox();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usta Profili',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildMechanicInfo('Uzmanlık', mechanicProfile['specialties']?.join(', ') ?? ''),
            _buildMechanicInfo('Değerlendirme', '${mechanicProfile['rating'] ?? 0.0} (${mechanicProfile['review_count'] ?? 0} değerlendirme)'),
            _buildMechanicInfo('Adres', mechanicProfile['address'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildMechanicInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButtons() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Bildirim Ayarları'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Bildirim ayarları sayfasına yönlendir
          },
        ),
        ListTile(
          leading: Icon(Icons.security),
          title: Text('Güvenlik'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Güvenlik ayarları sayfasına yönlendir
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Yardım'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Yardım sayfasına yönlendir
          },
        ),
      ],
    );
  }
} 