import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/spare_part_model.dart';
import '../../models/tefe_coin_model.dart';

class SparePartDetailsScreen extends StatefulWidget {
  final String partId;

  const SparePartDetailsScreen({Key? key, required this.partId}) : super(key: key);

  @override
  _SparePartDetailsScreenState createState() => _SparePartDetailsScreenState();
}

class _SparePartDetailsScreenState extends State<SparePartDetailsScreen> {
  SparePartModel? _part;
  bool _isLoading = true;
  int _selectedQuantity = 1;
  int _currentImageIndex = 0;
  final _reviewController = TextEditingController();
  double _selectedRating = 5.0;

  @override
  void initState() {
    super.initState();
    _loadPartData();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _loadPartData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('spare_parts')
          .doc(widget.partId)
          .get();

      if (doc.exists) {
        setState(() {
          _part = SparePartModel.fromMap({...doc.data()!, 'id': doc.id});
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  Future<void> _purchasePart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen giriş yapın')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final totalPrice = _part!.price * _selectedQuantity;

      // Bakiyeyi kontrol et
      final balance = await TefeCoinService.getBalance(user.uid);
      if (balance < totalPrice) {
        throw Exception('Yetersiz bakiye');
      }

      // Stok kontrolü
      if (_part!.stock < _selectedQuantity) {
        throw Exception('Yetersiz stok');
      }

      // Batch işlemi başlat
      final batch = FirebaseFirestore.instance.batch();

      // Satın alma işlemi oluştur
      final purchaseId = FirebaseFirestore.instance.collection('purchases').doc().id;
      batch.set(
        FirebaseFirestore.instance.collection('purchases').doc(purchaseId),
        {
          'userId': user.uid,
          'partId': widget.partId,
          'quantity': _selectedQuantity,
          'totalPrice': totalPrice,
          'status': 'completed',
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      // Stok güncelle
      batch.update(
        FirebaseFirestore.instance.collection('spare_parts').doc(widget.partId),
        {
          'stock': FieldValue.increment(-_selectedQuantity),
        },
      );

      // Tefe puanı işlemi
      await TefeCoinService.debit(
        user.uid,
        totalPrice,
        referenceId: purchaseId,
        description: '${_part!.name} satın alımı',
      );

      // Satıcıya ödeme
      await TefeCoinService.transfer(
        user.uid,
        _part!.sellerId,
        totalPrice,
        '${_part!.name} satışı',
      );

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Satın alma işlemi başarılı')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPurchaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Satın Al'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Adet Seçin'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _selectedQuantity > 1
                      ? () {
                          setState(() {
                            _selectedQuantity--;
                          });
                        }
                      : null,
                  icon: Icon(Icons.remove),
                ),
                SizedBox(width: 16),
                Text(
                  _selectedQuantity.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: _selectedQuantity < _part!.stock
                      ? () {
                          setState(() {
                            _selectedQuantity++;
                          });
                        }
                      : null,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Toplam: ₺${(_part!.price * _selectedQuantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _purchasePart();
            },
            child: Text('Satın Al'),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Değerlendirme Yap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Yorumunuz',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Değerlendirme gönder
              Navigator.pop(context);
            },
            child: Text('Gönder'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _part == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Parça Detayları')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Parça Detayları'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSlider(),
            _buildPartInfo(),
            _buildCompatibility(),
            _buildSellerInfo(),
            _buildReviews(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildImageSlider() {
    if (_part!.photos.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[200],
        child: Icon(Icons.image, size: 100, color: Colors.grey),
      );
    }

    return Container(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: _part!.photos.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                _part!.photos[index],
                fit: BoxFit.cover,
              );
            },
          ),
          if (_part!.photos.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _part!.photos.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentImageIndex
                          ? Colors.blue
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPartInfo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _part!.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              if (_part!.rating != null) ...[
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 4),
                Text(
                  _part!.rating!.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' (${_part!.reviewCount} değerlendirme)',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 16),
              ],
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _part!.condition == SparePartCondition.newPart
                      ? Colors.green[50]
                      : Colors.orange[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  SparePartCondition.getLocalizedName(_part!.condition),
                  style: TextStyle(
                    color: _part!.condition == SparePartCondition.newPart
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '₺${_part!.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Stok: ${_part!.stock}',
            style: TextStyle(
              color: _part!.stock > 0 ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Kategori: ${SparePartCategory.getLocalizedName(_part!.category)}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Marka: ${_part!.brand}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Model: ${_part!.model}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Text(
            'Açıklama',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(_part!.description),
        ],
      ),
    );
  }

  Widget _buildCompatibility() {
    if (_part!.compatibility.isEmpty) return SizedBox();

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uyumluluk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ..._part!.compatibility.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.value.map((model) {
                      return Chip(
                        label: Text(model),
                        backgroundColor: Colors.grey[200],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerInfo() {
    return Card(
      margin: EdgeInsets.all(16),
      child: ListTile(
        title: Text('Satıcı'),
        subtitle: Text(_part!.sellerName),
        trailing: TextButton(
          onPressed: () {
            // TODO: Satıcı profiline git
          },
          child: Text('Profili Gör'),
        ),
      ),
    );
  }

  Widget _buildReviews() {
    // TODO: Değerlendirmeleri göster
    return SizedBox();
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toplam',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '₺${(_part!.price * _selectedQuantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _part!.stock > 0 ? _showPurchaseDialog : null,
            child: Text('Satın Al'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 