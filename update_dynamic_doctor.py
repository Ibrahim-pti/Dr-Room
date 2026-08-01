import re

with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

# 1. Update variables
vars_old = """  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  bool _isBooking = false;"""

vars_new = """  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  int _selectedServiceIndex = -1;
  bool _isBooking = false;
  List<Map<String, dynamic>> _dynamicDates = [];
  List<String> _dynamicTimes = [];
  List<dynamic> _services = [];"""

content = content.replace(vars_old, vars_new)

# 2. Update _fetchDoctorDetails parsing
fetch_old = """        if (mounted) {
          setState(() {
            _doctorDetails = data;
            _isLoadingDetails = false;
          });
          _initializeVideoPlayer();
        }"""

fetch_new = """        if (mounted) {
          setState(() {
            _doctorDetails = data;
            _isLoadingDetails = false;
            if (data['services'] != null) {
              _services = data['services'];
            }
            _generateDynamicSchedules(data['schedules']);
          });
          _initializeVideoPlayer();
        }"""

content = content.replace(fetch_old, fetch_new)

# 3. Add _generateDynamicSchedules and _updateDynamicTimes
methods = """
  void _generateDynamicSchedules(List<dynamic>? schedules) {
    if (schedules == null || schedules.isEmpty) return;
    
    // Create next 14 days
    _dynamicDates.clear();
    final now = DateTime.now();
    
    // Map of days available
    Map<String, dynamic> daysMap = {};
    for (var s in schedules) {
      daysMap[s['day_of_week']] = s;
    }
    
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      final dayName = daysOfWeek[date.weekday - 1];
      
      if (daysMap.containsKey(dayName)) {
        final schedule = daysMap[dayName];
        _dynamicDates.add({
          'day': DateFormat('E').format(date),
          'date': DateFormat('dd').format(date),
          'full_date': DateFormat('yyyy-MM-dd').format(date),
          'start_time': schedule['start_time'],
          'end_time': schedule['end_time'],
          'schedule_id': schedule['id'],
        });
      }
    }
    
    if (_dynamicDates.isNotEmpty) {
      _selectedDateIndex = 0;
      _updateDynamicTimes();
    }
  }

  void _updateDynamicTimes() {
    _dynamicTimes.clear();
    _selectedTimeIndex = -1;
    if (_dynamicDates.isEmpty) return;
    
    final selectedDate = _dynamicDates[_selectedDateIndex];
    final startStr = selectedDate['start_time'].toString();
    final endStr = selectedDate['end_time'].toString();
    
    try {
      var startParts = startStr.split(':');
      var endParts = endStr.split(':');
      
      var start = TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
      var end = TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));
      
      var current = start;
      while (current.hour < end.hour || (current.hour == end.hour && current.minute <= end.minute)) {
        final period = current.hour >= 12 ? 'PM' : 'AM';
        int h = current.hour > 12 ? current.hour - 12 : (current.hour == 0 ? 12 : current.hour);
        final m = current.minute.toString().padLeft(2, '0');
        _dynamicTimes.add('${h.toString().padLeft(2, '0')}:$m $period');
        
        // Add 30 mins
        int newMin = current.minute + 30;
        int newHour = current.hour;
        if (newMin >= 60) {
          newHour += 1;
          newMin -= 60;
        }
        current = TimeOfDay(hour: newHour, minute: newMin);
      }
    } catch(e) {}
  }
"""

content = content.replace("  void _initializeVideoPlayer() {", methods + "\n  void _initializeVideoPlayer() {")

# 4. Replace hardcoded lists logic
content = re.sub(r'  final List<Map<String, String>> _dates = \[.*?\];', '', content, flags=re.DOTALL)
content = re.sub(r'  final List<String> _times = \[.*?\];', '', content, flags=re.DOTALL)

# 5. Update _bookAppointment
book_old = """      // Mocking a valid future date based on selection
      final date = _dates[_selectedDateIndex]['date']!;
      final timeStr = _times[_selectedTimeIndex];
      // Simple parse to make a valid date for API (e.g. 2026-11-XX HH:MM)
      // Just a dummy conversion for the sake of the API
      final isPM = timeStr.contains('PM');
      var hour = int.parse(timeStr.split(':')[0]);
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      final minute = timeStr.split(':')[1].substring(0, 2);
      final formattedDate =
          '2026-11-$date ${hour.toString().padLeft(2, '0')}:$minute:00';

      final response = await ApiClient.post(
        '/appointments',
        body: {
          'doctor_id': widget.doctorId,
          'appointment_date': formattedDate,
          'type': 'in_person',
        },
      );"""

