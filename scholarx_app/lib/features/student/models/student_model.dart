class StudentModel {
  final String id;
  final String studentId;
  final String fullName;
  final String faculty;
  final String major;
  final double gpa;
  final String? avatarUrl;
  final String email;

  const StudentModel({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.faculty,
    required this.major,
    required this.gpa,
    this.avatarUrl,
    required this.email,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      fullName: json['fullName'] as String,
      faculty: json['faculty'] as String,
      major: json['major'] as String,
      gpa: (json['gpa'] as num).toDouble(),
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'fullName': fullName,
    'faculty': faculty,
    'major': major,
    'gpa': gpa,
    'avatarUrl': avatarUrl,
    'email': email,
  };

  // Mock data for development
  static StudentModel get mock => const StudentModel(
    id: 'usr_001',
    studentId: '663040127-7',
    fullName: 'ธนวัตน์ ประเสริฐ',
    faculty: 'วิศวกรรมศาสตร์',
    major: 'วิศวกรรมคอมพิวเตอร์',
    gpa: 3.85,
    email: 'thanawat@kkumail.com',
  );
}
