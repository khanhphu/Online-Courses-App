import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_courses/models/courses.dart';

// Import course model ở đây
// import '../models/course.dart';

class ApiService {
  // Thay đổi URL này thành URL MockAPI của bạn
  static const String baseUrl =
      "https://68886162adf0e59551b9b66d.mockapi.io/istudy/courses";
  static const String coursesEndpoint = '$baseUrl/courses';

  // Lấy danh sách tất cả khóa học
  static Future<List<Courses>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse(coursesEndpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Courses.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  // Lấy khóa học theo ID
  static Future<Courses> getCourseById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$coursesEndpoint/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return Courses.fromJson(data);
      } else {
        throw Exception('Failed to load course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching course: $e');
    }
  }

  // Tìm kiếm khóa học theo tên
  static Future<List<Courses>> searchCourses(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$coursesEndpoint?search=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Courses.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching courses: $e');
    }
  }

  // // Thêm khóa học mới
  // static Future<Courses> createCourse(Courses course) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(coursesEndpoint),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(course.toJson()),
  //     );

  //     if (response.statusCode == 201) {
  //       Map<String, dynamic> data = json.decode(response.body);
  //       return Courses.fromJson(data);
  //     } else {
  //       throw Exception('Failed to create course: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error creating course: $e');
  //   }
  // }

  // // Cập nhật khóa học
  // static Future<Course> updateCourse(String id, Course course) async {
  //   try {
  //     final response = await http.put(
  //       Uri.parse('$coursesEndpoint/$id'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode(course.toJson()),
  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = json.decode(response.body);
  //       return Course.fromJson(data);
  //     } else {
  //       throw Exception('Failed to update course: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error updating course: $e');
  //   }
  // }

  // // Xóa khóa học
  // static Future<void> deleteCourse(String id) async {
  //   try {
  //     final response = await http.delete(
  //       Uri.parse('$coursesEndpoint/$id'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to delete course: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error deleting course: $e');
  //   }
  // }
}
