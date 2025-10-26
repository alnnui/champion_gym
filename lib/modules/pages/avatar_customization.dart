import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide Animation;
import 'package:rive_native/rive_native.dart' as rive_native;

import 'package:myapp/modules/components/animated_button.dart';
import 'package:myapp/modules/components/animated_tap.dart';
import 'package:myapp/modules/providers/UserProvider.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:myapp/modules/widgets/avatar/avatar_palette.dart';

/// Avatar customization screen, ported from the Bapcare mobile app and adapted
/// to Champion Fitness's dark theme. Config is persisted on the backend via
/// [UserProvider.updateAvatarConfig]; returns the saved config to the caller
/// on Done.
class AvatarCustomizationScreen extends StatefulWidget {
  final Map<String, dynamic>? initialConfig;

  const AvatarCustomizationScreen({super.key, this.initialConfig});

  @override
  State<AvatarCustomizationScreen> createState() =>
      _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState extends State<AvatarCustomizationScreen> {
  late Map<String, dynamic> _config;
  bool _isSaving = false;

  RiveWidgetController? _controller;
  File? _riveFile;
  ViewModelInstance? _vmi;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig != null
        ? Map<String, dynamic>.from(widget.initialConfig!)
        : defaultAvatarConfig();
    _loadRive();
  }

  Future<void> _loadRive() async {
    try {
      final file = await File.asset(
        'lib/assets/animations/avatar.riv',
        riveFactory: Factory.rive,
      );
      if (!mounted || file == null) return;
      _riveFile = file;

      final controller = RiveWidgetController(file);
      _controller = controller;

      final vmi = controller.dataBind(AutoBind());
      _vmi = vmi;

      _applyConfig();
      setState(() {});
    } catch (e) {
      debugPrint('Error loading avatar.riv: $e');
    }
  }

  void _applyConfig() {
    if (_vmi == null || _riveFile == null) return;

    final genderIdx = _config['genderHead'] as int? ?? 0;
    final skinIdx =
        (_config['skinColorIndex'] as int? ?? 0).clamp(0, kSkinColors.length - 1);
    final bodyArtIdx =
        (_config['bodyArtIndex'] as int? ?? 0).clamp(0, kBodyArtboards.length - 1);
    final bodyColorIdx =
        (_config['bodyColorIndex'] as int? ?? 0).clamp(0, kBodyColors.length - 1);
    final hairArtIdx =
        (_config['hairArtIndex'] as int? ?? 0).clamp(0, kHairArtboards.length - 1);
    final hairColorIdx =
        (_config['hairColorIndex'] as int? ?? 0).clamp(0, kHairColors.length - 1);
    final hasBeard = _config['hasBeard'] as int? ?? 0;
    final bgColorIdx =
        (_config['bgColorIndex'] as int? ?? 0).clamp(0, kBgColors.length - 1);

    final headAb = _riveFile!.artboardToBind(
      kHeadArtboards[genderIdx.clamp(0, kHeadArtboards.length - 1)],
    );
    if (headAb != null) _vmi!.artboard('genderHead')?.value = headAb;

    final bodyAb = _riveFile!.artboardToBind(kBodyArtboards[bodyArtIdx]);
    if (bodyAb != null) _vmi!.artboard('bodyArt')?.value = bodyAb;

    final hairAb = _riveFile!.artboardToBind(kHairArtboards[hairArtIdx]);
    if (hairAb != null) _vmi!.artboard('hairArt')?.value = hairAb;

    _vmi!.color('bodyColor')?.value = kBodyColors[bodyColorIdx];
    _vmi!.color('secondaryBodyColor')?.value =
        darkenColor(kBodyColors[bodyColorIdx], 0.15);
    _vmi!.color('skinColor')?.value = kSkinColors[skinIdx];
    _vmi!.color('secondarySkinColor')?.value =
        darkenColor(kSkinColors[skinIdx], 0.20);
    _vmi!.color('hairColor')?.value = kHairColors[hairColorIdx];
    _vmi!.color('bgColor')?.value = kBgColors[bgColorIdx];
    _vmi!.number('hasBeard')?.value = hasBeard.toDouble();
  }

