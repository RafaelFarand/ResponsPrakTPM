import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _ratingController = TextEditingController();
  final _imgUrlController = TextEditingController();
  final _genreController = TextEditingController();
  final _directorController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _movieUrlController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final movie = Movie(
        id: null, // ID akan di-generate oleh API
        title: _titleController.text,
        year: _yearController.text,
        rating: double.parse(_ratingController.text),
        imgUrl: _imgUrlController.text,
        genre: _genreController.text,
        director: _directorController.text,
        synopsis: _synopsisController.text,
        movieUrl: _movieUrlController.text,
      );

      bool success = await ApiService.createMovie(movie);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Film berhasil ditambahkan'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menambahkan film'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Film'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Film',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul film tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Tahun Rilis',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tahun rilis tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Tahun harus berupa angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(
                labelText: 'Rating (0-10)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Rating tidak boleh kosong';
                }
                double? rating = double.tryParse(value);
                if (rating == null) {
                  return 'Rating harus berupa angka';
                }
                if (rating < 0 || rating > 10) {
                  return 'Rating harus antara 0-10';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _imgUrlController,
              decoration: const InputDecoration(
                labelText: 'URL Gambar',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'URL gambar tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _genreController,
              decoration: const InputDecoration(
                labelText: 'Genre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Genre tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _directorController,
              decoration: const InputDecoration(
                labelText: 'Sutradara',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sutradara tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _synopsisController,
              decoration: const InputDecoration(
                labelText: 'Sinopsis',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sinopsis tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _movieUrlController,
              decoration: const InputDecoration(
                labelText: 'URL Info Film',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'URL info film tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan Film',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}