book_new = """      if (_dynamicDates.isEmpty || _selectedTimeIndex == -1) {
        throw Exception('Please select date and time');
      }
      
      final date = _dynamicDates[_selectedDateIndex]['full_date'];
      final timeStr = _dynamicTimes[_selectedTimeIndex];
      
      final isPM = timeStr.contains('PM');
      var hour = int.parse(timeStr.split(':')[0]);
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      final minute = timeStr.split(':')[1].substring(0, 2);
      final formattedDate = '$date ${hour.toString().padLeft(2, '0')}:$minute:00';

      Map<String, dynamic> body = {
        'doctor_id': widget.doctorId,
        'appointment_date': formattedDate,
        'type': 'in_person',
      };
      
      if (_selectedServiceIndex != -1) {
        body['service_id'] = _services[_selectedServiceIndex]['id'];
      }

      final response = await ApiClient.post(
        '/appointments',
        body: body,
      );"""

content = content.replace(book_old, book_new)

# 6. Update UI dates length and list
content = content.replace('_dates.length', '_dynamicDates.length')
content = content.replace("_dates[index]['day']!", "_dynamicDates[index]['day']")
content = content.replace("_dates[index]['date']!", "_dynamicDates[index]['date']")

content = content.replace('setState(() => _selectedDateIndex = index);', 'setState(() { _selectedDateIndex = index; _updateDynamicTimes(); });')

content = content.replace('_times.length', '_dynamicTimes.length')
content = content.replace('_times[index]', '_dynamicTimes[index]')


# 7. Add Services UI before Date Selection
services_ui = """                // ── Services Section ──
                if (_services.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'جۆری سەردان (خزمەتگوزاری)',
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextTitle(context),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: _services.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedServiceIndex == index;
                        final service = _services[index];
                        // Try to get locale based name, fallback to ckb
                        String name = service['name_ckb'] ?? '';
                        final locale = context.locale.languageCode;
                        if (locale == 'en') name = service['name_en'] ?? name;
                        if (locale == 'ar') name = service['name_ar'] ?? name;
                        
                        return GestureDetector(
                          onTap: () => setState(() => _selectedServiceIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.getSurface(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF3B82F6)
                                    : AppColors.getBorder(context),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              name,
                              style: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.getTextTitle(context),
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
"""

content = content.replace('                // ── Calendar Selection ──', services_ui + '                // ── Calendar Selection ──')


# 8. Update Price logic at bottom
price_old = """                      Text(
                        '\\$15.00',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF3B82F6),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),"""

price_new = """                      Text(
                        _selectedServiceIndex != -1 
                          ? '\\$${_services[_selectedServiceIndex]['price']}' 
                          : '\\$${_doctorDetails?['consultation_fee'] ?? "15.00"}',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF3B82F6),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),"""

content = content.replace(price_old, price_new)

# Format empty schedules and times
content = content.replace("                      itemCount: _dynamicDates.length,", "                      itemCount: _dynamicDates.isEmpty ? 1 : _dynamicDates.length,")
content = content.replace("                      itemCount: _dynamicTimes.length,", "                      itemCount: _dynamicTimes.isEmpty ? 1 : _dynamicTimes.length,")

dates_item_old = """                    itemBuilder: (context, index) {
                      final isSelected = _selectedDateIndex == index;"""
dates_item_new = """                    itemBuilder: (context, index) {
                      if (_dynamicDates.isEmpty) {
                         return Center(child: Text("ببوورە کات بەردەست نییە", style: TextStyle(color: Colors.red)));
                      }
                      final isSelected = _selectedDateIndex == index;"""
content = content.replace(dates_item_old, dates_item_new)

times_item_old = """                    itemBuilder: (context, index) {
                      final isSelected = _selectedTimeIndex == index;"""
times_item_new = """                    itemBuilder: (context, index) {
                      if (_dynamicTimes.isEmpty) {
                         return Center(child: Text("کاتی بەردەست نییە"));
                      }
                      final isSelected = _selectedTimeIndex == index;"""
content = content.replace(times_item_old, times_item_new)


with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
