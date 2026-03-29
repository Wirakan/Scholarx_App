import '/student/models/student_model.dart';

// mock data and helpers used throughout the student screens

/// dummy student (used in home tab)
final StudentModel mockStudent = StudentModel.mock;

/// example scholarships shown on the home tab
///
/// kept in the model file so that the data can be reused by multiple
/// widgets/screens without duplicating the list.  Fields that are only
/// required for the detail page have default values, allowing callers
/// to continue constructing items with the same arguments used in the
/// original sample list.
const List<ScholarshipCardItem> mockScholarships = [
  ScholarshipCardItem(
    id: 'sch_001',
    title: 'ทุนการศึกษาเพื่อความเป็นเลิศทางวิชาการ',
    category: 'สำหรับนักศึกษาระดับปริญญาตรี',
    categoryColor: '#E8591A',
    description:
        'สนับสนุนค่าเล่าเรียนและค่าครองชีพ สำหรับนักศึกษาที่มีผลการเรียนดี และมีความประพฤติดี',
    updatedAt: '1 ม.ค. 2569',
  ),
  ScholarshipCardItem(
    id: 'sch_002',
    title: 'ประกาศผลผู้ได้รับทุน รอบที่ 1',
    category: 'ประจำปีการศึกษา 2569',
    categoryColor: '#E8591A',
    description:
        'ผู้สมัครสามารถตรวจสอบรายชื่อผู้ได้รับทุนและขั้นตอนต่อไปได้ในแอป',
    updatedAt: '1 ม.ค. 2569',
  ),
  ScholarshipCardItem(
    id: 'sch_003',
    title: 'ทุนด้านเทคโนโลยีดิจิทัล',
    category: 'ทุนเฉพาะทาง Digital / IT / Engineering',
    categoryColor: '#E8591A',
    description:
        'มอบทุนให้แก่นักศึกษาที่มีความสนใจด้านเทคโนโลยี นวัตกรรม และการพัฒนาดิจิทัล',
    updatedAt: '1 ม.ค. 2569',
    // additional detail fields used by the detail screen
    level: 'ปริญญาตรี',
    relatedFields: [
      'เทคโนโลยีสารสนเทศ',
      'วิศวกรรมคอมพิวเตอร์',
      'วิทยาการคอมพิวเตอร์',
      'ดิจิทัลมีเดีย / AI / Data',
    ],
    benefits: [
      'ทุนการศึกษาสูงสุด 10,000 บาท / ปีการศึกษา',
      'สนับสนุนค่าเรียนและอุปกรณ์ด้านเทคโนโลยี',
      'เข้าร่วมกิจกรรมพัฒนาทักษะดิจิทัล',
    ],
    applyPeriod: '1 ก.พ. – 31 มี.ค. 2569',
    qualifications: [
      'เป็นนักศึกษาระดับปริญญาตรี',
      'กำลังศึกษาในสาขาที่เกี่ยวข้องกับเทคโนโลยีดิจิทัล',
      'เกรดเฉลี่ยสะสม ไม่ต่ำกว่า 2.75',
      'มีความสนใจหรือผลงานด้านเทคโนโลยีดิจิทัล',
    ],
    requiredDocuments: [
      'สำเนาบัตรประจำตัวประชาชน',
      'รูปถ่ายหน้าตรง (พื้นหลังสุภาพ)',
      'ใบแสดงผลการเรียน (Transcript)',
      'สำเนาสมุดบัญชีธนาคาร',
    ],
  ),
];

class ScholarshipCardItem {
  final String id;

  // Header
  final String title;
  final String category;
  final String categoryColor;

  // Content (เดิม)
  final String description;
  final String updatedAt;

  // Detail sections (ใหม่)
  final String level; // ระดับการศึกษา
  final List<String> relatedFields; // สาขาที่เกี่ยวข้อง
  final List<String> benefits; // สิทธิประโยชน์
  final String applyPeriod; // ระยะเวลารับสมัคร
  final List<String> qualifications; // คุณสมบัติ
  final List<String> requiredDocuments; // เอกสารที่ต้องใช้

  const ScholarshipCardItem({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.description,
    required this.updatedAt,
    this.level = '',
    this.relatedFields = const [],
    this.benefits = const [],
    this.applyPeriod = '',
    this.qualifications = const [],
    this.requiredDocuments = const [],
  });
}
