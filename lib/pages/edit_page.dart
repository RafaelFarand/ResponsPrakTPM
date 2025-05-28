import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class EditPage extends StatelessWidget {
  final Movie movie;
  EditPage({required this.movie});

  final _formKey = GlobalKey<FormState>();

  late final titleController = TextEditingController(text: movie.title);
  late final yearController = TextEditingController(text: movie.year.toString());
  late final ratingController = TextEditingController(text: movie.rating.toString());
  late final websiteController = TextEditingController(text: movie.website);

  void updateMovie(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final updatedMovie = Movie(
        id: movie.id,
        title: titleController.text,
        year: int.parse(yearController.text),
        rating: double.parse(ratingController.text),
        website: websiteController.text,
      );

      await ApiService.updateMovie(movie.id!, updatedMovie);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text('Edit Movie'),
        backgroundColor: Colors.pink,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Movie Info',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade700,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: titleController,
                label: 'Title',
                icon: Icons.movie,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: yearController,
                label: 'Year',
                icon: Icons.date_range,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: ratingController,
                label: 'Rating',
                icon: Icons.star,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: websiteController,
                label: 'Website URL',
                icon: Icons.link,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => updateMovie(context),
                  icon: Icon(Icons.save),
                  label: Text('Update Movie'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
