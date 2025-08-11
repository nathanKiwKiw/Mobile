import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

// Data Models
class RoomResult {
  final String ruangan, suhu, kelembaban, kebersihan, lampu, note;
  const RoomResult({
    required this.ruangan, 
    required this.suhu, 
    required this.kelembaban,
    required this.kebersihan, 
    required this.lampu, 
    required this.note
  });
}

class EquipmentResult {
  final String equipment, room, tanggal, merk, type, suhu, jenisKabel, kondisi, note;
  const EquipmentResult({
    required this.equipment, 
    required this.room, 
    required this.tanggal,
    required this.merk, 
    required this.type, 
    required this.suhu, 
    required this.jenisKabel, 
    required this.kondisi, 
    required this.note
  });
}

class FormFocPage extends StatefulWidget {
  const FormFocPage({super.key});
  
  @override 
  State<FormFocPage> createState() => _FormFocPageState();
}

class _FormFocPageState extends State<FormFocPage> with SingleTickerProviderStateMixin {
  int currentStep = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Controllers Map
  late final Map<String, TextEditingController> controllers = {
    'unit': TextEditingController(text: 'JAKBAN'),
    'garduInduk': TextEditingController(text: 'GI 150KV GANDUL'),
    'tanggalInspeksi': TextEditingController(text: '2025-08-11'),
    'suhu': TextEditingController(),
    'kelembaban': TextEditingController(),
    'catatan': TextEditingController(),
    'equipment': TextEditingController(),
    'merk': TextEditingController(),
    'type': TextEditingController(),
    'suhuAsset': TextEditingController(),
    'jenisKabel': TextEditingController(),
    'kabelLuar': TextEditingController(),
    'equipmentCatatan': TextEditingController(),
  };

  // State variables
  String? selectedRuangan;
  String? selectedKebersihan;
  String? selectedLampuPenerangan;
  String? selectedKondisiNormal;
  String? selectedJenisKabel = 'ADSS';
  List<RoomResult> roomResults = [];
  List<EquipmentResult> equipmentResults = [];
  List<String> uploadedFiles = [];

