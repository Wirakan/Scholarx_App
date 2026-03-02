enum ScholarshipCategory { all, bachelor, research, assistance, innovation }

extension ScholarshipCategoryLabel on ScholarshipCategory {
  String get label {
    switch (this) {
      case ScholarshipCategory.all:
        return 'ทั้งหมด';
      case ScholarshipCategory.bachelor:
        return 'ทุนเรียนดี';
      case ScholarshipCategory.research:
        return 'ทุนวิจัย';
      case ScholarshipCategory.assistance:
        return 'ทุนผู้ช่วย';
      case ScholarshipCategory.innovation:
        return 'ทุนกิจกรรม';
    }
  }
}

class ScholarshipModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String categoryLabel;
  final ScholarshipCategory category;
  final String deadline;
  final bool isOpen;

  const ScholarshipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.categoryLabel,
    required this.category,
    required this.deadline,
    this.isOpen = true,
  });

  static const List<ScholarshipModel> mockList = [
    ScholarshipModel(
      id: 'sch_001',
      title: 'ทุนการศึกษาเพื่อความเป็นเลิศทางวิชาการ',
      description:
          'สนับสนุนค่าเล่าเรียนและค่าครองชีพ สำหรับนักศึกษาที่มีผลการเรียนดี และมีความประพฤติดี',
      amount: 20000,
      categoryLabel: 'ทุนเรียนดี',
      category: ScholarshipCategory.bachelor,
      deadline: '31 ธ.ค. 2569',
    ),
    ScholarshipModel(
      id: 'sch_002',
      title: 'ทุนด้านเทคโนโลยีดิจิทัล',
      description:
          'มอบทุนให้แก่นักศึกษาที่มีความสนใจด้านเทคโนโลยี นวัตกรรม และการพัฒนาดิจิทัล',
      amount: 10000,
      categoryLabel: 'ทุนเฉพาะทาง Digital / IT / Engineering',
      category: ScholarshipCategory.innovation,
      deadline: '31 ธ.ค. 2569',
    ),
    ScholarshipModel(
      id: 'sch_003',
      title: 'ทุนสนับสนุนนวัตกรรมและเทคโนโลยี',
      description:
          'สนับสนุนใช้จ่ายในการศึกษาค้นคว้าด้านนวัตกรรม โดยการสนับสนุนเครือข่ายกิจการวิจัย',
      amount: 60000,
      categoryLabel: 'ทุนวิจัย',
      category: ScholarshipCategory.research,
      deadline: '10 ก.ค. 2568',
    ),
    ScholarshipModel(
      id: 'sch_004',
      title: 'ทุนผู้รวยเพื่อพัฒนาทักษะวิชาชีพ',
      description:
          'สนับสนุนค่าเล่าเรียนสำหรับนักศึกษาที่ต้องการด้านทักษะวิชาชีพ พร้อมฝึกอบรมทักษะการทำงานวิชาชีพรวมถึงทรัพยากรการเรียน',
      amount: 25000,
      categoryLabel: 'ทุนผู้ช่วย',
      category: ScholarshipCategory.assistance,
      deadline: '20 ก.ค. 2568',
    ),
    ScholarshipModel(
      id: 'sch_005',
      title: 'ทุนพัฒนาผู้นำเยาวชนรุ่นใหม่',
      description:
          'สนับสนุนนักศึกษาที่มีบทบาทความเป็นผู้นำ วิชาภาวะหรือกิจกรรมเพื่อสังคม เพื่อส่งเสริมการเป็นผู้นำที่มีคุณธรรมจริยธรรม',
      amount: 30000,
      categoryLabel: 'ทุนกิจกรรม',
      category: ScholarshipCategory.innovation,
      deadline: '31 ธ.ค. 2568',
    ),
    ScholarshipModel(
      id: 'sch_006',
      title: 'ทุนส่งเสริมโอกาสทางการศึกษา',
      description:
          'นักศึกษาที่ขาดแคลนทุนทรัพย์และมีผลการเรียนดี แต่เข้าร่วมกิจกรรมพัฒนาสังคมอย่างสม่ำเสมอ',
      amount: 40000,
      categoryLabel: 'ขาดแคลนทุนทรัพย์',
      category: ScholarshipCategory.assistance,
      deadline: '15 ก.ค. 2568',
    ),
  ];
}