  void _updateConfig(String key, int value) {
    setState(() {
      _config[key] = value;
      _applyConfig();
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await context.read<UserProvider>().updateAvatarConfig(_config);
      if (!mounted) return;
      Navigator.of(context).pop(_config);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось сохранить аватар.')),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgIdx =
        (_config['bgColorIndex'] as int? ?? 0).clamp(0, kBgColors.length - 1);
    final avatarBg = kBgColors[bgIdx];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                children: [
                  AnimatedTap(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundComplimentary,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.text,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Создать аватар',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  const Spacer(),
                  AnimatedButton(
                    onPressed: _isSaving ? () {} : _save,
                    width: 92.w,
                    height: 44.h,
                    borderRadius: 22.r,
                    backgroundColor: AppColors.primary,
                    child: _isSaving
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.textAlternative,
                              ),
                            ),
                          )
                        : Text(
                            'ГОТОВО',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textAlternative,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Avatar preview
            Container(
              width: double.infinity,
              height: 280.h,
              color: avatarBg,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 250.w,
                  height: 250.w,
                  child: _controller != null
                      ? RiveWidget(controller: _controller!, fit: Fit.contain)
                      : Center(
                          child: CircularProgressIndicator(
                            color: AppColors.background,
                            strokeWidth: 2.5,
                          ),
                        ),
                ),
              ),
            ),

            // Tab bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundComplimentary,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      _TabIcon(
                        assetPath: 'lib/assets/icons/avatar_config/user_flat.png',
                        accentColor: AppColors.primary,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                      _TabIcon(
                        assetPath: 'lib/assets/icons/avatar_config/scissors.png',
                        accentColor: AppColors.primary,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                      _TabIcon(
                        assetPath: 'lib/assets/icons/avatar_config/shirt.png',
                        accentColor: AppColors.primary,
                        onTap: () => setState(() => _selectedTab = 2),
                      ),
                      _TabIcon(
                        assetPath: 'lib/assets/icons/avatar_config/pallete.png',
                        accentColor: AppColors.primary,
                        onTap: () => setState(() => _selectedTab = 3),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final tabWidth = constraints.maxWidth / 4;
                          final indicatorWidth = tabWidth * 0.62;
                          final indicatorLeft = (_selectedTab * tabWidth) +
                              ((tabWidth - indicatorWidth) / 2);

                          return Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOutCubic,
                                left: indicatorLeft,
                                bottom: 0,
                                width: indicatorWidth,
                                height: 3.h,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                color: AppColors.background,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: _buildTabContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildBodyTab();
      case 1:
        return _buildHairTab();
      case 2:
        return _buildClothingColorTab();
      case 3:
        return _buildBackgroundTab();
      default:
        return const SizedBox.shrink();
    }
  }

  // Tab 0: Body (gender + skin color + body art)
  Widget _buildBodyTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Пол'),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _OptionChip(
                icon: Icons.male_rounded,
                isSelected: (_config['genderHead'] as int? ?? 0) == 0,
                onTap: () => _updateConfig('genderHead', 0),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _OptionChip(
                icon: Icons.female_rounded,
                isSelected: (_config['genderHead'] as int? ?? 0) == 1,
                onTap: () => _updateConfig('genderHead', 1),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _sectionTitle('Цвет кожи'),
        SizedBox(height: 10.h),
        _buildColorPicker(
          colors: kSkinColors,
          selectedIndex: _config['skinColorIndex'] as int? ?? 0,
          onSelect: (i) => _updateConfig('skinColorIndex', i),
        ),
        SizedBox(height: 24.h),
        _sectionTitle('Тело'),
        SizedBox(height: 10.h),
        _buildArtGrid(
          count: kBodyArtboards.length,
          selectedIndex: _config['bodyArtIndex'] as int? ?? 0,
          onSelect: (i) => _updateConfig('bodyArtIndex', i),
          artboardNames: kBodyArtboards,
          previewOffsetY: 0,
        ),
      ],
    );
  }

