import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class EditPage extends StatefulWidget {
  final Movie movie;

  const EditPage({super.key, required this.movie});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _yearController;
  late TextEditingController _ratingController;
  late TextEditingController _imgUrlController;
  late TextEditingController _genreController;
  late TextEditingController _directorController;
  late TextEditingController _synopsisController;
  late TextEditingController _movieUrlController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie.title ?? '');
    _yearController = TextEditingController(text: widget.movie.year ?? '');
    _ratingController = TextEditingController(text: widget.movie.rating?.toString() ?? '');
    _imgUrlController = TextEditingController(text: widget.movie.imgUrl ?? '');
    _genreController = TextEditingController(text: widget.movie.genre ?? '');
    _directorController = TextEditingController(text: widget.movie.director ?? '');
    _synopsisController = TextEditingController(text: widget.movie.synopsis ?? '');
    _movieUrlController = TextEditingController(text: widget.movie.movieUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _ratingController.dispose();
    _imgUrlController.dispose();
    _genreController.dispose();
    _directorController.dispose();
    _synopsisController.dispose();
    _movieUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateMovie() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final movie = Movie(
        id: widget.movie.id,
        title: _titleController.text,
        year: _yearController.text,
        rating: double.parse(_ratingController.text),
        imgUrl: _imgUrlController.text,
        genre: _genreController.text,
        director: _directorController.text,
        synopsis: _synopsisController.text,
        movieUrl: _movieUrlController.text,
      );

      bool success = await ApiService.updateMovie(widget.movie.id ?? '', movie);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Film berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal memperbarui film'),
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
        title: const Text('Edit Film'),
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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                onPressed: _isLoading ? null : _updateMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Update Film',
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