  // Constants
  static const List<String> ruanganOptions = ['Pilih Ruangan', 'Ruang PLC', 'Ruang Server', 'Ruang Kontrol', 'Ruang Switch'];
  static const List<String> kebersihanOptions = ['Bersih', 'Kotor'];
  static const List<String> lampuOptions = ['Berfungsi', 'Tidak Berfungsi'];
  static const List<String> kondisiOptions = ['Baik', 'Tidak Baik'];
  static const List<String> jenisKabelOptions = ['ADSS', 'OPGW', 'FA'];
  static const List<String> steps = ['Lokasi & Ruangan', 'Equipment Check', 'Assignment', 'Summary'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => currentStep = index);
                    _animationController.reset();
                    _animationController.forward();
                  },
                  children: [
                    _buildRoomStep(),
                    _buildChecklistStep(),
                    _buildAssignStep(),
                    _buildFinishStep()
                  ],
                ),
              )
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  // Professional AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1E293B),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Form FOC Bulanan L1',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          Text(
            'Fiber Optic Cable Monthly Inspection',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade300, Colors.teal.shade600],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced Step Indicator
  Widget _buildStepIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(steps.length, (index) {
              final isActive = index <= currentStep;
              final isCurrent = index == currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    if (index > 0) 
                      Expanded(
                        child: Container(
                          height: 3.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            color: isActive ? Colors.teal : const Color(0xFFE2E8F0),
                          ),
                        )
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isCurrent ? 40.w : 32.w,
                      height: isCurrent ? 40.h : 32.h,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.teal : const Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                        boxShadow: isCurrent ? [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ] : null,
                      ),
                      child: Center(
                        child: isActive && index < currentStep
                          ? Icon(TablerIcons.check, color: Colors.white, size: 16.sp)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.white : const Color(0xFF64748B),
                                fontSize: isCurrent ? 16.sp : 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),
                    if (index < steps.length - 1) 
                      Expanded(
                        child: Container(
                          height: 3.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            color: index < currentStep ? Colors.teal : const Color(0xFFE2E8F0),
                          ),
                        )
                      ),
                  ],
                )
              );
            }),
          ),
          SizedBox(height: 16.h),
          Row(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCurrent = index == currentStep;
              
              return Expanded(
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isCurrent ? Colors.teal : const Color(0xFF64748B),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Room Step with Professional Design
  Widget _buildRoomStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: 'Informasi Lokasi FOC',
            icon: TablerIcons.map_pin,
            child: Column(
              children: [
                _readOnlyField('Unit Kerja', controllers['unit']!.text),
                SizedBox(height: 16.h),
                _readOnlyField('Gardu Induk', controllers['garduInduk']!.text),
                SizedBox(height: 16.h),
                _dateField('Tanggal Inspeksi', controllers['tanggalInspeksi']!),
              ],
            ),
          ),
          
          SizedBox(height: 20.h),
          
          _buildCard(
            title: 'Kondisi Ruangan',
            icon: TablerIcons.building,
            child: Column(
              children: [
                _dropdown('Pilih Ruangan*', selectedRuangan, ruanganOptions, (value) {
                  setState(() => selectedRuangan = value);
                }),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _textField('Suhu (°C)*', controllers['suhu']!, 
                        isNumeric: true, icon: TablerIcons.thermometer)
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _textField('Kelembaban (%)*', controllers['kelembaban']!, 
                        isNumeric: true, icon: TablerIcons.droplet)
                    ),
                  ]
                ),
                SizedBox(height: 16.h),
                _radioGroup('Status Kebersihan*', selectedKebersihan, kebersihanOptions, (value) {
                  setState(() => selectedKebersihan = value);
                }),
                SizedBox(height: 16.h),
                _radioGroup('Lampu Penerangan*', selectedLampuPenerangan, lampuOptions, (value) {
                  setState(() => selectedLampuPenerangan = value);
                }),
                SizedBox(height: 16.h),
                _textField('Catatan Tambahan', controllers['catatan']!, 
                  maxLines: 3, icon: TablerIcons.notes),
                SizedBox(height: 16.h),
                _fileUploadField('Foto Ruangan*'),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          Center(child: _actionButton(
            'Tambah Data Ruangan', 
            TablerIcons.plus,
            _addRoomRecord,
            isPrimary: true,
          )),
          
          if (roomResults.isNotEmpty) ...[
            SizedBox(height: 24.h),
            _buildCard(
              title: 'Data Ruangan Tersimpan',
              icon: TablerIcons.list,
              child: _buildRoomTable(),
            ),
          ],
        ],
      ),
    );
  }

  // Enhanced Checklist Step
  Widget _buildChecklistStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: 'Informasi Equipment',
            icon: TablerIcons.cpu,
            child: Column(
              children: [
                _dropdown('Lokasi Asset*', selectedRuangan ?? 'Ruang PLC', 
                  roomResults.isNotEmpty ? ['Ruang PLC', ...roomResults.map((r) => r.ruangan)] : ['Ruang PLC'], 
                  (value) => setState(() {})),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _textField('Nama Equipment*', controllers['equipment']!, icon: TablerIcons.device_desktop)),
                    SizedBox(width: 16.w),
                    Expanded(child: _textField('Merk/Brand*', controllers['merk']!, icon: TablerIcons.tag)),
                  ]
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _textField('Tipe/Model*', controllers['type']!, icon: TablerIcons.id)),
                    SizedBox(width: 16.w),
                    Expanded(child: _textField('Suhu Asset (°C)*', controllers['suhuAsset']!, 
                      isNumeric: true, icon: TablerIcons.thermometer)),
                  ]
                ),
                SizedBox(height: 16.h),
                _fileUploadField('Evidence Equipment*'),
              ],
            ),
          ),
          
          SizedBox(height: 20.h),
          
          _buildCard(
            title: 'Inspeksi Fiber Optik',
            icon: TablerIcons.plug_connected,
            child: Column(
              children: [
                _radioGroup('Jenis Kabel*', selectedJenisKabel, jenisKabelOptions, (value) {
                  setState(() => selectedJenisKabel = value);
                }),
                SizedBox(height: 16.h),
                _textField('Identifikasi Kabel Luar', controllers['kabelLuar']!, 
                  icon: TablerIcons.plug_connected),
                SizedBox(height: 16.h),
                _radioGroup('Kondisi Normal*', selectedKondisiNormal, kondisiOptions, (value) {
                  setState(() => selectedKondisiNormal = value);
                }),
                SizedBox(height: 16.h),
                _fileUploadField('Evidence Fiber Optik*'),
              ],
            ),
          ),
          
          SizedBox(height: 20.h),
          
          _buildCard(
            title: 'Catatan Inspeksi',
            icon: TablerIcons.notes,
            child: _textField('Catatan Detail', controllers['equipmentCatatan']!, 
              maxLines: 4, icon: TablerIcons.edit),
          ),
          
          SizedBox(height: 24.h),
          
          Center(child: _actionButton(
            'Tambah Data Equipment', 
            TablerIcons.plus,
            _addEquipmentRecord,
            isPrimary: true,
          )),
          
          if (equipmentResults.isNotEmpty) ...[
            SizedBox(height: 24.h),
            _buildCard(
              title: 'Hasil Pemeriksaan Equipment',
              icon: TablerIcons.clipboard_list,
              child: _buildEquipmentTable(),
            ),
            SizedBox(height: 20.h),
            _buildCard(
              title: 'Lampiran Dokumentasi',
              icon: TablerIcons.photo,
              child: _buildAttachmentTable(),
            ),
          ],
        ],
      ),
    );
  }

  // Professional Assignment Step
  Widget _buildAssignStep() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Expanded(
            child: _buildCard(
              title: 'Penugasan & Approval',
              icon: TablerIcons.user_check,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade50, Colors.teal.shade100],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: Colors.teal,
                          child: Text(
                            'MA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Muhammad Arif',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'Superior / Manager',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Aktif',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showSnackBar('Fitur hapus assignment', Colors.orange),
                          icon: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              TablerIcons.trash, 
                              color: Colors.red.shade600, 
                              size: 18.sp
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    onPressed: () => _showSnackBar('Fitur tambah assignment', Colors.blue),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade50,
                      foregroundColor: Colors.teal,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: Colors.teal.shade300),
                      ),
                    ),
                    icon: Icon(TablerIcons.user_plus, size: 20.sp),
                    label: Text(
                      'Tambah Assignment',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Finish Step
  Widget _buildFinishStep() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    TablerIcons.circle_check, 
                    color: Colors.green, 
                    size: 64.sp
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Inspeksi FOC L1 Selesai!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Form FOC Bulanan Level 1 telah berhasil diselesaikan.\nSemua data telah tersimpan dengan aman.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),
                _buildSummaryStats(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Ruangan', '${roomResults.length}', TablerIcons.building),
          _buildStatItem('Equipment', '${equipmentResults.length}', TablerIcons.cpu),
          _buildStatItem('File', '${uploadedFiles.length}', TablerIcons.photo),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal, size: 24.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // Enhanced Navigation Buttons
  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: _navButton(
                  'Sebelumnya',
                  TablerIcons.arrow_left,
                  Colors.grey[600]!,
                  _previousStep,
                  isSecondary: true,
                ),
              ),
            if (currentStep > 0) SizedBox(width: 16.w),
            Expanded(
              flex: currentStep > 0 ? 1 : 2,
              child: _navButton(
                currentStep < 3 ? 'Selanjutnya' : 'Selesai & Submit',
                currentStep < 3 ? TablerIcons.arrow_right : TablerIcons.check,
                Colors.teal,
                currentStep < 3 ? _nextStep : _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets with Professional Styling
  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: Colors.teal, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller, {
    bool isNumeric = false,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          decoration: _inputDecoration().copyWith(
            prefixIcon: icon != null ? Icon(icon, color: Colors.teal, size: 20.sp) : null,
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, String? value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: value,
          decoration: _inputDecoration(),
          items: options.map((option) => 
            DropdownMenuItem(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: option == 'Pilih Ruangan' ? Colors.grey : const Color(0xFF1E293B),
                ),
              ),
            )
          ).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12.r),
            color: const Color(0xFFF9FAFB),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: _inputDecoration().copyWith(
            prefixIcon: Icon(TablerIcons.calendar, color: Colors.teal, size: 20.sp),
          ),
          onTap: _selectDate,
        ),
      ],
    );
  }

  Widget _radioGroup(String label, String? value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
          ),
          child: Row(
            children: options.map((option) {
              final isSelected = value == option;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(option),
                  child: Container(
                    margin: EdgeInsets.only(right: option != options.last ? 8.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal.shade50 : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected ? Colors.teal : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.teal : const Color(0xFF9CA3AF),
                              width: 2,
                            ),
                            color: isSelected ? Colors.teal : Colors.transparent,
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 6.w,
                                    height: 6.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.teal : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _fileUploadField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            setState(() {
              uploadedFiles.add('${DateTime.now().millisecondsSinceEpoch}.jpg');
            });
            _showSnackBar('File berhasil diupload', Colors.green);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.teal.shade300,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.teal.shade50,
            ),
            child: Column(
              children: [
                Icon(TablerIcons.cloud_upload, color: Colors.teal, size: 32.sp),
                SizedBox(height: 8.h),
                Text(
                  'Klik untuk upload file',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  'JPG, PNG, PDF (Max 10MB)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String text, IconData icon, VoidCallback onPressed, {bool isPrimary = false}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.teal : Colors.teal.shade50,
        foregroundColor: isPrimary ? Colors.white : Colors.teal,
        elevation: isPrimary ? 2 : 0,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: isPrimary ? BorderSide.none : BorderSide(color: Colors.teal.shade300),
        ),
      ),
      icon: Icon(icon, size: 18.sp),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _navButton(String text, IconData icon, Color color, VoidCallback onPressed, {bool isSecondary = false}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary ? Colors.white : color,
        foregroundColor: isSecondary ? color : Colors.white,
        elevation: isSecondary ? 0 : 2,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: isSecondary ? BorderSide(color: color) : BorderSide.none,
        ),
      ),
      icon: Icon(icon, size: 18.sp),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // Enhanced Table Builders
  Widget _buildRoomTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
          columnSpacing: 16.w,
          horizontalMargin: 16.w,
          headingTextStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF374151),
          ),
          dataTextStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF6B7280),
          ),
          columns: [
            const DataColumn(label: Text('#')),
            const DataColumn(label: Text('Ruangan')),
            const DataColumn(label: Text('Suhu (°C)')),
            const DataColumn(label: Text('Kelembaban (%)')),
            const DataColumn(label: Text('Kebersihan')),
            const DataColumn(label: Text('Lampu')),
            const DataColumn(label: Text('Note')),
            const DataColumn(label: Text('Actions')),
          ],
          rows: roomResults.asMap().entries.map((entry) {
            return DataRow(
              cells: [
                DataCell(Text('${entry.key + 1}')),
                DataCell(Text(entry.value.ruangan)),
                DataCell(Text('${entry.value.suhu}°C')),
                DataCell(Text('${entry.value.kelembaban}%')),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: entry.value.kebersihan == 'Bersih' 
                          ? Colors.green.shade100 
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      entry.value.kebersihan,
                      style: TextStyle(
                        color: entry.value.kebersihan == 'Bersih' 
                            ? Colors.green.shade700 
                            : Colors.red.shade700,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: entry.value.lampu == 'Berfungsi' 
                          ? Colors.green.shade100 
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      entry.value.lampu,
                      style: TextStyle(
                        color: entry.value.lampu == 'Berfungsi' 
                            ? Colors.green.shade700 
                            : Colors.red.shade700,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    entry.value.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmation(
                        'Hapus data ruangan?',
                        () => setState(() => roomResults.removeAt(entry.key)),
                      );
                    },
                    icon: Icon(TablerIcons.trash, color: Colors.red, size: 16.sp),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEquipmentTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
          columnSpacing: 12.w,
          horizontalMargin: 16.w,
          headingTextStyle: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF374151),
          ),
          dataTextStyle: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF6B7280),
          ),
          columns: [
            const DataColumn(label: Text('#')),
            const DataColumn(label: Text('Equipment')),
            const DataColumn(label: Text('Room')),
            const DataColumn(label: Text('Tanggal')),
            const DataColumn(label: Text('Merk')),
            const DataColumn(label: Text('Type')),
            const DataColumn(label: Text('Suhu')),
            const DataColumn(label: Text('Kabel')),
            const DataColumn(label: Text('Kondisi')),
            const DataColumn(label: Text('Note')),
            const DataColumn(label: Text('Actions')),
          ],
          rows: equipmentResults.asMap().entries.map((entry) {
            return DataRow(
              cells: [
                DataCell(Text('${entry.key + 1}')),
                DataCell(Text(entry.value.equipment)),
                DataCell(Text(entry.value.room)),
                DataCell(Text(entry.value.tanggal)),
                DataCell(Text(entry.value.merk)),
                DataCell(Text(entry.value.type)),
                DataCell(Text('${entry.value.suhu}°C')),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      entry.value.jenisKabel,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: entry.value.kondisi == 'Baik' 
                          ? Colors.green.shade100 
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      entry.value.kondisi,
                      style: TextStyle(
                        color: entry.value.kondisi == 'Baik' 
                            ? Colors.green.shade700 
                            : Colors.red.shade700,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    entry.value.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmation(
                        'Hapus data equipment?',
                        () => setState(() => equipmentResults.removeAt(entry.key)),
                      );
                    },
                    icon: Icon(TablerIcons.trash, color: Colors.red, size: 14.sp),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAttachmentTable() {
    final attachmentData = [
      ['1', 'A_SMTJ58I', 'Equipment', '2025-08-11_room1.jpg'],
      ['2', 'A_SMTJ58I', 'Equipment', '2025-08-11_equipment.png'],
      ['3', 'A_SMTJ58I', 'Inspeksi Fiber Optik', '2025-08-11_fiber.jpg'],
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
        columnSpacing: 16.w,
        horizontalMargin: 16.w,
        headingTextStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF374151),
        ),
        dataTextStyle: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF6B7280),
        ),
        columns: [
          const DataColumn(label: Text('#')),
          const DataColumn(label: Text('Equipment')),
          const DataColumn(label: Text('Type')),
          const DataColumn(label: Text('Filename')),
          const DataColumn(label: Text('Actions')),
        ],
        rows: attachmentData.asMap().entries.map((entry) {
          return DataRow(
            cells: [
              DataCell(Text(entry.value[0])),
              DataCell(Text(entry.value[1])),
              DataCell(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    entry.value[2],
                    style: TextStyle(
                      color: Colors.purple.shade700,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(TablerIcons.photo, color: Colors.blue, size: 14.sp),
                    SizedBox(width: 4.w),
                    Flexible(child: Text(entry.value[3])),
                  ],
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showSnackBar('Preview file', Colors.blue),
                      icon: Icon(TablerIcons.eye, color: Colors.blue, size: 16.sp),
                    ),
                    IconButton(
                      onPressed: () => _showSnackBar('Delete attachment', Colors.orange),
                      icon: Icon(TablerIcons.trash, color: Colors.red, size: 16.sp),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Action Methods with Enhanced Validation
  void _addRoomRecord() {
    if (_isValidRoom()) {
      final newRoom = RoomResult(
        ruangan: selectedRuangan!,
        suhu: controllers['suhu']!.text,
        kelembaban: controllers['kelembaban']!.text,
        kebersihan: selectedKebersihan!,
        lampu: selectedLampuPenerangan!,
        note: controllers['catatan']!.text.isEmpty ? '-' : controllers['catatan']!.text,
      );
      
      setState(() {
        roomResults.add(newRoom);
      });
      
      _clearRoomForm();
      _showSuccessSnackBar('Data ruangan berhasil ditambahkan!');
    }
  }

  void _addEquipmentRecord() {
    if (_isValidEquipment()) {
      final newEquipment = EquipmentResult(
        equipment: controllers['equipment']!.text,
        room: selectedRuangan ?? 'Ruang PLC',
        tanggal: controllers['tanggalInspeksi']!.text,
        merk: controllers['merk']!.text,
        type: controllers['type']!.text,
        suhu: controllers['suhuAsset']!.text,
        jenisKabel: selectedJenisKabel ?? 'ADSS',
        kondisi: selectedKondisiNormal ?? 'Baik',
        note: controllers['equipmentCatatan']!.text.isEmpty ? 'OK' : controllers['equipmentCatatan']!.text,
      );
      
      setState(() {
        equipmentResults.add(newEquipment);
      });
      
      _clearEquipmentForm();
      _showSuccessSnackBar('Data equipment berhasil ditambahkan!');
    }
  }

  bool _isValidRoom() {
    final errors = <String>[];
    
    if (selectedRuangan == null || selectedRuangan == 'Pilih Ruangan') {
      errors.add('Pilih ruangan');
    }
    if (controllers['suhu']!.text.isEmpty) {
      errors.add('Masukkan suhu ruangan');
    } else {
      final temp = double.tryParse(controllers['suhu']!.text);
      if (temp == null || temp < 0 || temp > 60) {
        errors.add('Suhu harus antara 0-60°C');
      }
    }
    if (controllers['kelembaban']!.text.isEmpty) {
      errors.add('Masukkan kelembaban');
    } else {
      final humidity = double.tryParse(controllers['kelembaban']!.text);
      if (humidity == null || humidity < 0 || humidity > 100) {
        errors.add('Kelembaban harus antara 0-100%');
      }
    }
    if (selectedKebersihan == null) {
      errors.add('Pilih status kebersihan');
    }
    if (selectedLampuPenerangan == null) {
      errors.add('Pilih status lampu penerangan');
    }
    
    if (errors.isNotEmpty) {
      _showErrorSnackBar('Mohon lengkapi: ${errors.join(', ')}');
      return false;
    }
    return true;
  }

  bool _isValidEquipment() {
    final errors = <String>[];
    
    if (controllers['equipment']!.text.isEmpty) {
      errors.add('Nama equipment');
    }
    if (controllers['merk']!.text.isEmpty) {
      errors.add('Merk equipment');
    }
    if (controllers['type']!.text.isEmpty) {
      errors.add('Type equipment');
    }
    if (controllers['suhuAsset']!.text.isEmpty) {
      errors.add('Suhu asset');
    } else {
      final temp = double.tryParse(controllers['suhuAsset']!.text);
      if (temp == null || temp < 0 || temp > 100) {
        errors.add('Suhu asset tidak valid (0-100°C)');
      }
    }
    if (selectedKondisiNormal == null) {
      errors.add('Status kondisi');
    }
    
    if (errors.isNotEmpty) {
      _showErrorSnackBar('Mohon lengkapi: ${errors.join(', ')}');
      return false;
    }
    return true;
  }

  void _clearRoomForm() {
    setState(() {
      selectedRuangan = null;
      selectedKebersihan = null;
      selectedLampuPenerangan = null;
    });
    controllers['suhu']!.clear();
    controllers['kelembaban']!.clear();
    controllers['catatan']!.clear();
  }

  void _clearEquipmentForm() {
    setState(() {
      selectedKondisiNormal = null;
      selectedJenisKabel = 'ADSS';
    });
    controllers['equipment']!.clear();
    controllers['merk']!.clear();
    controllers['type']!.clear();
    controllers['suhuAsset']!.clear();
    controllers['kabelLuar']!.clear();
    controllers['equipmentCatatan']!.clear();
  }

  // Enhanced UI Feedback Methods
  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? TablerIcons.circle_check : 
              color == Colors.red ? TablerIcons.alert_circle :
              TablerIcons.info_circle,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  void _showSuccessSnackBar(String message) => _showSnackBar(message, Colors.green);
  void _showErrorSnackBar(String message) => _showSnackBar(message, Colors.red);

  void _showDeleteConfirmation(String title, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(TablerIcons.alert_triangle, color: Colors.orange, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              'Konfirmasi',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
              _showSuccessSnackBar('Data berhasil dihapus');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text('Hapus', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.teal),
          ),
          child: child!,
        );
      },
    );
    
    if (date != null && mounted) {
      setState(() {
        controllers['tanggalInspeksi']!.text = 
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _nextStep() {
    if (_canProceed()) {
      setState(() => currentStep++);
      _pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  bool _canProceed() {
    switch (currentStep) {
      case 0:
        if (roomResults.isEmpty) {
          _showErrorSnackBar('Tambahkan minimal satu data ruangan untuk melanjutkan');
          return false;
        }
        break;
      case 1:
        if (equipmentResults.isEmpty) {
          _showErrorSnackBar('Tambahkan minimal satu data equipment untuk melanjutkan');
          return false;
        }
        break;
    }
    return true;
  }

  void _submitForm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Column(
          children: [
            Icon(TablerIcons.circle_check, color: Colors.green, size: 48.sp),
            SizedBox(height: 16.h),
            Text(
              'Form FOC L1 Berhasil!',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Form FOC Bulanan Level 1 telah berhasil disubmit ke sistem.',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(TablerIcons.info_circle, color: Colors.green, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'ID Inspeksi: FOC-L1-${DateTime.now().millisecondsSinceEpoch}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                'Selesai',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}