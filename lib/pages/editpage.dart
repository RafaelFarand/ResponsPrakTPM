import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class EditPage extends StatefulWidget {
  final Movie movie;
  const EditPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController titleController;
  late TextEditingController yearController;
  late TextEditingController ratingController;
  late TextEditingController genreController;
  late TextEditingController sypnosisController;
  late TextEditingController directorController;


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.movie.title);
    yearController = TextEditingController(text: widget.movie.year);
    ratingController = TextEditingController(text: widget.movie.rating.toString());
    genreController = TextEditingController(text: widget.movie.genre.join(', '));
    sypnosisController = TextEditingController(text: widget.movie.synopsis);
    directorController = TextEditingController(text: widget.movie.director);
  }


  Future<void> saveData() async {
    final updatedMovie = Movie(
      id: widget.movie.id,
      title: titleController.text.trim(),
      year: yearController.text.trim(),
      genre: genreController.text.split(',').map((e) => e.trim()).toList(),
      synopsis: sypnosisController.text.trim(),
      director: directorController.text.trim(), imgUrl: '', rating: '', movieUrl: '',
    );

    try {
      final result = await MovieService.updateMovie(updatedMovie); // implementasi di service
      if (result == true) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan perubahan")),
        );
      }
    } catch (e) {
      print("Error saat update: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi error saat menyimpan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Film")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
           
            buildTextField(titleController, "Judul"),
            buildTextField(yearController, "Tanggal Rilis (yyyy-mm-dd)"),
            buildTextField(ratingController, "Rating (0.0 - 5.0)", number: true),
            buildTextField(genreController, "Genre (pisahkan dengan koma)"),
            buildTextField(sypnosisController, "Deskripsi"),
            buildTextField(directorController, "Sutradara"),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveData,
              child: Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
