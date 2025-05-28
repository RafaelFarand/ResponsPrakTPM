import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class CreatePage extends StatefulWidget {
  final Movie? movie; // If provided, this is edit mode

  const CreatePage({Key? key, this.movie}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _genreController = TextEditingController();
  final _directorController = TextEditingController();
  final _ratingController = TextEditingController();
  final _synopsisController = TextEditingController();

  bool _isLoading = false;
  bool get isEditMode => widget.movie != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final movie = widget.movie!;
      _titleController.text = movie.title;
      _yearController.text = movie.year.toString();
      _genreController.text = movie.genre ?? '';
      _directorController.text = movie.director ?? '';
      _ratingController.text = movie.rating.toString();
      _synopsisController.text = movie.synopsis ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _directorController.dispose();
    _ratingController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  Future<void> _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final movie = Movie(
          id: isEditMode ? widget.movie!.id : null,
          title: _titleController.text.trim(),
          year: int.parse(_yearController.text.trim()),
          genre: _genreController.text.trim().isEmpty ? null : _genreController.text.trim(),
          director: _directorController.text.trim().isEmpty ? null : _directorController.text.trim(),
          rating: double.parse(_ratingController.text.trim()),
          synopsis: _synopsisController.text.trim().isEmpty ? null : _synopsisController.text.trim(),
        );

        bool success;
        if (isEditMode) {
          success = await ApiService.updateMovie(widget.movie!.id!, movie);
        } else {
          success = await ApiService.createMovie(movie);
        }

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditMode ? 'Movie updated successfully' : 'Movie created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditMode ? 'Failed to update movie' : 'Failed to create movie'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon) : null,
          ),
          validator: validator,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Movie' : 'Add New Movie'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Movie Title *',
                icon: Icons.movie,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter movie title';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _yearController,
                label: 'Release Year *',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter release year';
                  }
                  final year = int.tryParse(value.trim());
                  if (year == null) return 'Please enter a valid year';
                  if (year < 1900 || year > DateTime.now().year + 5) {
                    return 'Year must be between 1900 and ${DateTime.now().year + 5}';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _genreController,
                label: 'Genre',
                icon: Icons.category,
                hint: 'e.g. Action, Drama',
              ),
              _buildTextField(
                controller: _directorController,
                label: 'Director',
                icon: Icons.person,
              ),
              _buildTextField(
                controller: _ratingController,
                label: 'Rating (0-10) *',
                icon: Icons.star,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter rating';
                  }
                  final rating = double.tryParse(value.trim());
                  if (rating == null) return 'Please enter a valid rating';
                  if (rating < 0 || rating > 10) {
                    return 'Rating must be between 0 and 10';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _synopsisController,
                label: 'Synopsis',
                icon: Icons.description,
                maxLines: 4,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMovie,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEditMode ? 'Update Movie' : 'Create Movie',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              SizedBox(height: 12),
              Card(
                color: Colors.pink.shade50,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.pink),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Fields marked with * are required',
                          style: TextStyle(color: Colors.pink.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
