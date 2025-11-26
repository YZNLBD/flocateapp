import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';

/// Modern Gradient Button with smooth animations and shadows
class ModernGradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final List<Color>? gradientColors;
  final bool isLoading;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final TextStyle? labelStyle;
  final bool fullWidth;

  const ModernGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradientColors,
    this.isLoading = false,
    this.borderRadius = 16,
    this.verticalPadding = 14,
    this.horizontalPadding = 24,
    this.labelStyle,
    this.fullWidth = true,
  });

  @override
  State<ModernGradientButton> createState() => _ModernGradientButtonState();
}

class _ModernGradientButtonState extends State<ModernGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ??
        [Colors.purple.shade400, Colors.blue.shade400];

    final buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (widget.icon != null && !widget.isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        if (widget.isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          ),
        Text(
          widget.label,
          style: widget.labelStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        if (!widget.isLoading) {
          widget.onPressed();
        }
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: colors.first.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: InkWell(
              onTap: widget.isLoading ? null : () => widget.onPressed(),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.verticalPadding,
                  horizontal: widget.horizontalPadding,
                ),
                child: widget.fullWidth
                    ? buttonContent
                    : SizedBox(
                        width: null,
                        child: buttonContent,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern Glassmorphic Card with blur effect
class ModernGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double opacity;
  final bool hasBorder;
  final BoxShadow? customShadow;

  const ModernGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
    this.opacity = 0.95,
    this.hasBorder = true,
    this.customShadow,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: hasBorder
                ? Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.5,
                  )
                : null,
            boxShadow: [
              customShadow ??
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Modern Profile Picture Widget with edit capability
class ModernProfilePicture extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final double size;
  final VoidCallback? onEditPressed;
  final String? initials;
  final Color? backgroundColor;
  final Color? iconColor;

  const ModernProfilePicture({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.size = 140,
    this.onEditPressed,
    this.initials,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  )
                : imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                    : _buildPlaceholder(),
          ),
        ),
        if (onEditPressed != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onEditPressed,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.camera_alt,
                      size: 24,
                      color: Colors.purple.shade400,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: backgroundColor ?? Colors.purple.shade100,
      child: Center(
        child: initials != null
            ? Text(
                initials!,
                style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: iconColor ?? Colors.purple.shade400,
                ),
              )
            : Icon(
                Icons.person,
                size: size * 0.57,
                color: iconColor ?? Colors.purple.shade400,
              ),
      ),
    );
  }
}

/// Modern Gradient Background
class ModernGradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final Alignment? begin;
  final Alignment? end;

  const ModernGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColors = colors ??
        [
          Colors.blue.shade50,
          Colors.purple.shade50,
        ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: defaultColors,
          begin: begin ?? Alignment.topLeft,
          end: end ?? Alignment.bottomRight,
        ),
      ),
      child: SizedBox.expand(
        child: child,
      ),
    );
  }
}

/// Modern Settings Tile with icon and description
class ModernSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData? trailingIcon;
  final Color? iconColor;
  final Widget? trailing;

  const ModernSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailingIcon,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.purple.shade400,
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!)
          : null,
      trailing: trailing ??
          (trailingIcon != null
              ? Icon(
                  trailingIcon,
                  color: Colors.purple.shade300,
                  size: 18,
                )
              : null),
      onTap: onTap,
    );
  }
}

/// Modern Header with gradient and title
class ModernHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Color>? gradientColors;
  final double height;
  final Widget? child;

  const ModernHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.gradientColors,
    this.height = 200,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [
          Colors.blue.shade400,
          Colors.purple.shade400,
        ];

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
            ],
          ),
          if (child != null)
            Positioned.fill(
              child: child!,
            ),
        ],
      ),
    );
  }
}

/// Modern Input Field with gradient border
class ModernInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final Color? accentColor;

  const ModernInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.accentColor,
  });

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? Colors.purple.shade400;

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: _isFocused ? accentColor : Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: accentColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: _isFocused ? accentColor.withOpacity(0.05) : Colors.grey.shade50,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: _isFocused ? accentColor : Colors.grey.shade600,
              )
            : null,
      ),
    );
  }
}

/// Modern Expandable Card for sections
class ModernExpandableCard extends StatefulWidget {
  final String title;
  final Widget content;
  final IconData icon;
  final Color? iconColor;
  final bool initiallyExpanded;

  const ModernExpandableCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    this.iconColor,
    this.initiallyExpanded = true,
  });

  @override
  State<ModernExpandableCard> createState() => _ModernExpandableCardState();
}

class _ModernExpandableCardState extends State<ModernExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    if (_isExpanded) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModernGlassCard(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              _isExpanded
                  ? _controller.forward()
                  : _controller.reverse();
            },
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.iconColor ?? Colors.purple.shade400,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                RotationTransition(
                  turns: Tween<double>(begin: 0, end: 0.5)
                      .animate(_controller),
                  child: Icon(
                    Icons.expand_more,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOut,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: Colors.grey.shade200,
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  widget.content,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern Stat Card for displaying metrics
class ModernStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final List<Color> gradientColors;

  const ModernStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.gradientColors = const [Colors.purple, Colors.blue],
  });

  @override
  Widget build(BuildContext context) {
    return ModernGlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
