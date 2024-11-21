import 'dart:io';
import 'package:bookapp/common/api.dart';
import 'package:bookapp/common/color_extenstion.dart';
import 'package:bookapp/common/validator_form.dart';
import 'package:bookapp/common_widget/round_button.dart';
import 'package:bookapp/common_widget/round_textfield.dart';
import 'package:bookapp/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final ValidatorController validatorController = ValidatorController();
  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtCity = TextEditingController();
  File? _selectedImage;
  String? usernameError;
  String? cityError;
  bool _isUploading = false;

  // Image Picker
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Upload Image and Update Profile
  Future<void> _updateProfile() async {
    setState(() {
      _isUploading = true;
    });

    // Validate fields
    usernameError = validatorController.validateUsername(txtUserName.text);
    cityError = validatorController.validateCity(txtCity.text);

    setState(() {}); // Update error messages on UI

    // Proceed only if there are no validation errors
    if (usernameError == null && cityError == null) {
      final response = await ApiService.updateProfile(
      //  id: 'your_user_id', // Replace with actual user ID
        username: txtUserName.text.trim(),
        city: txtCity.text.trim(),
        profileImage: _selectedImage,
      );

      setState(() {
        _isUploading = false;
      });

      if (response['status'] == 'success') {
        // Show success message and navigate to AccountView
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainTabView(),
            ),
          );
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to update profile')),
        );
      }
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: TColor.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(
                  color: TColor.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              RoundTextField(
                controller: txtUserName,
                hintText: "Enter name",
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.person, color: TColor.text),
                ),
                onChanged: (value) {},
                
              ),
              if (usernameError != null)
                Text(
                  usernameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 25),
              RoundTextField(
                controller: txtCity,
                hintText: "Enter city name",
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.home, color: TColor.text),
                ),
                onChanged: (value) {},
              ),
              if (cityError != null)
                Text(
                  cityError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _pickImage,
                child: const Center(
                  child: Text(
                    'Select Profile Picture',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              if (_selectedImage != null)
                Column(
                  children: [
                    Image.file(
                      _selectedImage!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 15),
                    _isUploading
                        ? CircularProgressIndicator()
                        : RoundLineButton(
                            title: "Upload Image",
                            onPressed: _updateProfile,
                          ),
                  ],
                ),
              const SizedBox(height: 25),
              RoundLineButton(
                title: "Save",
                onPressed: _updateProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
