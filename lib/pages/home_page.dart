import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/kategori_card.dart';
import '../widgets/riwayat_tile.dart';
import 'tambah_pengeluaran_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String selectedFilter = 'Hari'; // Options: 'Hari', 'Minggu', 'Bulan'

  final kategoriList = [
    {
      'nama': 'Food',
      'ikon': Icons.restaurant,
      'warnaIkon': const Color(0xFFDC143C),
      'warnaBg': const Color(0xFFFFE4E1),
    },
    {
      'nama': 'Transport',
      'ikon': Icons.directions_subway,
      'warnaIkon': const Color(0xFF228B22),
      'warnaBg': const Color(0xFFE8F5E9),
    },
    {
      'nama': 'Campus',
      'ikon': Icons.menu_book,
      'warnaIkon': const Color(0xFF1E3A8A),
      'warnaBg': const Color(0xFFE0F2FE),
    },
    {
      'nama': 'Others',
      'ikon': Icons.grid_view_rounded,
      'warnaIkon': const Color(0xFF475569),
      'warnaBg': const Color(0xFFF1F5F9),
    },
  ];

  String formatRupiah(num number, {bool isMinus = false}) {
    String strVal = number.abs().toStringAsFixed(0);
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted =
        strVal.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return isMinus ? '-Rp$formatted' : 'Rp$formatted';
  }

  String _formatHeaderTanggal(DateTime date) {
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  List<TransactionModel> _filterTransactions(List<TransactionModel> list) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<TransactionModel> result = [];

    if (selectedFilter == 'Hari') {
      result = list.where((tx) {
        final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
        return txDate.isAtSameMomentAs(today);
      }).toList();
    } else if (selectedFilter == 'Minggu') {
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      result = list.where((tx) {
        return tx.date.isAfter(startOfWeek.subtract(const Duration(seconds: 1)));
      }).toList();
    } else if (selectedFilter == 'Bulan') {
      result = list.where((tx) {
        return tx.date.year == now.year && tx.date.month == now.month;
      }).toList();
    } else {
      result = List.from(list);
    }

    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  Map<String, List<TransactionModel>> _groupTransactions(
      List<TransactionModel> list) {
    final Map<String, List<TransactionModel>> grouped = {};
    for (var tx in list) {
      final header = _formatHeaderTanggal(tx.date);
      if (!grouped.containsKey(header)) {
        grouped[header] = [];
      }
      grouped[header]!.add(tx);
    }
    return grouped;
  }

  double _hitungTotalHarian(List<TransactionModel> txs) {
    return txs
        .where((tx) => tx.isPengeluaran)
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  void _hapusDenganUndo(TransactionModel tx, int originalIndex) {
    ref.read(transactionProvider.notifier).deleteTransaction(tx.id);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${tx.judul}" dihapus'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Batal',
          textColor: const Color(0xFFFEF08A),
          onPressed: () {
            ref
                .read(transactionProvider.notifier)
                .insertTransactionAt(originalIndex, tx);
          },
        ),
      ),
    );
  }

  void _bukaTambahPengeluaran() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahPengeluaranPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final riwayatList = ref.watch(transactionProvider);
    final notifier = ref.watch(transactionProvider.notifier);

    final filteredList = _filterTransactions(riwayatList);
    final groupedData = _groupTransactions(filteredList);

    double sisaSaldo = notifier.sisaSaldo;
    double totalPengeluaran = notifier.totalPengeluaran;
    double totalPemasukan = notifier.totalPemasukan;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profil
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF00796B),
                        backgroundImage: AssetImage('assets/la peace.jpeg'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Selamat Pagi,',
                              style: TextStyle(color: Colors.grey, fontSize: 13)),
                          Text('Lapeace',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A))),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Kartu Saldo Utama (Monochrome Slate Gradient)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withAlpha(120),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sisa Saldo',
                            style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.shield_outlined,
                                  color: Color(0xFF10B981), size: 14),
                              SizedBox(width: 4),
                              Text('Aktif',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatRupiah(sisaSaldo),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.white.withAlpha(30)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFF10B981),
                                child: Icon(Icons.arrow_downward,
                                    size: 14, color: Colors.white)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pemasukan',
                                    style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                                Text(formatRupiah(totalPemasukan),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        Container(
                            height: 24,
                            width: 1,
                            color: Colors.white.withAlpha(30)),
                        Row(
                          children: [
                            const CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFFEF4444),
                                child: Icon(Icons.arrow_upward,
                                    size: 14, color: Colors.white)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pengeluaran',
                                    style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                                Text(formatRupiah(totalPengeluaran),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: _bukaTambahPengeluaran,
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: const Text('Catat Transaksi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Kategori
              const Text('Kategori',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A))),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: kategoriList
                      .map((item) => KategoriCard(
                            nama: item['nama'] as String,
                            ikon: item['ikon'] as IconData,
                            warnaIkon: item['warnaIkon'] as Color,
                            warnaBg: item['warnaBg'] as Color,
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 28),

              // Header Riwayat & Filter
              // Header Riwayat & Filter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Transaksi',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: ['Hari', 'Minggu', 'Bulan'].map((filter) {
                        bool isSelected = selectedFilter == filter;
                        return GestureDetector(
                          onTap: () => setState(() => selectedFilter = filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF0F172A)
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // List Riwayat dengan Header Total Harian
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: groupedData.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                            child: Text('Belum ada riwayat transaksi.',
                                style: TextStyle(color: Colors.grey))),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: groupedData.entries.map((entry) {
                          double totalHarian =
                              _hitungTotalHarian(entry.value);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Tanggal + Total Harian
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 14, 16, 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    if (totalHarian > 0)
                                      Text(
                                        formatRupiah(totalHarian, isMinus: true),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              ...entry.value.map((tx) {
                                int originalIdx = riwayatList.indexOf(tx);

                                return RiwayatTile(
                                  judul: tx.judul,
                                  subjudul:
                                      '${tx.kategori} • ${tx.jamFormatted}',
                                  nominal: formatRupiah(tx.nominal,
                                      isMinus: tx.isPengeluaran),
                                  ikon: tx.ikon,
                                  warnaIkon: tx.warnaIkon,
                                  warnaBg: tx.warnaBg,
                                  onDelete: () =>
                                      _hapusDenganUndo(tx, originalIdx),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}