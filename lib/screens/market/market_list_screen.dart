import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/spare_part_model.dart';
import 'spare_part_details_screen.dart';

class MarketListScreen extends StatefulWidget {
  const MarketListScreen({Key? key}) : super(key: key);

  @override
  _MarketListScreenState createState() => _MarketListScreenState();
}

class _MarketListScreenState extends State<MarketListScreen> {
  String _selectedCategory = '';
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  List<SparePartModel> _parts = [];
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadParts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMore) {
        _loadParts();
      }
    }
  }

  Future<void> _loadParts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Query query = FirebaseFirestore.instance.collection('spare_parts')
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(_limit);

      if (_selectedCategory.isNotEmpty) {
        query = query.where('category', isEqualTo: _selectedCategory);
      }

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      final parts = snapshot.docs.map((doc) {
        return SparePartModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).where((part) {
        if (_searchQuery.isEmpty) return true;
        return part.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               part.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               part.model.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();

      setState(() {
        _parts.addAll(parts);
        _lastDocument = snapshot.docs.last;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  void _resetSearch() {
    setState(() {
      _parts = [];
      _lastDocument = null;
      _hasMore = true;
    });
    _loadParts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yedek Parça Market'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_selectedCategory.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Kategori: ${SparePartCategory.getLocalizedName(_selectedCategory)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = '';
                      });
                      _resetSearch();
                    },
                    child: Text('Temizle'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _parts.isEmpty && !_isLoading
                ? Center(
                    child: Text('Sonuç bulunamadı'),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      _resetSearch();
                    },
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _parts.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _parts.length) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final part = _parts[index];
                        return _buildPartCard(part);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Yeni parça ekle
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
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _parts = [];
            _lastDocument = null;
            _hasMore = true;
          });
          _loadParts();
        },
      ),
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
              builder: (context) => SparePartDetailsScreen(partId: part.id),
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
                      part.photos.first,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: Colors.grey,
                      ),
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
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (part.rating != null) ...[
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4),
                        Text(
                          part.rating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                      Text(
                        '₺${part.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Kategori Seç'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: SparePartCategory.values.map((category) {
              return ListTile(
                title: Text(SparePartCategory.getLocalizedName(category)),
                selected: _selectedCategory == category,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory = category;
                    _parts = [];
                    _lastDocument = null;
                    _hasMore = true;
                  });
                  _loadParts();
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('İptal'),
          ),
        ],
      ),
    );
  }
} 