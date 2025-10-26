import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Animation;

import 'avatar_palette.dart';

/// Displays a Rive avatar configured by [avatarConfig].
/// Falls back to [fallback] widget if config is null or loading fails.
class RiveAvatarWidget extends StatefulWidget {
  final Map<String, dynamic>? avatarConfig;
  final double size;
  final Widget? fallback;
  final BoxShape shape;

  const RiveAvatarWidget({
    super.key,
    required this.avatarConfig,
    required this.size,
    this.fallback,
    this.shape = BoxShape.circle,
  });

  @override
  State<RiveAvatarWidget> createState() => _RiveAvatarWidgetState();
}

class _RiveAvatarWidgetState extends State<RiveAvatarWidget> {
  RiveWidgetController? _controller;
  File? _riveFile;
  ViewModelInstance? _vmi;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.avatarConfig != null) {
      _load();
    }
  }

  @override
  void didUpdateWidget(covariant RiveAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.avatarConfig != oldWidget.avatarConfig) {
      if (widget.avatarConfig == null) {
        _controller?.dispose();
        _controller = null;
        _vmi = null;
        setState(() {});
      } else if (_vmi != null) {
        _applyConfig();
      } else {
        _load();
      }
    }
  }

  Future<void> _load() async {
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
      if (mounted) setState(() => _failed = true);
    }
  }

  void _applyConfig() {
    final config = widget.avatarConfig;
    if (config == null || _vmi == null || _riveFile == null) return;

    final genderIdx = config['genderHead'] as int? ?? 0;
    final skinColorIdx =
        (config['skinColorIndex'] as int? ?? 0).clamp(0, kSkinColors.length - 1);
    final bodyArtIdx =
        (config['bodyArtIndex'] as int? ?? 0).clamp(0, kBodyArtboards.length - 1);
    final bodyColorIdx =
        (config['bodyColorIndex'] as int? ?? 0).clamp(0, kBodyColors.length - 1);
    final hairArtIdx =
        (config['hairArtIndex'] as int? ?? 0).clamp(0, kHairArtboards.length - 1);
    final hairColorIdx =
        (config['hairColorIndex'] as int? ?? 0).clamp(0, kHairColors.length - 1);
    final hasBeard = config['hasBeard'] as int? ?? 0;
    final bgColorIdx =
        (config['bgColorIndex'] as int? ?? 0).clamp(0, kBgColors.length - 1);

    final headAb = _riveFile!.artboardToBind(
      kHeadArtboards[genderIdx.clamp(0, kHeadArtboards.length - 1)],
    );
    if (headAb != null) _vmi!.artboard('genderHead')?.value = headAb;

    final bodyAb = _riveFile!.artboardToBind(kBodyArtboards[bodyArtIdx]);
    if (bodyAb != null) _vmi!.artboard('bodyArt')?.value = bodyAb;

    final hairAb = _riveFile!.artboardToBind(kHairArtboards[hairArtIdx]);
    if (hairAb != null) _vmi!.artboard('hairArt')?.value = hairAb;

    final bodyColor = kBodyColors[bodyColorIdx];
    _vmi!.color('bodyColor')?.value = bodyColor;
    _vmi!.color('secondaryBodyColor')?.value = darkenColor(bodyColor, 0.15);
    _vmi!.color('skinColor')?.value = kSkinColors[skinColorIdx];
    _vmi!.color('secondarySkinColor')?.value =
        darkenColor(kSkinColors[skinColorIdx], 0.20);
    _vmi!.color('hairColor')?.value = kHairColors[hairColorIdx];
    _vmi!.color('bgColor')?.value = kBgColors[bgColorIdx];
    _vmi!.number('hasBeard')?.value = hasBeard.toDouble();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.avatarConfig == null || _failed) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    if (_controller == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: widget.fallback ?? const SizedBox.shrink(),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.shape == BoxShape.circle
          ? ClipOval(
              child: RepaintBoundary(
                child: RiveWidget(controller: _controller!, fit: Fit.cover),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.zero,
              child: RepaintBoundary(
                child: RiveWidget(controller: _controller!, fit: Fit.cover),
              ),
            ),
    );
  }
}

/// Rive avatar with a graceful initials fallback when no config is set.
class UserAvatarWidget extends StatelessWidget {
  final Map<String, dynamic>? avatarConfig;
  final double size;
  final Color backgroundColor;
  final String initials;
  final Color textColor;
  final double? fontSize;
  final BoxBorder? border;
  final BoxShape shape;

  const UserAvatarWidget({
    super.key,
    required this.avatarConfig,
    required this.size,
    required this.backgroundColor,
    required this.initials,
    this.textColor = Colors.white,
    this.fontSize,
    this.border,
    this.shape = BoxShape.circle,
  });

  @override
  Widget build(BuildContext context) {
    return RiveAvatarWidget(
      avatarConfig: avatarConfig,
      size: size,
      shape: shape,
      fallback: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: shape,
          border: border,
        ),
        child: shape == BoxShape.circle
            ? ClipOval(
                child: _AvatarInitialsFallback(
                  initials: initials,
                  textColor: textColor,
                  fontSize: fontSize,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.zero,
                child: _AvatarInitialsFallback(
                  initials: initials,
                  textColor: textColor,
                  fontSize: fontSize,
                ),
              ),
      ),
    );
  }
}

class _AvatarInitialsFallback extends StatelessWidget {
  final String initials;
  final Color textColor;
  final double? fontSize;

  const _AvatarInitialsFallback({
    required this.initials,
    required this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          initials.isNotEmpty ? initials : '?',
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: fontSize ?? 24,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
