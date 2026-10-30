import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';

class TransactionNotifier extends Notifier<List<TransactionModel>> {
  final double saldoAwal = 1500000.0;

  @override
  List<TransactionModel> build() {
    final now = DateTime.now();

    return [
      TransactionModel(
        id: '1',
        judul: 'Geprek MRP',
        kategori: 'Food',
        date: DateTime(now.year, now.month, now.day, 7, 30),
        nominal: 15000.0,
        isPengeluaran: true,
        ikon: Icons.restaurant,
        warnaIkon: const Color(0xFFDC143C),
        warnaBg: const Color(0xFFFFE4E1),
      ),
      TransactionModel(
        id: '2',
        judul: 'Gojek ke kampus',
        kategori: 'Transport',
        date: DateTime(now.year, now.month, now.day, 8, 10),
        nominal: 12000.0,
        isPengeluaran: true,
        ikon: Icons.directions_subway,
        warnaIkon: const Color(0xFF228B22),
        warnaBg: const Color(0xFFE8F5E9),
      ),
      TransactionModel(
        id: '3',
        judul: 'Print surat komitmen',
        kategori: 'Campus',
        date: DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 10, minutes: 45)),
        nominal: 3000.0,
        isPengeluaran: true,
        ikon: Icons.menu_book,
        warnaIkon: const Color(0xFF1E3A8A),
        warnaBg: const Color(0xFFE0F2FE),
      ),
      TransactionModel(
        id: '4',
        judul: 'Bayar hutang teman',
        kategori: 'Others',
        date: DateTime(now.year, 10, 1, 12, 15),
        nominal: 5000.0,
        isPengeluaran: true,
        ikon: Icons.grid_view_rounded,
        warnaIkon: const Color(0xFF475569),
        warnaBg: const Color(0xFFF1F5F9),
      ),
    ];
  }

  // Kalkulasi total pengeluaran dinamis
  double get totalPengeluaran => state
      .where((tx) => tx.isPengeluaran)
      .fold(0.0, (sum, item) => sum + item.nominal);

  // Kalkulasi total pemasukan dinamis
  double get totalPemasukan =>
      saldoAwal +
      state
          .where((tx) => !tx.isPengeluaran)
          .fold(0.0, (sum, item) => sum + item.nominal);

  double get sisaSaldo => totalPemasukan - totalPengeluaran;

  void addTransaction(TransactionModel tx) {
    state = [tx, ...state];
  }

  void insertTransactionAt(int index, TransactionModel tx) {
    final list = List<TransactionModel>.from(state);
    if (index >= 0 && index <= list.length) {
      list.insert(index, tx);
      state = list;
    } else {
      state = [...state, tx];
    }
  }

  void deleteTransaction(String id) {
    state = state.where((tx) => tx.id != id).toList();
  }
}

final transactionProvider =
    NotifierProvider<TransactionNotifier, List<TransactionModel>>(
  TransactionNotifier.new,
);