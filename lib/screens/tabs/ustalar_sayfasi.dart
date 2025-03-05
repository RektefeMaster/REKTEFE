import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/tefe_coin_widget.dart';

class UstalarSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ustalar'),
        actions: [
          TefeCoinWidget(),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'usta')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final ustalar = snapshot.data?.docs ?? [];

          if (ustalar.isEmpty) {
            return Center(child: Text('Henüz usta bulunmuyor'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: ustalar.length,
            itemBuilder: (context, index) {
              final usta = ustalar[index].data() as Map<String, dynamic>;
              final rating = usta['rating'] ?? 0.0;
              final specialty = usta['specialty'] ?? 'Genel';

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // Usta detay sayfasına yönlendir
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: usta['photo_url'] != null
                              ? NetworkImage(usta['photo_url'])
                              : null,
                          child: usta['photo_url'] == null
                              ? Icon(Icons.person, size: 30)
                              : null,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usta['name'] ?? 'İsimsiz Usta',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                specialty,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' (${usta['review_count'] ?? 0} değerlendirme)',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
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
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Usta başvuru formuna yönlendir
        },
        icon: Icon(Icons.engineering),
        label: Text('Usta Ol'),
      ),
    );
  }
} 