import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const FortuneCookieApp());

class FortuneCookieApp extends StatelessWidget {
  const FortuneCookieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FortuneCookieScreen(),
    );
  }
}

class FortuneCookieScreen extends StatefulWidget {
  const FortuneCookieScreen({Key? key}) : super(key: key);

  @override
  State<FortuneCookieScreen> createState() => _FortuneCookieScreenState();
}

class _FortuneCookieScreenState extends State<FortuneCookieScreen>
    with TickerProviderStateMixin {
  bool _cracked = false;
  String _fortune = "";
  bool _firstShown = false; // ensure first crack shows special message

  late AnimationController _controller;
  late Animation<double> spreadAnim, slipAnim, crumbsAnim;

  // sparkles controller (replaces confetti)
  late AnimationController _sparkController;
  late Animation<double> _sparkAnim;

  final List<String> fortunes = [
    "✨ The universe is smiling at you today.",
    "🌻 A sunflower blooms wherever you go.",
    "⭐ A little stardust follows you around.",
    "🌸 Happiness blossoms in your presence.",
    "🌞 Your light shines brighter than the sun.",
    "💫 Every step you take leaves sparkles behind.",
    "🌿 Peace finds you when you least expect it.",
    "🍀 Lucky energy surrounds you today.",
    "🌈 A rainbow is waiting just for you.",
    "🌟 You’re meant to do extraordinary things.",
    "💐 Beauty grows wherever you plant kindness.",
    "🌻 Like a sunflower, you always face the light.",
    "🌌 The stars whisper your name tonight.",
    "🌸 18th is your day",
    "☀️ Your smile is brighter than the sunrise.",
    "🌠 Dreams are aligning in your favor.",
    "🕊️ Serenity is walking beside you.",
    "🔥 Passion fuels your brightest moments.",
    "🌙 The moon keeps you safe in the night.",
    "⭐ Someone wishes on you like a star.",
    "💎 You are rarer than the finest gem.",
    "🌻 Golden warmth surrounds your spirit.",
    "🍯 Sweetness flows from your heart.",
    "🌞 Today is made brighter because of you.",
    "🌸 A gentle breeze carries good news.",
    "💫 Destiny is painting with your colors.",
    "🌿 Calm energy fills your soul.",
    "🌹 Your kindness makes hearts bloom.",
    "⭐ Even galaxies admire your shine.",
    "🌼 Simple joys become magic near you.",
    "🌟 Good fortune walks with you today.",
    "🌙 You glow softly, like moonlight on water.",
    "💐 Life gives bouquets to souls like you.",
    "🌻 Every day, you rise taller like the sunflower.",
    "🍃 Fresh beginnings follow your footsteps.",
    "✨ Miracles dance quietly around you.",
    "🌞 The sun greets you with extra warmth.",
    "🌸 Joy grows naturally in your path.",
    "⭐ You’re a guiding star to someone.",
    "🌹 Grace flows through your presence.",
    "🌻 Hope grows endlessly inside you.",
    "🌌 You belong to the brightest constellations.",
    "☀️ You bring warmth even on cloudy days.",
    "🌠 A wish made today will come true soon.",
    "💫 Magic finds you when you least expect it.",
    "🌿 Peace is your hidden superpower.",
    "🌞 A golden chapter begins now.",
    "🌟 Fortune favors your gentle heart.",
    "🌻 Like the sun, you rise every day.",
    "✨ You are proof that light always wins.",
    "🌙 The night sky shines brighter with you in it.",
  ];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    setupAnimations();

    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _sparkAnim = CurvedAnimation(parent: _sparkController, curve: Curves.easeOut);

    // play sparkles once when app opens
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _sparkController.forward();
    });

    // set initial fortune to empty; first crack will show birthday message
  }

  void setupAnimations() {
    spreadAnim = Tween<double>(begin: 0, end: 60).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    slipAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    crumbsAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  void _crackCookie() {
    if (_cracked) return;
    setState(() {
      _cracked = true;
      if (!_firstShown) {
        _fortune = "🎂 Happy Birthday! You bloom like a Sunflower 🌻";
        _firstShown = true;
      } else {
        _fortune = fortunes[Random().nextInt(fortunes.length)];
      }
    });
    _controller.forward();
  }

  void _reset() {
    setState(() {
      _cracked = false;
      _fortune = "";
    });
    _controller.reset();
  }

  void _showBirthdayMessage() {
    const msg =
        "Happy birthday from the fortune cookie! We randomly pick special birthdays — the 13th is our day. Happy bday! 🎂";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(msg),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.deepOrange.shade200,
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Surprise 🎉",
              style: GoogleFonts.pacifico(color: Colors.deepOrange.shade700)),
          content: Text(msg, style: TextStyle(color: Colors.brown.shade800)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _sparkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // warm yellow/brown palette for heading background pill
    final headingBg = BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.yellow.shade200, Colors.brown.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.brown.shade200.withOpacity(0.4),
          offset: const Offset(0, 4),
          blurRadius: 8,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("🍪 Fortune Cookie"),
        backgroundColor: Colors.brown,
      ),
      body: Stack(
        children: [
          // main column centered horizontally but placed slightly lower so heading sits under app bar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // heading pill (yellow / brown aesthetic)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: headingBg,
                    child: Text(
                      "Lucky you, happy birthday",
                      style: GoogleFonts.pacifico(
                        fontSize: 18,
                        color: Colors.brown.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // sparkles animation (subtle) placed under heading
                  SizedBox(height: 36, width: MediaQuery.of(context).size.width),
                  SizedBox(
                    height: 28,
                    child: Center(child: _buildSparkles()),
                  ),

                  const SizedBox(height: 10),

                  // cookie area centered below sparkles
                ],
              ),
            ),
          ),

          // center cookie and controls
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 220,
                  height: 160,
                  child: Center(
                    child: Cookie(cracked: _cracked, spreadAnim: spreadAnim),
                  ),
                ),

                const SizedBox(height: 8),
                if (!_cracked)
                  ElevatedButton(
                    onPressed: _crackCookie,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade200,
                      shape: const StadiumBorder(),
                      elevation: 4,
                    ),
                    child: const Text("Crack open to see your fortune",
                        style: TextStyle(color: Colors.brown)),
                  ),

                if (_cracked)
                  PaperSlip(controller: _controller, slipAnim: slipAnim, fortune: _fortune),

                if (_cracked) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade100,
                      shape: const StadiumBorder(),
                      elevation: 3,
                    ),
                    child: const Text("Reset",
                        style: TextStyle(color: Colors.purple)),
                  )
                ],

                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _showBirthdayMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    shape: const StadiumBorder(),
                    elevation: 3,
                  ),
                  child: const Text("Open a Birthday Message"),
                ),
              ],
            ),
          ),

          // crumbs overlay (same as before)
          Crumbs(cracked: _cracked, crumbsAnim: crumbsAnim),
        ],
      ),
    );
  }

  // --- subtle sparkles animation widget ---
  Widget _buildSparkles() {
    // pre-chosen sparkle positions so they don't jump on repaint
    final sparkPositions = [
      Offset(-80, 0),
      Offset(-40, -4),
      Offset(0, -2),
      Offset(40, -4),
      Offset(80, 0),
    ];

    final colors = [
      Colors.yellow.shade300,
      Colors.yellow.shade200,
      Colors.amber.shade200,
      Colors.yellow.shade100,
      Colors.brown.shade200,
    ];

    return AnimatedBuilder(
      animation: _sparkController,
      builder: (context, child) {
        final t = _sparkAnim.value;
        if (t == 0) return const SizedBox(width: 200, height: 28);

        // opacity pulses and each sparkle scales slightly
        return SizedBox(
          width: 220,
          height: 28,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(sparkPositions.length, (i) {
              final pos = sparkPositions[i];
              // spread factor: moves sparkles outward a bit while fading in
              final dx = pos.dx * (0.15 + 0.85 * t);
              final dy = pos.dy * (0.15 + 0.85 * t);
              final scale = 0.6 + 0.8 * t;
              final opacity = 0.15 + 0.85 * t;

              return Positioned(
                left: 110 + dx,
                top: 6 + dy,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: scale,
                    child: Icon(
                      Icons.star_rounded,
                      size: 10,
                      color: colors[i],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

//// ---------------- Widgets ----------------

class Cookie extends StatelessWidget {
  final bool cracked;
  final Animation<double> spreadAnim;
  const Cookie({Key? key, required this.cracked, required this.spreadAnim})
      : super(key: key);

  Widget _buildHalf(bool left) {
    return CustomPaint(size: const Size(100, 100), painter: CookieHalfPainter(left));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: spreadAnim,
      builder: (_, __) {
        return cracked
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
                offset: Offset(-spreadAnim.value, 0),
                child: _buildHalf(true)),
            Transform.translate(
                offset: Offset(spreadAnim.value, 0),
                child: _buildHalf(false)),
          ],
        )
            : SizedBox(
            width: 150,
            height: 150,
            child: CustomPaint(painter: WholeCookiePainter()));
      },
    );
  }
}

class PaperSlip extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> slipAnim;
  final String fortune;
  const PaperSlip(
      {Key? key,
        required this.controller,
        required this.slipAnim,
        required this.fortune})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, slipAnim.value),
        child: Opacity(
          opacity: controller.value,
          child: CustomPaint(
            painter: PaperSlipPainter(),
            child: Container(
              width: 260,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              alignment: Alignment.center,
              child: Text(fortune,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pacifico(fontSize: 18, color: Colors.deepOrange)),
            ),
          ),
        ),
      ),
    );
  }
}

