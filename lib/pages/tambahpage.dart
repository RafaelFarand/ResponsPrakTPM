import 'dart:io';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class TambahPage extends StatefulWidget {
  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final yearController = TextEditingController();
  final ratingController = TextEditingController();
  final genreController = TextEditingController();
  final synopsisController = TextEditingController();
  final directorController = TextEditingController();



  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    double? rating = double.tryParse(ratingController.text.trim());
    if (rating == null || rating < 0.0 || rating > 5.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Rating harus berupa angka antara 0.0 dan 5.0")),
      );
      return;
    }
    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    Movie movie = Movie(
      title: titleController.text.trim(),
      year: yearController.text.trim(),
      rating: ratingController.text.trim(),
      genre: genreController.text.split(',').map((e) => e.trim()).toList(),
      synopsis: synopsisController.text.trim(),
      director: directorController.text.trim(), id: '', imgUrl: '', movieUrl: '',

 

  
    );

    try {
      await MovieService.addMovie(movie);
      Navigator.pop(context); // Tutup loading
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya
    } catch (e) {
      Navigator.pop(context); // Tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan data")),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    yearController.dispose();
    ratingController.dispose();
    genreController.dispose();
    synopsisController.dispose();
    directorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Data Film")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8),

              buildTextField(titleController, "Judul"),
              buildTextField(yearController, "tahun rilis"),
              buildTextField(ratingController, "Rating (0.0 - 5.0)", number: true),
              buildTextField(genreController, "Genre (pisahkan dengan koma)"),
              buildTextField(synopsisController, "sinopsis"),
              buildTextField(directorController, "Sutradara"),
          

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveData,
                child: Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(labelText: label),
        validator: (val) => val == null || val.trim().isEmpty ? "$label harus diisi" : null,
      ),
    );
  }
}
