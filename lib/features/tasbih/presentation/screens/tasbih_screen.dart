import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:azkary/l10n/app_localizations.dart';
import 'package:azkary/features/tasbih/presentation/providers/tasbih_providers.dart';

class TasbihScreen extends ConsumerStatefulWidget {
  const TasbihScreen({super.key});

  @override
  ConsumerState<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends ConsumerState<TasbihScreen> {
  @override
  void initState() {
    super.initState();
    _checkVibrationCapability();
  }

  Future<void> _checkVibrationCapability() async {
    try {
      final canVibrate = await Vibration.hasVibrator() ?? false;
      ref.read(canVibrateProvider.notifier).state = canVibrate;
    } catch (e) {
      ref.read(canVibrateProvider.notifier).state = false;
    }
  }

  Future<void> _handleVibration() async {
    final canVibrate = ref.read(canVibrateProvider);
    final shouldVibrate = ref.read(vibrateProvider);
    
    if (canVibrate && shouldVibrate) {
      try {
        Vibration.vibrate(duration: 50);
      } catch (e) {
        // Silently handle vibration errors
        debugPrint('Vibration error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(tasbihCountProvider);
    final targetCount = ref.watch(targetCountProvider);
    final shouldVibrate = ref.watch(vibrateProvider);
    final canVibrate = ref.watch(canVibrateProvider);
    final l10n = AppLocalizations.of(context)!;
    final names = ref.watch(namesOfAllahProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.digitalTasbih),
        centerTitle: true,
        actions: [
          if (canVibrate) IconButton(
            icon: Icon(
              shouldVibrate ? Icons.vibration : Icons.notifications_off_outlined,
            ),
            onPressed: () {
              ref.read(vibrateProvider.notifier).state = !shouldVibrate;
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.target(targetCount),
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                if (count < targetCount) {
                  await _handleVibration();
                  ref.read(tasbihCountProvider.notifier).state = count + 1;
                }
              },
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withAlpha(100),
                ),
                child: Center(
                  child: Text(
                    targetCount == 99 && count < 99 ? names[count] : count.toString(),
                    style: TextStyle(
                      fontSize: targetCount == 99 ? 40.sp : 60.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                  .animate(target: count < targetCount ? 1 : 0)
                  .scale(duration: 200.ms, curve: Curves.easeOut),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(tasbihCountProvider.notifier).state = 0;
                  },
                  iconSize: 30.w,
                ),
                SizedBox(width: 20.w),
                PopupMenuButton<int>(
                  initialValue: targetCount,
                  onSelected: (value) {
                    ref.read(targetCountProvider.notifier).state = value;
                    ref.read(tasbihCountProvider.notifier).state = 0;
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 33,
                      child: Text('33 (${l10n.tasbih})'),
                    ),
                    PopupMenuItem(
                      value: 100,
                      child: Text('100 (${l10n.century})'),
                    ),
                    PopupMenuItem(
                      value: 99,
                      child: Text('99 (${l10n.namesOfAllah})'),
                    ),
                  ],
                  child: Icon(
                    Icons.settings,
                    size: 30.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 