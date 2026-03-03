class Applicant {
  final String id;
  final String name;
  final String studentId;
  final String scholarship;
  final String faculty;
  final String major;
  final String year;
  final double gpa;
  final String address;
  final String email;
  final String date;
  final String status;
  final String reason;

  const Applicant({
    required this.id,
    required this.name,
    required this.studentId,
    required this.scholarship,
    required this.faculty,
    required this.major,
    required this.year,
    required this.gpa,
    required this.address,
    required this.email,
    required this.date,
    required this.status,
    required this.reason,
  });
}

final mockApplicants = [
  const Applicant(
    id: 'AP011003',
    name: 'สมชาย สุดประเสริฐ',
    studentId: '660101234-5',
    scholarship: 'ทุนด้านเทคโนโลยีดิจิทัล',
    faculty: 'วิศวกรรมศาสตร์',
    major: 'วิศวกรรมคอมพิวเตอร์',
    year: 'ปี 3',
    gpa: 3.45,
    address: '120 ถ.ชาตะผดุง ต.ในเมือง อ.เมือง จ.ขอนแก่น 40000',
    email: 'somchai.p@kkumail.com',
    date: '20 ม.ค. 2569',
    status: 'รอดำเนินการ',
    reason: 'ต้องการทุนการศึกษาเพื่อพัฒนาโครงการด้านวิศวกรรมซอฟต์แวร์และลดภาระค่าใช้จ่ายของครอบครัว รวมถึงต้องการเวลาในการเรียนและทำกิจกรรมวิชาการมากขึ้น',
  ),
  const Applicant(
    id: 'AP011004',
    name: 'สมหมาย ครองชัย',
    studentId: '660201567-8',
    scholarship: 'ทุนรักษาเกณฑ์โอวาส603ลิน',
    faculty: 'วิทยาศาสตร์',
    major: 'คณิตศาสตร์',
    year: 'ปี 2',
    gpa: 3.80,
    address: '45 ถ.มิตรภาพ ต.สาวะถี อ.เมือง จ.ขอนแก่น 40000',
    email: 'sommai.k@kkumail.com',
    date: '19 ม.ค. 2569',
    status: 'รอดำเนินการ',
    reason: 'มีความตั้งใจในการศึกษาและต้องการพัฒนาทักษะด้านคณิตศาสตร์ประยุกต์เพื่อนำไปใช้ในการวิจัย',
  ),
  const Applicant(
    id: 'AP011005',
    name: 'วิภาวดี รักเรียน',
    studentId: '660301890-1',
    scholarship: 'ทุนด้านเทคโนโลยีดิจิทัล',
    faculty: 'เทคโนโลยีสารสนเทศ',
    major: 'วิทยาการคอมพิวเตอร์',
    year: 'ปี 4',
    gpa: 3.92,
    address: '78 ถ.กลางเมือง ต.พระลับ อ.เมือง จ.ขอนแก่น 40000',
    email: 'wipawadee.r@kkumail.com',
    date: '18 ม.ค. 2569',
    status: 'กำลังพิจารณา',
    reason: 'ต้องการสนับสนุนการพัฒนาโครงการ AI สำหรับการศึกษาพิเศษ',
  ),
  const Applicant(
    id: 'AP011006',
    name: 'ธนกร พัฒนา',
    studentId: '650401234-9',
    scholarship: 'ทุนเอกลักษณ์',
    faculty: 'บริหารธุรกิจ',
    major: 'การตลาด',
    year: 'ปี 3',
    gpa: 3.21,
    address: '33 ถ.นาเมือง ต.บ้านทุ่ม อ.เมือง จ.ขอนแก่น 40000',
    email: 'thanakorn.p@kkumail.com',
    date: '17 ม.ค. 2569',
    status: 'อนุมัติ',
    reason: 'ต้องการทุนเพื่อสนับสนุนการทำวิจัยด้านการตลาดดิจิทัล',
  ),
  const Applicant(
    id: 'AP011007',
    name: 'นภัสสร จันทร์ดี',
    studentId: '650502345-6',
    scholarship: 'ทุนความสามารถพิเศษ',
    faculty: 'ศิลปกรรมศาสตร์',
    major: 'ออกแบบนิเทศศิลป์',
    year: 'ปี 3',
    gpa: 3.55,
    address: '12 ถ.ราษฎร์คนึง ต.เมืองเก่า อ.เมือง จ.ขอนแก่น 40000',
    email: 'naphasson.j@kkumail.com',
    date: '16 ม.ค. 2569',
    status: 'ปฏิเสธ',
    reason: 'ต้องการทุนเพื่อซื้ออุปกรณ์สร้างสรรค์งานออกแบบและเข้าร่วมการแข่งขันระดับนานาชาติ',
  ),
];