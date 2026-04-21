import 'package:catalog/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Tampilkan list barang yang mau dibeli
            ...cartItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('${item.quantity}x ${item.product.name}'),
                    ),
                    Text(
                      'Rp ${(item.product.price * item.quantity).toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 32, thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${cart.totalPrice.toStringAsFixed(0)}', // [cite: 2016]
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Tombol Simulasi Bayar
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // SIMULASI SUKSES [cite: 2018]
                  // 1. Kosongkan keranjang
                  context.read<CartProvider>().clearCart();

                  // 2. Tampilkan notifikasi sukses
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pembayaran Berhasil! Pesanan diproses.'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // 3. Kembali ke halaman Dashboard
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/dashboard'),
                  );
                },
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
