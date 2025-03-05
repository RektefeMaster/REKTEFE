import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/spare_part_model.dart';
import 'spare_part_details_screen.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _selectedCategory = '';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yedek Parça Market'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(child: _buildPartsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Yeni parça ekleme ekranına yönlendir
        },
        child: Icon(Icons.add),
        tooltip: 'Yeni Parça Ekle',
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Parça ara...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      SparePartCategory.engine,
      SparePartCategory.transmission,
      SparePartCategory.brakes,
      SparePartCategory.suspension,
      SparePartCategory.electrical,
      SparePartCategory.body,
      SparePartCategory.interior,
      SparePartCategory.exhaust,
      SparePartCategory.cooling,
      SparePartCategory.fuel,
      SparePartCategory.steering,
      SparePartCategory.accessories,
    ];

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: FilterChip(
                label: Text('Tümü'),
                selected: _selectedCategory.isEmpty,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = '';
                  });
                },
              ),
            );
          }

          final category = categories[index - 1];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: FilterChip(
              label: Text(SparePartCategory.getLocalizedName(category)),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : '';
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPartsList() {
    Query query = FirebaseFirestore.instance.collection('spare_parts')
        .where('isAvailable', isEqualTo: true);

    if (_selectedCategory.isNotEmpty) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Bir hata oluştu: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final parts = snapshot.data!.docs
            .map((doc) => SparePartModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .where((part) {
              if (_searchQuery.isEmpty) return true;
              return part.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     part.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     part.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     part.model.toLowerCase().contains(_searchQuery.toLowerCase());
            })
            .toList();

        if (parts.isEmpty) {
          return Center(
            child: Text('Parça bulunamadı'),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: parts.length,
          itemBuilder: (context, index) {
            return _buildPartCard(parts[index]);
          },
        );
      },
    );
  }

  Widget _buildPartCard(SparePartModel part) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SparePartDetailsScreen(
                partId: part.id,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: part.photos.isNotEmpty
                  ? Image.network(
                      part.photos[0],
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    part.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${part.brand} ${part.model}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (part.rating != null) ...[
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          part.rating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: part.condition == SparePartCondition.newPart
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          SparePartCondition.getLocalizedName(part.condition),
                          style: TextStyle(
                            fontSize: 10,
                            color: part.condition == SparePartCondition.newPart
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₺${part.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
} 