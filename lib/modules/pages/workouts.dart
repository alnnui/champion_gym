import 'package:flutter/material.dart';
import 'package:project_v1/modules/theme/colors.dart';

class Workout {
	final DateTime dateTime;
	final String type;
	final int experience;

	Workout({required this.dateTime, required this.type, required this.experience});
}

class WorkoutsPage extends StatefulWidget {
	const WorkoutsPage({Key? key}) : super(key: key);

	@override
	State<WorkoutsPage> createState() => _WorkoutsPageState();
}
class _WorkoutsPageState extends State<WorkoutsPage> {
	final List<Workout> _workouts = [
		Workout(dateTime: DateTime.now().subtract(const Duration(days: 1)), type: 'Индивидуальное', experience: 50),
	Workout(dateTime: DateTime.now(), type: 'С тренером', experience: 80),
	Workout(dateTime: DateTime.now().add(const Duration(days: 1)), type: 'Групповое', experience: 100),
	// ...добавьте больше тренировок...
	];

	String _search = '';
	DateTime? _selectedDate;

	List<Workout> get _filteredWorkouts {
		return _workouts.where((w) {
			final matchesSearch = w.type.toLowerCase().contains(_search.toLowerCase());
			final matchesDate = _selectedDate == null ||
		  (w.dateTime.year == _selectedDate!.year &&
		   w.dateTime.month == _selectedDate!.month &&
		   w.dateTime.day == _selectedDate!.day);
			return matchesSearch && matchesDate;
		}).toList();
	}
	@override
	Widget build(BuildContext context) {
			return Scaffold(
				backgroundColor: AppColors.background,
				body: Padding(
					padding: const EdgeInsets.all(16.0),
					child: Column(
						children: [
							_buildSearchBar(),
							const SizedBox(height: 12),
							_buildDatePicker(context),
							const SizedBox(height: 12),
							Expanded(child: _buildWorkoutList()),
						],
					),
				),
			);
	}

	Widget _buildSearchBar() {
			return TextField(
				decoration: InputDecoration(
					hintText: 'Поиск по типу...',
					prefixIcon: const Icon(Icons.search),
					filled: true,
					fillColor: AppColors.cardBackground,
					border: OutlineInputBorder(
						borderRadius: BorderRadius.circular(24),
						borderSide: BorderSide.none,
					),
				),
				style: const TextStyle(color: AppColors.text),
				onChanged: (value) {
					setState(() {
						_search = value;
					});
				},
			);
	}
	Widget _buildDatePicker(BuildContext context) {
			return Row(
				children: [
					Expanded(
						child: Text(
							_selectedDate == null
									? 'Все даты'
									: 'Дата: ${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
							style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.text),
						),
					),
					ElevatedButton.icon(
						style: ElevatedButton.styleFrom(
							backgroundColor: AppColors.primary,
							foregroundColor: AppColors.textAlternative,
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
						),
						icon: const Icon(Icons.calendar_today),
						label: const Text('Выбрать дату'),
						onPressed: () async {
							final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary, // цвет верхней панели и выделения
                        onPrimary: AppColors.textAlternative, // цвет текста на панели
                        surface: AppColors.backgroundComplimentary, // фон календаря
                        onSurface: AppColors.text, // цвет текста дней
                      ),
                      dialogTheme: DialogThemeData(
                        backgroundColor: AppColors.background,
                      ), // фон диалога
                    ),
                    child: child!,
                  );
                },
              );
							if (picked != null) {
								setState(() {
									_selectedDate = picked;
								});
							}
						},
					),
					if (_selectedDate != null)
						IconButton(
							icon: const Icon(Icons.clear),
							color: AppColors.error,
							onPressed: () {
								setState(() {
									_selectedDate = null;
								});
							},
						),
				],
			);
	}

	Widget _buildWorkoutList() {
			if (_filteredWorkouts.isEmpty) {
				return Center(
					child: Text(
						'Нет тренировок',
						style: const TextStyle(color: AppColors.textAlternative, fontSize: 18),
					),
				);
			}
		return ListView.builder(
			itemCount: _filteredWorkouts.length,
			itemBuilder: (context, index) {
				final workout = _filteredWorkouts[index];
				return _buildWorkoutCard(workout);
			},
		);
	}

	Widget _buildWorkoutCard(Workout workout) {
      final date = {
        "minute": workout.dateTime.minute.toString().padLeft(2, '0'),
        "hour": workout.dateTime.hour.toString().padLeft(2, '0'),
        "day": workout.dateTime.day,
        "month": workout.dateTime.month,
        "year": workout.dateTime.year,
      };
      
			return Card(
				color: AppColors.backgroundComplimentary,
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
				elevation: 4,
				margin: const EdgeInsets.symmetric(vertical: 8),
				child: Padding(
					padding: const EdgeInsets.all(18.0),
					child: Row(
						children: [
							Icon(
								_getIconForType(workout.type),
								color: AppColors.primary,
								size: 36,
							),
							const SizedBox(width: 16),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											'${date['day']}.${date['month']}.${date['year']}  ${date['hour']}:${date['minute']}',
											style: const TextStyle(fontSize: 16, color: AppColors.text, fontWeight: FontWeight.bold),
										),
										const SizedBox(height: 4),
									],
								),
							),
							Column(
                crossAxisAlignment: CrossAxisAlignment.end,
								children: [
									Text(
										'+${workout.experience} XP',
										style: TextStyle(fontSize: 16, color: AppColors.success, fontWeight: FontWeight.w600),
									),
									const SizedBox(height: 4),
									Container(
										padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
										decoration: BoxDecoration(
											color: AppColors.primary.withOpacity(0.1),
											borderRadius: BorderRadius.circular(12),
										),
										child: Text(
											workout.type,
											style: const TextStyle(fontSize: 13, color: AppColors.primary),
										),
									),
								],
							),
						],
					),
				),
			);
	}

	IconData _getIconForType(String type) {
		switch (type) {
			case 'Индивидуальное':
				return Icons.person;
			case 'С тренером':
				return Icons.fitness_center;
			case 'Групповое':
				return Icons.group;
			default:
				return Icons.sports;
		}
	}
}
