import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_courses/helpers/custom_format.dart';
import 'package:online_courses/models/courses.dart';

class CourseDetailScreen extends StatefulWidget {
  final int id;

  const CourseDetailScreen({super.key, this.id = 2});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Courses? course;
  bool isLoading = true;
  bool hasError = false;
  bool isEnrolled = false;

  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  Future<void> fetchCourseData() async {
    try {
      // First try to get specific course by ID
      final response = await http.get(
        Uri.parse(
          'https://68886162adf0e59551b9b66d.mockapi.io/istudy/courses/courses/?id=${widget.id}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          course = Courses.fromJson(data);
          isLoading = false;
        });
      } else {
        // If direct ID fetch fails, try filtering by ID
        await fetchCourseByFilter();
      }
    } catch (e) {
      // If direct fetch fails, try filtering approach
      await fetchCourseByFilter();
    }
  }

  Future<void> fetchCourseByFilter() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://68886162adf0e59551b9b66d.mockapi.io/istudy/courses/courses/?id=${widget.id}',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final courseData = data.firstWhere(
          (course) => course['id'] == widget.id,
          orElse: () => null,
        );

        if (courseData != null) {
          setState(() {
            course = Courses.fromJson(courseData);
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF6C5CE7),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (hasError || course == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF6C5CE7),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Failed to load course',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    hasError = false;
                  });
                  fetchCourseData();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF6C5CE7),
      body: CustomScrollView(
        slivers: [
          // App Bar with course image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF6C5CE7),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                  ),
                ),
                child:
                    course!.img.isNotEmpty
                        ? Image.network(
                          course!.img,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF5A4FCF),
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                                size: 64,
                              ),
                            );
                          },
                        )
                        : Container(
                          color: const Color(0xFF5A4FCF),
                          child: const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
              ),
            ),
          ),

          // Course content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course title and category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course!.category.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF6C5CE7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      course!.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Text(
                    //   'by ${course!.instructor}',
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     color: Color(0xFF718096),
                    //   ),
                    // ),
                    const SizedBox(height: 24),

                    // Course stats
                    Row(
                      children: [
                        //    _buildStatItem(Icons.star, course!.rating.toString(), Colors.amber),
                        const SizedBox(width: 24),
                        _buildStatItem(
                          Icons.people,
                          '${course!.members}',
                          const Color(0xFF6C5CE7),
                        ),
                        const SizedBox(width: 24),
                        _buildStatItem(
                          Icons.access_time,
                          course!.exp.toString(),
                          const Color(0xFF48BB78),
                        ),
                        const SizedBox(width: 24),
                        // _buildStatItem(Icons.signal_cellular_alt, course!.level, const Color(0xFFED8936)),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Description
                    const Text(
                      'Thông tin khóa học',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course!.desc,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4A5568),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Topics covered
                    // if (course!.topics.isNotEmpty) ...[
                    //   const Text(
                    //     'What You\'ll Learn',
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.bold,
                    //       color: Color(0xFF2D3748),
                    //     ),
                    //   ),
                    //   const SizedBox(height: 16),
                    //   ...course!.topics.map((topic) => Padding(
                    //     padding: const EdgeInsets.only(bottom: 12),
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Container(
                    //           margin: const EdgeInsets.only(top: 6),
                    //           width: 8,
                    //           height: 8,
                    //           decoration: const BoxDecoration(
                    //             color: Color(0xFF6C5CE7),
                    //             shape: BoxShape.circle,
                    //           ),
                    //         ),
                    //         const SizedBox(width: 16),
                    //         Expanded(
                    //           child: Text(
                    //             topic,
                    //             style: const TextStyle(
                    //               fontSize: 16,
                    //               color: Color(0xFF4A5568),
                    //               height: 1.5,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   )).toList(),
                    //   const SizedBox(height: 32),
                    // ],

                    // Price and enroll button
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Giá',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF718096),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course!.price > 0
                                    ? formatCurrency(course!.price)
                                    : 'Học thử',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C5CE7),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEnrolled = !isEnrolled;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isEnrolled
                                      ? const Color(0xFF48BB78)
                                      : const Color(0xFF6C5CE7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isEnrolled ? 'Học tiếp' : 'Đăng ký ngay',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5568),
          ),
        ),
      ],
    );
  }
}
