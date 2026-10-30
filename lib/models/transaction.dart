import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final String judul;
  final String kategori;
  final DateTime date;
  final double nominal;
  final bool isPengeluaran;
  final IconData ikon;
  final Color warnaIkon;
  final Color warnaBg;

  const TransactionModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.date,
    required this.nominal,
    this.isPengeluaran = true,
    required this.ikon,
    required this.warnaIkon,
    required this.warnaBg,
  });

  String get jamFormatted {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h.$m';
  }
}