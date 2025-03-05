import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/tefe_coin_model.dart';

class TefeCoinScreen extends StatefulWidget {
  @override
  _TefeCoinScreenState createState() => _TefeCoinScreenState();
}

class _TefeCoinScreenState extends State<TefeCoinScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _recipientController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  Future<void> _addCredit() async {
    if (_amountController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      await TefeCoinService.addCredit(_user!.uid, amount);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bakiye başarıyla yüklendi')),
      );

      _amountController.clear();
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

  Future<void> _transfer() async {
    if (_amountController.text.isEmpty ||
        _recipientController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final recipientDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _recipientController.text)
          .get();

      if (recipientDoc.docs.isEmpty) {
        throw Exception('Alıcı bulunamadı');
      }

      final recipientId = recipientDoc.docs.first.id;
      await TefeCoinService.transfer(
        _user!.uid,
        recipientId,
        amount,
        _descriptionController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transfer başarıyla gerçekleşti')),
      );

      _amountController.clear();
      _recipientController.clear();
      _descriptionController.clear();
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

  void _showAddCreditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bakiye Yükle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Miktar',
                border: OutlineInputBorder(),
                prefixText: '₺ ',
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
              _addCredit();
            },
            child: Text('Yükle'),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transfer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _recipientController,
              decoration: InputDecoration(
                labelText: 'Alıcı E-posta',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Miktar',
                border: OutlineInputBorder(),
                prefixText: '₺ ',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
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
              _transfer();
            },
            child: Text('Gönder'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        body: Center(
          child: Text('Lütfen giriş yapın'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tefe Puanı'),
      ),
      body: Column(
        children: [
          _buildBalanceCard(),
          _buildActionButtons(),
          Expanded(child: _buildTransactionList()),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final balance = (snapshot.data!.data() as Map<String, dynamic>)['tefeCoins'] ?? 0.0;

        return Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Mevcut Bakiye',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '₺ ${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showAddCreditDialog,
              icon: Icon(Icons.add),
              label: Text('Bakiye Yükle'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showTransferDialog,
              icon: Icon(Icons.send),
              label: Text('Transfer'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return StreamBuilder<List<TefeCoinModel>>(
      stream: TefeCoinService.getTransactionHistory(_user!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data!;

        if (transactions.isEmpty) {
          return Center(
            child: Text('İşlem geçmişi bulunamadı'),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionCard(transaction);
          },
        );
      },
    );
  }

  Widget _buildTransactionCard(TefeCoinModel transaction) {
    IconData icon;
    Color color;
    String typeText;

    switch (transaction.type) {
      case TefeCoinType.credit:
        icon = Icons.add_circle;
        color = Colors.green;
        typeText = 'Bakiye Yükleme';
        break;
      case TefeCoinType.debit:
        icon = Icons.remove_circle;
        color = Colors.red;
        typeText = 'Harcama';
        break;
      case TefeCoinType.reward:
        icon = Icons.star;
        color = Colors.amber;
        typeText = 'Ödül';
        break;
      case TefeCoinType.refund:
        icon = Icons.replay;
        color = Colors.orange;
        typeText = 'İade';
        break;
      case TefeCoinType.transfer:
        icon = Icons.swap_horiz;
        color = Colors.blue;
        typeText = 'Transfer';
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
        typeText = 'Bilinmiyor';
    }

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(typeText),
        subtitle: Text(transaction.description ?? ''),
        trailing: Text(
          '${transaction.amount > 0 ? '+' : ''}₺${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction.amount > 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 