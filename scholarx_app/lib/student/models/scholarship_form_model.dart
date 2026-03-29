/// Model รวม state ทั้งหมดของฟอร์มสมัครทุน
class ScholarshipFormModel {
  // Step 1 — Personal
  String studentId;
  String fullName;
  String phone;
  String email;
  String address;

  // Step 2 — Family / Father
  String fatherName;
  String fatherPhone;
  String? fatherJob;
  String? fatherIncome;

  // Step 2 — Family / Mother
  String motherName;
  String motherPhone;
  String? motherJob;
  String? motherIncome;

  // Step 2 — Family status
  String? familyStatus;
  String? siblings;
  String? siblingOrder;
  String? applicantIncome;
  String? familyIncome;
  String familyNote;

  // Step 3 — Guardian
  String guardianName;
  String? guardianRelation;
  String guardianPhone;
  String? guardianJob;
  String? guardianIncome;

  // Step 4 — Documents (file names / paths)
  String? idCardFile;
  String? photoFile;
  String? transcriptFile;
  String? bankBookFile;

  ScholarshipFormModel({
    this.studentId    = '',
    this.fullName     = '',
    this.phone        = '',
    this.email        = '',
    this.address      = '',
    this.fatherName   = '',
    this.fatherPhone  = '',
    this.fatherJob,
    this.fatherIncome,
    this.motherName   = '',
    this.motherPhone  = '',
    this.motherJob,
    this.motherIncome,
    this.familyStatus,
    this.siblings,
    this.siblingOrder,
    this.applicantIncome,
    this.familyIncome,
    this.familyNote   = '',
    this.guardianName = '',
    this.guardianRelation,
    this.guardianPhone = '',
    this.guardianJob,
    this.guardianIncome,
    this.idCardFile,
    this.photoFile,
    this.transcriptFile,
    this.bankBookFile,
  });

  /// Copy with overrides
  ScholarshipFormModel copyWith({
    String? studentId, String? fullName, String? phone,
    String? email, String? address,
    String? fatherName, String? fatherPhone,
    String? fatherJob, String? fatherIncome,
    String? motherName, String? motherPhone,
    String? motherJob, String? motherIncome,
    String? familyStatus, String? siblings, String? siblingOrder,
    String? applicantIncome, String? familyIncome, String? familyNote,
    String? guardianName, String? guardianRelation,
    String? guardianPhone, String? guardianJob, String? guardianIncome,
    String? idCardFile, String? photoFile,
    String? transcriptFile, String? bankBookFile,
  }) {
    return ScholarshipFormModel(
      studentId:        studentId        ?? this.studentId,
      fullName:         fullName         ?? this.fullName,
      phone:            phone            ?? this.phone,
      email:            email            ?? this.email,
      address:          address          ?? this.address,
      fatherName:       fatherName       ?? this.fatherName,
      fatherPhone:      fatherPhone      ?? this.fatherPhone,
      fatherJob:        fatherJob        ?? this.fatherJob,
      fatherIncome:     fatherIncome     ?? this.fatherIncome,
      motherName:       motherName       ?? this.motherName,
      motherPhone:      motherPhone      ?? this.motherPhone,
      motherJob:        motherJob        ?? this.motherJob,
      motherIncome:     motherIncome     ?? this.motherIncome,
      familyStatus:     familyStatus     ?? this.familyStatus,
      siblings:         siblings         ?? this.siblings,
      siblingOrder:     siblingOrder     ?? this.siblingOrder,
      applicantIncome:  applicantIncome  ?? this.applicantIncome,
      familyIncome:     familyIncome     ?? this.familyIncome,
      familyNote:       familyNote       ?? this.familyNote,
      guardianName:     guardianName     ?? this.guardianName,
      guardianRelation: guardianRelation ?? this.guardianRelation,
      guardianPhone:    guardianPhone    ?? this.guardianPhone,
      guardianJob:      guardianJob      ?? this.guardianJob,
      guardianIncome:   guardianIncome   ?? this.guardianIncome,
      idCardFile:       idCardFile       ?? this.idCardFile,
      photoFile:        photoFile        ?? this.photoFile,
      transcriptFile:   transcriptFile   ?? this.transcriptFile,
      bankBookFile:     bankBookFile     ?? this.bankBookFile,
    );
  }
}
