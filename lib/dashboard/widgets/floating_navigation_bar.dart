import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A fun, Material 3 bottom navigation bar with a gooey/liquid transition
/// effect between destinations.
///
/// How the gooey effect works:
///   * Each tab has its own colored "blob" anchored at the center of its cell.
///   * When the user taps a new tab, two things happen over time:
///       1. The newly-selected blob grows from 0 -> full pill radius
///          (elasticOut for that satisfying bouncy settle).
///       2. The previously-selected blob shrinks from full -> 0
///          (easeInCubic so it deflates gently).
///   * While both are at significant size, their feathered radial gradients
///     overlap and merge visually into a single liquid mass that appears to
///     flow from the old slot to the new one.
///   * A gaussian blur shader is applied to the entire painted layer,
///     blending the edges into a smooth metaball-style fill.
///
/// M3 details:
///   * Uses the M3 ColorScheme tokens for ink ripples + state layers.
///   * The active icon "lifts" using AnimatedScale with easeOutBack.
///   * Tap triggers a light haptic for tactile feedback.
class FloatingNavigation extends StatefulWidget {
  const FloatingNavigation({
    required this.selectedIndex,
    required this.onItemSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  /// Per-destination brand color. Drives the liquid gradient.
  static const List<Color> _palette = [
    Color(0xFF2F80ED), // Home — blue
    Color(0xFF6D5DFB), // Grades — purple
    Color(0xFF32A89D), // Balance — teal
    Color(0xFFFF8E53), // Attend — orange
    Color(0xFF7B61FF), // Schedule — indigo
  ];

  static const List<_NavigationItem> _items = [
    _NavigationItem(icon: Icons.home_rounded, label: 'Home'),
    _NavigationItem(icon: Icons.assessment_rounded, label: 'Grades'),
    _NavigationItem(icon: Icons.monetization_on_rounded, label: 'Balance'),
    _NavigationItem(icon: Icons.how_to_reg_rounded, label: 'Attend'),
    _NavigationItem(icon: Icons.calendar_month_rounded, label: 'Schedule'),
  ];

  @override
  State<FloatingNavigation> createState() => _FloatingNavigationState();
}

class _FloatingNavigationState extends State<FloatingNavigation>
    with TickerProviderStateMixin {
  /// Drives the "blob" sizes during a transition.
  late final AnimationController _morphController;

  /// Drives the icon "lift" on the freshly-tapped destination.
  late final AnimationController _bounceController;
  late final Animation<double> _bounce;

  /// Sizes[i] is the visual radius multiplier for tab i (0..1).
  /// Computed each frame from _morphController's value + selectedIndex.
  late List<double> _sizes;

  /// Index of the icon that should currently be lifted (the freshly tapped).
  int _bouncingIndex = 0;

  @override
  void initState() {
    super.initState();
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _bounce = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.28)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.28, end: 0.94)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.94, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 32,
      ),
    ]).animate(_bounceController);

    _sizes = List.filled(FloatingNavigation._items.length, 0.0);
    _sizes[widget.selectedIndex] = 1.0;
    _bouncingIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant FloatingNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _runMorph(
        from: oldWidget.selectedIndex,
        to: widget.selectedIndex,
      );
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _runMorph({required int from, required int to}) {
    _morphController.stop();
    _bounceController.forward(from: 0);
    HapticFeedback.lightImpact();

    setState(() => _bouncingIndex = to);

    _morphController.value = 0;
    _morphController
        .animateTo(
      1.0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
    )
        .whenComplete(() {
      if (mounted) {
        setState(() {
          for (int i = 0; i < _sizes.length; i++) {
            _sizes[i] = i == to ? 1.0 : 0.0;
          }
        });
      }
    });
    // Drive the per-frame size interpolation.
    void listener() {
      final t = _morphController.value;
      // easeOutElastic-like growth for the new blob.
      final grow = Curves.elasticOut.transform(t);
      // easeInCubic decay for the old blob.
      final shrink = 1.0 - Curves.easeInCubic.transform(t);
      if (!mounted) return;
      setState(() {
        for (int i = 0; i < _sizes.length; i++) {
          if (i == to) {
            _sizes[i] = grow.clamp(0.0, 1.0);
          } else if (i == from) {
            _sizes[i] = shrink.clamp(0.0, 1.0);
          } else {
            _sizes[i] = 0.0;
          }
        }
      });
    }

    _morphController.removeListener(listener);
    _morphController.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const items = FloatingNavigation._items;
    const palette = FloatingNavigation._palette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cellWidth = width / items.length;
        // Blob radius: slightly larger than half the cell so the feathered
        // edges fully cover the slot.
        final maxRadius = cellWidth * 0.42;
        final barHeight = 80.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: SizedBox(
            width: width,
            height: barHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(barHeight / 2),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Stack(
                  children: [
                    // 1. Glass background surface
                    Container(
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.86),
                        borderRadius:
                            BorderRadius.circular(barHeight / 2),
                        border: Border.all(
                          color:
                              scheme.outlineVariant.withValues(alpha: 0.4),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                          BoxShadow(
                            color:
                                scheme.primary.withValues(alpha: 0.16),
                            blurRadius: 22,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                    ),
                    // 2. Gooey liquid layer — painted blobs with feathered
                    //    radial gradients + a gaussian blur for the merge.
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _GooeyBlobsPainter(
                            cellWidth: cellWidth,
                            maxRadius: maxRadius,
                            sizes: _sizes,
                            colors: palette,
                          ),
                        ),
                      ),
                    ),
                    // 3. Tappable row of items on top
                    Row(
                      children: List.generate(items.length, (i) {
                        final item = items[i];
                        return Expanded(
                          child: _NavItem(
                            key: ValueKey('goo-nav-${item.label.toLowerCase()}'),
                            icon: item.icon,
                            label: item.label,
                            activeColor: palette[i],
                            inactiveColor: scheme.onSurfaceVariant,
                            shouldBounce: _bouncingIndex == i,
                            bounce: _bounce,
                            onTap: () {
                              if (i != widget.selectedIndex) {
                                widget.onItemSelected(i);
                              } else {
                                // Re-tap: still give a small bounce.
                                HapticFeedback.selectionClick();
                                _bounceController.forward(from: 0);
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A single navigation destination cell — icon + label with M3 ripple,
/// a bouncy icon scale, and a label that only shows on the active item.
class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.inactiveColor,
    required this.shouldBounce,
    required this.bounce,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color activeColor;
  final Color inactiveColor;
  final bool shouldBounce;
  final Animation<double> bounce;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        // M3 state layer (very subtle).
        splashColor: activeColor.withValues(alpha: 0.18),
        highlightColor: activeColor.withValues(alpha: 0.10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: bounce,
                builder: (context, child) {
                  final scale = shouldBounce ? bounce.value : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Icon(
                  icon,
                  size: 26,
                  color: shouldBounce ? activeColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                  color: shouldBounce ? activeColor : inactiveColor,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints the gooey liquid layer.
///
/// For each tab we draw a feathered radial gradient circle at the cell
/// center, scaled by [sizes]. The gradients blend additively in the
/// overlap region, and the entire layer is then blurred by [sigma] to
/// produce the metaball-style fill that "connects" multiple blobs.
class _GooeyBlobsPainter extends CustomPainter {
  _GooeyBlobsPainter({
    required this.cellWidth,
    required this.maxRadius,
    required this.sizes,
    required this.colors,
  });

  final double cellWidth;
  final double maxRadius;
  final List<double> sizes;
  final List<Color> colors;

  // The blur amount applied to the liquid. Higher = more "gooey".
  static const double _sigma = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1: blur the merged gradients for the gooey effect.
    final blurPaint = Paint()
      ..imageFilter = ui.ImageFilter.blur(
        sigmaX: _sigma,
        sigmaY: _sigma,
        tileMode: TileMode.clamp,
      )
      ..blendMode = BlendMode.srcOver;

    canvas.saveLayer(Offset.zero & size, blurPaint);

    for (int i = 0; i < sizes.length; i++) {
      final s = sizes[i];
      if (s <= 0.001) continue;
      final center = Offset(
        cellWidth * i + cellWidth / 2,
        size.height / 2,
      );
      // The pill stretches slightly in X so the liquid hugs the icon
      // area but the gradient is round enough to look organic.
      final radius = maxRadius * s;
      // Feathered gradient: opaque at center, fully transparent at the
      // edge. The blur on the parent layer merges overlapping gradients
      // into a smooth mass.
      final shader = ui.Gradient.radial(
        center,
        radius,
        [
          colors[i].withValues(alpha: 0.95),
          colors[i].withValues(alpha: 0.85),
          colors[i].withValues(alpha: 0.0),
        ],
        const [0.0, 0.45, 1.0],
      );
      final p = Paint()..shader = shader;
      canvas.drawCircle(center, radius, p);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GooeyBlobsPainter old) {
    if (old.cellWidth != cellWidth || old.maxRadius != maxRadius) {
      return true;
    }
    if (old.colors.length != colors.length) return true;
    for (int i = 0; i < sizes.length; i++) {
      if (old.sizes[i] != sizes[i]) return true;
      if (old.colors[i] != colors[i]) return true;
    }
    return false;
  }
}

class _NavigationItem {
  const _NavigationItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