class Crumbs extends StatelessWidget {
  final bool cracked;
  final Animation<double> crumbsAnim;
  const Crumbs({Key? key, required this.cracked, required this.crumbsAnim})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: crumbsAnim,
      builder: (_, __) {
        if (!cracked) return const SizedBox.shrink();
        final rand = Random();
        return Stack(
          children: List.generate(12, (i) {
            final angle = rand.nextDouble() * 2 * pi;
            final dist = (20 + rand.nextDouble() * 80) * crumbsAnim.value;
            final dx = cos(angle) * dist;
            final dy = sin(angle) * dist;
            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + dx,
              top: MediaQuery.of(context).size.height / 2 + dy,
              child: Transform.scale(
                scale: crumbsAnim.value,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

//// ---------------- Painters ----------------

class WholeCookiePainter extends CustomPainter {
  final List<Offset> _dots = List.generate(
      22,
          (_) => Offset(Random().nextDouble() * 80 - 40,
          Random().nextDouble() * 80 - 40));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const r = 70.0;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.orange.shade500, Colors.brown.shade600],
      ).createShader(Rect.fromCircle(center: center, radius: r));

    Path path = Path();
    for (int i = 0; i <= 50; i++) {
      final angle = (2 * pi / 50) * i;
      final jitter = (i % 5 == 0) ? -5 : (i % 3 == 0 ? 3 : 0);
      final x = center.dx + (r + jitter) * cos(angle);
      final y = center.dy + (r + jitter) * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = Colors.brown.shade700;
    for (final d in _dots) {
      canvas.drawCircle(center + d, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CookieHalfPainter extends CustomPainter {
  final bool left;
  CookieHalfPainter(this.left);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.orange.shade500, Colors.brown.shade600],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    if (left) {
      path.addArc(Rect.fromLTWH(0, 0, size.width, size.height), pi / 2, pi);
      for (double y = 0; y <= size.height; y += 12) {
        path.lineTo(size.width / 2 + (y % 24 == 0 ? -6 : 6), y);
      }
    } else {
      path.addArc(Rect.fromLTWH(0, 0, size.width, size.height), -pi / 2, pi);
      for (double y = 0; y <= size.height; y += 12) {
        path.lineTo(size.width / 2 + (y % 24 == 0 ? 6 : -6), y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PaperSlipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final path = Path();
    const curve = 15.0;
    path.moveTo(curve, 0);
    path.quadraticBezierTo(0, size.height / 2, curve, size.height);
    path.lineTo(size.width - curve, size.height);
    path.quadraticBezierTo(size.width, size.height / 2, size.width - curve, 0);
    path.close();

    canvas.drawShadow(path, Colors.black26, 4, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