  // Tab 1: Hair (style + beard + color)
  Widget _buildHairTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Причёска'),
        SizedBox(height: 10.h),
        _buildArtGrid(
          count: kHairArtboards.length,
          selectedIndex: _config['hairArtIndex'] as int? ?? 0,
          onSelect: (i) => _updateConfig('hairArtIndex', i),
          artboardNames: kHairArtboards,
          previewOffsetY: 12,
        ),
        SizedBox(height: 24.h),
        _sectionTitle('Борода'),
        SizedBox(height: 10.h),
        Row(
          children: [
            _OptionChip(
              label: 'Без бороды',
              isSelected: (_config['hasBeard'] as int? ?? 0) == 0,
              onTap: () => _updateConfig('hasBeard', 0),
            ),
            SizedBox(width: 10.w),
            _OptionChip(
              label: 'С бородой',
              isSelected: (_config['hasBeard'] as int? ?? 0) == 1,
              onTap: () => _updateConfig('hasBeard', 1),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _sectionTitle('Цвет волос'),
        SizedBox(height: 10.h),
        _buildColorPicker(
          colors: kHairColors,
          selectedIndex: _config['hairColorIndex'] as int? ?? 0,
          onSelect: (i) => _updateConfig('hairColorIndex', i),
        ),
      ],
    );
  }

  // Tab 2: Clothing color
  Widget _buildClothingColorTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Цвет одежды'),
        SizedBox(height: 10.h),
        _buildColorPicker(
          colors: kBodyColors,
          selectedIndex: _config['bodyColorIndex'] as int? ?? 0,
          onSelect: (i) => _updateConfig('bodyColorIndex', i),
        ),
      ],
    );
  }

  // Tab 3: Background
  Widget _buildBackgroundTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Цвет фона'),
        SizedBox(height: 10.h),
        _buildColorPicker(
          colors: kBgColors,
          selectedIndex: _config['bgColorIndex'] as int? ?? 0,
          onSelect: (i) => _updateConfig('bgColorIndex', i),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildColorPicker({
    required List<Color> colors,
    required int selectedIndex,
    required ValueChanged<int> onSelect,
  }) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.w,
      children: List.generate(colors.length, (i) {
        final isSelected = i == selectedIndex;
        return AnimatedTap(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: colors[i],
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: isSelected ? 3 : 0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors[i].withOpacity(0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildArtGrid({
    required int count,
    required int selectedIndex,
    required ValueChanged<int> onSelect,
    List<String>? artboardNames,
    double previewOffsetY = 12,
  }) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.w,
      children: List.generate(count, (i) {
        final isSelected = i == selectedIndex;
        return AnimatedTap(
          onTap: () => onSelect(i),
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.backgroundComplimentary,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.white.withOpacity(0.06),
                width: isSelected ? 2.5 : 1,
              ),
            ),
            child: Center(
              child: artboardNames != null && _riveFile != null
                  ? Padding(
                      padding: EdgeInsets.all(6.w),
                      child: _ArtboardPreview(
                        file: _riveFile!,
                        artboardName: artboardNames[i],
                        offsetY: previewOffsetY,
                      ),
                    )
                  : Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.text.withOpacity(0.5),
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}

class _ArtboardPreview extends StatefulWidget {
  final File file;
  final String artboardName;
  final double offsetY;

  const _ArtboardPreview({
    required this.file,
    required this.artboardName,
    required this.offsetY,
  });

  @override
  State<_ArtboardPreview> createState() => _ArtboardPreviewState();
}

class _ArtboardPreviewState extends State<_ArtboardPreview> {
  late final rive_native.BasicArtboardPainter _painter;

  @override
  void initState() {
    super.initState();
    _painter = rive_native.BasicArtboardPainter(
      fit: Fit.contain,
      alignment: Alignment.center,
    );
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Transform.translate(
          offset: Offset(0, widget.offsetY),
          child: Transform.scale(
            scale: 1.45,
            child: rive_native.RiveFileWidget(
              file: widget.file,
              artboardName: widget.artboardName,
              painter: _painter,
            ),
          ),
        ),
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  final String assetPath;
  final Color accentColor;
  final VoidCallback onTap;

  const _TabIcon({
    required this.assetPath,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(accentColor, BlendMode.srcIn),
            child: Image.asset(
              assetPath,
              width: 24.w,
              height: 24.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionChip({
    this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  }) : assert(label != null || icon != null);

  @override
  Widget build(BuildContext context) {
    final fg = isSelected ? AppColors.textAlternative : AppColors.text;
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.backgroundComplimentary,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, size: 24.sp, color: fg)
              : Text(
                  label!,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
        ),
      ),
    );
  }
}
