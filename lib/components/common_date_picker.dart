import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_text_filed.dart';

class CommonDatePicker extends StatefulWidget {
  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  final Function(String) onChange;

  const CommonDatePicker({
    super.key,
    required this.fromDateController,
    required this.toDateController,
    required this.onChange,
  });

  @override
  _CommonDatePickerState createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends State<CommonDatePicker> {
  @override
  void initState() {
    super.initState();
    // Remove or comment out this line to start with no initial date
    // _initializeDefaultDates();
  }

  Future<void> _showDatePicker() async {
    final today = DateTime.now();
    final thirtyDaysAgo = today.subtract(Duration(days: 30));

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange:
          widget.fromDateController.text.isNotEmpty
              ? DateTimeRange(
                start: DateTime.parse(widget.fromDateController.text),
                end: today,
              )
              : DateTimeRange(start: thirtyDaysAgo, end: today),
    );

    if (picked != null) {
      final fromDate = _formatDate(picked.start);
      final toDate = _formatDate(picked.end);

      setState(() {
        widget.fromDateController.text = fromDate;
        widget.toDateController.text = "$fromDate - $toDate";
      });

      widget.onChange(widget.toDateController.text);
    }
  }

  void _clearDates() {
    setState(() {
      widget.fromDateController.clear();
      widget.toDateController.clear();
    });
    widget.onChange('');
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      textEditingController: widget.toDateController,
      onlyRead: true,
      labelText: "Select Date Range",
      hitText: "From Date - To Date",
      suffixIcons: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.toDateController.text.isNotEmpty)
            IconButton(
              onPressed: _clearDates,
              icon: HeroIcon(HeroIcons.xMark, size: 20),
            ),
          IconButton(
            onPressed: _showDatePicker,
            icon: HeroIcon(HeroIcons.calendar),
          ),
        ],
      ),
    );
  }
}
