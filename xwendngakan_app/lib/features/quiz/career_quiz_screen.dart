import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class QuizOption {
  final String text;
  final String emoji;
  final String category; // 'tech', 'med', 'biz', 'law', 'art', 'lang'
  final int points;

  const QuizOption({
    required this.text,
    required this.emoji,
    required this.category,
    this.points = 10,
  });
}

class QuizQuestion {
  final String title;
  final String subtitle;
  final String emoji;
  final List<QuizOption> options;

  const QuizQuestion({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.options,
  });
}

class CareerQuizScreen extends StatefulWidget {
  const CareerQuizScreen({super.key});

  @override
  State<CareerQuizScreen> createState() => _CareerQuizScreenState();
}

class _CareerQuizScreenState extends State<CareerQuizScreen> {
  int _currentIndex = 0;
  final Map<String, int> _scores = {
    'tech': 0,
    'med': 0,
    'biz': 0,
    'law': 0,
    'art': 0,
    'lang': 0,
  };

  bool _isFinished = false;

  final List<QuizQuestion> _questions = const [
    QuizQuestion(
      title: 'لە چ ژینگەیەکی کارکردندا ئاسوودەیت؟',
      subtitle: 'شوێنی کارکردنی داهاتووت هەڵبژێرە',
      emoji: '🏢',
      options: [
        QuizOption(
          text: 'لە تاقیگە، کلینیک یان نەخۆشخانە بۆ چارەسەری نەخۆش',
          emoji: '🏥',
          category: 'med',
        ),
        QuizOption(
          text: 'لە ژوورێکی ئارام لەسەر کۆمپیوتەر و داهێنانی تەکنەلۆژی',
          emoji: '💻',
          category: 'tech',
        ),
        QuizOption(
          text: 'لە کۆمپانیای گەورە، نووسینگەی بازرگانی و کۆبوونەوەکان',
          emoji: '📈',
          category: 'biz',
        ),
        QuizOption(
          text: 'لە دادگا، فەرمانگە یان دەزگای داکۆکیکردن لە مافی مرۆڤ',
          emoji: '⚖️',
          category: 'law',
        ),
        QuizOption(
          text: 'لە ستۆدیۆ، ناوەندی هونەری یان دیزاین و وێنەگرتن',
          emoji: '🎨',
          category: 'art',
        ),
      ],
    ),
    QuizQuestion(
      title: 'کاتێک ڕووبەڕووی کێشەیەک دەبیتەوە، چۆن چارەسەری دەکەیت؟',
      subtitle: 'شێوازی بیرکردنەوەت هەڵبژێرە',
      emoji: '🧠',
      options: [
        QuizOption(
          text: 'شیکاری لۆجیکی و بیرکاری بەکاردێنم تا بە تەواوی دەیدۆزمەوە',
          emoji: '🔍',
          category: 'tech',
        ),
        QuizOption(
          text: 'بە ئارامی گوێ دەگرم و لە ڕووی مرۆیی و دەروونییەوە چارەسەری دەکەم',
          emoji: '🤝',
          category: 'med',
        ),
        QuizOption(
          text: 'حساباتی قازانج و زیان و باشترین پلان دادەنێم',
          emoji: '📊',
          category: 'biz',
        ),
        QuizOption(
          text: 'بەڵگە و یاسا و مافەکان کۆدەکەمەوە بۆ بەرگریکردن',
          emoji: '📜',
          category: 'law',
        ),
        QuizOption(
          text: 'بە گفتوگۆی ڕوون و پەیوەندی کاریگەر قەناعەتی پێدێنم',
          emoji: '🗣️',
          category: 'lang',
        ),
      ],
    ),
    QuizQuestion(
      title: 'لە قۆناغی ئامادەیی (پۆلی ١٢) کام بابەتەت زیاتر خۆشدەویست؟',
      subtitle: 'حەز و بەهرەی خوێندنت',
      emoji: '📚',
      options: [
        QuizOption(
          text: 'زیندەزانی (بایۆلۆجی) و کیمیا',
          emoji: '🧬',
          category: 'med',
        ),
        QuizOption(
          text: 'بیرکاری، فیزیا و تەکنەلۆژیا',
          emoji: '📐',
          category: 'tech',
        ),
        QuizOption(
          text: 'ئابووری، بەڕێوەبردن و بازرگانی',
          emoji: '💰',
          category: 'biz',
        ),
        QuizOption(
          text: 'مێژوو، زانستی کۆمەڵایەتی و ڕامیاری',
          emoji: '🏛️',
          category: 'law',
        ),
        QuizOption(
          text: 'زمانەکانی ئینگلیزی، کوردی یان زمانی بیانی تر',
          emoji: '🌍',
          category: 'lang',
        ),
      ],
    ),
    QuizQuestion(
      title: 'نمرەی گشتی پێشبینیکراوت لە چ سنوورێکدایە؟',
      subtitle: 'بۆ ئەوەی بەشە پێشنیارکراوەکان لەگەڵ دەرفەتت بگونجێن',
      emoji: '🎯',
      options: [
        QuizOption(
          text: 'نمرەی بەرز (٩٠ تا ١٠٠)',
          emoji: '🌟',
          category: 'med',
          points: 15,
        ),
        QuizOption(
          text: 'نمرەی زۆر باش (٨٠ تا ٨٩)',
          emoji: '⭐',
          category: 'tech',
          points: 12,
        ),
        QuizOption(
          text: 'نمرەی باش (٧٠ تا ٧٩)',
          emoji: '✨',
          category: 'biz',
          points: 10,
        ),
        QuizOption(
          text: 'نمرەی مامناوەند (٦٠ تا ٦٩)',
          emoji: '🔹',
          category: 'law',
          points: 10,
        ),
        QuizOption(
          text: 'نمرەی دەرچوون (٥٠ تا ٥٩)',
          emoji: '🔸',
          category: 'art',
          points: 10,
        ),
      ],
    ),
    QuizQuestion(
      title: 'ئەگەر پرۆژەیەکی ئازادت پێبدرێت، کامیان هەڵدەبژێریت؟',
      subtitle: 'خولیای داهێنانی خۆت',
      emoji: '🚀',
      options: [
        QuizOption(
          text: 'دروستکردنی ئەپڵیکەیشن یان وێبسایتێکی نوێ',
          emoji: '📱',
          category: 'tech',
        ),
        QuizOption(
          text: 'بەشداریکردن لە کەمپەینێکی پشکنین و فریاگوزاری تەندروستی',
          emoji: '🩺',
          category: 'med',
        ),
        QuizOption(
          text: 'دەستپێکردنی کارێکی بازرگانی و کۆکردنەوەی داهات',
          emoji: '💼',
          category: 'biz',
        ),
        QuizOption(
          text: 'دروستکردنی ڤیدیۆ، دیزاین یان ناوەڕۆکی سۆشیال میدیا',
          emoji: '🎬',
          category: 'art',
        ),
        QuizOption(
          text: 'وەرگێڕانی پەڕتووکێک یان فێرکردنی زمان بە گەنجان',
          emoji: '📖',
          category: 'lang',
        ),
      ],
    ),
    QuizQuestion(
      title: 'چ جۆرە ژیانێکی پیشەیی بە لای تۆوە سەرکەوتنە؟',
      subtitle: 'ئامانجی گەورەی تۆ لە ژیان',
      emoji: '🏆',
      options: [
        QuizOption(
          text: 'ڕزگارکردنی ژیانی مرۆڤەکان و هێنانەدی تەندروستی باشتر',
          emoji: '❤️',
          category: 'med',
        ),
        QuizOption(
          text: 'داهێنانی شتێکی نوێ کە هەزاران کەس ڕۆژانە بەکاری بهێنن',
          emoji: '💡',
          category: 'tech',
        ),
        QuizOption(
          text: 'سەربەخۆیی دارایی و بوون بە سەرکردە یان خاوەنکاری سەرکەوتوو',
          emoji: '💎',
          category: 'biz',
        ),
        QuizOption(
          text: 'چەسپاندنی دادپەروەری و بەرگریکردن لە مافی ستەملێکراوان',
          emoji: '⚖️',
          category: 'law',
        ),
        QuizOption(
          text: 'کاریگەری لەسەر جیهان لە ڕێگەی هونەر، وێنە و بیرۆکەی جوانەوە',
          emoji: '🎭',
          category: 'art',
        ),
      ],
    ),
    QuizQuestion(
      title: 'حەزت لە کارکردنە لەگەڵ خەڵکدا یان کارکردنی سەربەخۆ؟',
      subtitle: 'ستایلی پەیوەندیکردنت',
      emoji: '👥',
      options: [
        QuizOption(
          text: 'حەزم لە پەیوەندی بەردەوامە لەگەڵ خەڵک و نەخۆشەکان',
          emoji: '👨‍⚕️',
          category: 'med',
        ),
        QuizOption(
          text: 'حەزم بە کارکردنی وردە لەسەر شاشە و چارەسەری کۆد بە تەنیا',
          emoji: '👨‍💻',
          category: 'tech',
        ),
        QuizOption(
          text: 'حەزم لە ڕێکخستنی تیم، بەڕێوەبردن و دابەشکردنی ئەرکەکانە',
          emoji: '👔',
          category: 'biz',
        ),
        QuizOption(
          text: 'حەزم لە وتاربێژی، مشتومڕ و بەرگریکردنی ڕووبەڕووە',
          emoji: '🗣️',
          category: 'law',
        ),
        QuizOption(
          text: 'حەزم لە فێرکردن و پێگەیاندنی نەوەی نوێیە',
          emoji: '🧑‍🏫',
          category: 'lang',
        ),
      ],
    ),
    QuizQuestion(
      title: 'لە نێوان خوێندنی زانستی تیۆری و پراکتیکی (دەستی)، کامیان پێ باشترە؟',
      subtitle: 'شێوازی فێربوونت',
      emoji: '🛠️',
      options: [
        QuizOption(
          text: 'پراکتیکی لە تاقیگە پزیشکییەکان و نەشتەرگەری',
          emoji: '🔬',
          category: 'med',
        ),
        QuizOption(
          text: 'شیکاری داتا و نەرمەکاڵا و بەستنی تەکنەلۆژیای نوێ',
          emoji: '⚙️',
          category: 'tech',
        ),
        QuizOption(
          text: 'شارەزابوون لە بازاڕ، تەکنیکی فرۆشتن و دارایی',
          emoji: '🏷️',
          category: 'biz',
        ),
        QuizOption(
          text: 'خوێندنەوەی بەردەوامی کتێب و دەقە یاسایی و مێژووییەکان',
          emoji: '📚',
          category: 'law',
        ),
        QuizOption(
          text: 'کاری بینراو، گرافیک، ستایڵ و وێنەکێشان',
          emoji: '🖌️',
          category: 'art',
        ),
      ],
    ),
    QuizQuestion(
      title: 'ئارەزووت لە فێربوونی زمان و پەیوەندی جیهانی چەندە؟',
      subtitle: 'ئاسۆی جیهانی تۆ',
      emoji: '🌐',
      options: [
        QuizOption(
          text: 'زۆر، دەمەوێت لە کۆمپانیای نێودەوڵەتی و بواری تەکنەلۆژیا کار بکەم',
          emoji: '💻',
          category: 'tech',
        ),
        QuizOption(
          text: 'حەز دەکەم وەک وەرگێڕ یان دیپلۆماتکار لە دەرەوە پەیوەندیم هەبێت',
          emoji: '✈️',
          category: 'lang',
        ),
        QuizOption(
          text: 'دەمەوێت بزنس و بازرگانی لەگەڵ بازاڕە جیهانییەکان بکەم',
          emoji: '🚢',
          category: 'biz',
        ),
        QuizOption(
          text: 'زیاتر گرنگی بە خزمەتکردنی نەخۆش و خەڵکی ناوخۆ دەدەم',
          emoji: '🏥',
          category: 'med',
        ),
        QuizOption(
          text: 'حەز دەکەم لە بواری یاسای نێودەوڵەتی یان ڕاگەیاندندا بم',
          emoji: '⚖️',
          category: 'law',
        ),
      ],
    ),
    QuizQuestion(
      title: 'کام کارامەییە لای تۆ لە هەموویان گرنگترە لە داهاتوودا؟',
      subtitle: 'دیدگای تۆ بۆ جیهان',
      emoji: '⭐',
      options: [
        QuizOption(
          text: 'زیرەکی دەستکرد (AI) و داهێنانی تەکنەلۆژیا',
          emoji: '🤖',
          category: 'tech',
        ),
        QuizOption(
          text: 'پێشکەوتنی پزیشکی و زانستی چارەسەری نەخۆشییەکان',
          emoji: '🩺',
          category: 'med',
        ),
        QuizOption(
          text: 'بەڕێوەبردنی سەرمایە و دامەزراندنی پڕۆژەی داهێنەرانە',
          emoji: '🏢',
          category: 'biz',
        ),
        QuizOption(
          text: 'پەرەپێدانی کەلتوور، زمان و پەروەردەی سەردەمیانە',
          emoji: '📖',
          category: 'lang',
        ),
        QuizOption(
          text: 'داهێنانی بینراو لە بواری سینەما و گرافیک و دیزاین',
          emoji: '🎨',
          category: 'art',
        ),
      ],
    ),
  ];

  void _answerQuestion(QuizOption option) {
    setState(() {
      _scores[option.category] = (_scores[option.category] ?? 0) + option.points;
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        _isFinished = true;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _scores.updateAll((key, value) => 0);
      _isFinished = false;
    });
  }

  Map<String, dynamic> _calculateTopResults() {
    // Find highest category
    String bestCategory = 'tech';
    int maxScore = -1;

    _scores.forEach((cat, score) {
      if (score > maxScore) {
        maxScore = score;
        bestCategory = cat;
      }
    });

    switch (bestCategory) {
      case 'med':
        return {
          'badge': 'فریشتەی مرۆیی و تەندروستی 🩺',
          'description':
              'کەسایەتیت خاوەن سۆزێکی بەرز، ئارامگر و بەخشندەیە. حەزت لە یارمەتیدانی خەڵک و ڕزگارکردنی ژیانی مرۆڤەکانە لە ژینگەی زانستی و کلینیکیدا.',
          'majors': [
            {'name': 'پزیشکی گشتی یان ددان', 'sub': 'زانکۆکانی حکومی و تایبەت', 'icon': '🩺'},
            {'name': 'پەرستاری و شیکاری نەخۆشییەکان', 'sub': 'کۆلێژ و پەیمانگا تەکنیکییەکان', 'icon': '🔬'},
            {'name': 'دەرمانسازی و تەندروستی کۆمەڵ', 'sub': 'زانکۆ و پەیمانگاکان', 'icon': '💊'},
          ],
        };
      case 'tech':
        return {
          'badge': 'داهێنەری تەکنەلۆژیای سەردەم 💻',
          'description':
              'خاوەن بیرکردنەوەیەکی لۆجیکی، ورد و شیکاریکەریت. حەزت لە جیهانی دیجیتاڵ، زیرەکی دەستکرد، پڕۆگرامسازی و دروستکردنی چارەسەری ئەلیکترۆنییە.',
          'majors': [
            {'name': 'زانستی کۆمپیوتەر و تەکنەلۆژیای زانیاری (IT)', 'sub': 'زانکۆ و پەیمانگا تەکنیکییەکان', 'icon': '💻'},
            {'name': 'ئەندازیاری سۆفتوێر و زیرەکی دەستکرد', 'sub': 'کۆلێژە ئەندازیارییەکان', 'icon': '🤖'},
            {'name': 'تۆڕەکان و سایبەر سیکیوریتی', 'sub': 'پەیمانگا و زانکۆکان', 'icon': '🛡️'},
          ],
        };
      case 'biz':
        return {
          'badge': 'سەرکردەی بزنس و ئابووری 💼',
          'description':
              'کەسایەتییەکی پێشەنگ و سەرکەوتووت هەیە لە بەڕێوەبردن، دۆزینەوەی دەرفەتی دارایی و دامەزراندنی پڕۆژەی تایبەت بە خۆت.',
          'majors': [
            {'name': 'کارگێڕی کار (Business Administration)', 'sub': 'کۆلێژ و پەیمانگاکانی کارگێڕی', 'icon': '👔'},
            {'name': 'ژمێریاری و دارایی و بانک', 'sub': 'زانکۆ و پەیمانگاکان', 'icon': '📊'},
            {'name': 'بازاڕگەری دیجیتاڵ و بازرگانی نێودەوڵەتی', 'sub': 'زانکۆکانی کوردستان', 'icon': '📈'},
          ],
        };
      case 'law':
        return {
          'badge': 'پارێزەری دادپەروەری و ماف ⚖️',
          'description':
              'خاوەن توانایەکی بەهێزی گفتوگۆ، بڕیاردان و داکۆکیکردنی لە ماف. لایەنگری ڕاستی و چەسپاندنی یاسا و یەکسانییت لە کۆمەڵگەدا.',
          'majors': [
            {'name': 'کۆلێژی یاسا (Law)', 'sub': 'زانکۆ حکومی و تایبەتەکان', 'icon': '⚖️'},
            {'name': 'پەیوەندییە نێودەوڵەتییەکان و دیپلۆماسی', 'sub': 'کۆلێژەکانی زانستە سیاسییەکان', 'icon': '🏛️'},
            {'name': 'کارگێڕی یاسایی و فەرمانگەکان', 'sub': 'پەیمانگا تەکنیکییەکان', 'icon': '📜'},
          ],
        };
      case 'art':
        return {
          'badge': 'هونەرمەند و داهێنەری مێدیا 🎨',
          'description':
              'خاوەن دیدگایەکی جوانناسی و هەستێکی بەرزیت. ئارەزووی داهێنانی وێنەیی، دیزاین، دەرهێنان و گەیاندنی پەیام بە شێوازی مۆدێرن دەکەیت.',
          'majors': [
            {'name': 'گرافیک دیزاین و مالتیمیدیا', 'sub': 'پەیمانگا و کۆلێژە هونەرییەکان', 'icon': '🎨'},
            {'name': 'ڕاگەیاندن و میدیای دیجیتاڵ', 'sub': 'کۆلێژەکانی ڕاگەیاندن', 'icon': '🎥'},
            {'name': 'ئەندازیاری دیزاینی ناوەوە (دیکۆر)', 'sub': 'زانکۆ و پەیمانگاکان', 'icon': '🛋️'},
          ],
        };
      default: // lang / edu
        return {
          'badge': 'پەروەردەکار و زمانزانی داهاتوو 📚',
          'description':
              'کەسایەتییەکی کۆمەڵایەتی و کاریگەرت هەیە لە فێرکردن و گۆڕینەوەی کەلتوور و پەیوەندی جیهانی لە ڕێگەی زمانە جیاوازەکانەوە.',
          'majors': [
            {'name': 'زمانی ئینگلیزی و وەرگێڕان', 'sub': 'کۆلێژەکانی زمان و پەروەردە', 'icon': '🇬🇧'},
            {'name': 'پەروەردەی بنەڕەتی و دەرونزانی', 'sub': 'زانکۆکانی کوردستان', 'icon': '🧑‍🏫'},
            {'name': 'زمانە بیانییەکان (فەرەنسی، ئەڵمانی)', 'sub': 'کۆلێژەکانی زمان', 'icon': '🌍'},
          ],
        };
    }
  }

  void _shareResult(Map<String, dynamic> result) {
    final badge = result['badge'];
    final majors = result['majors'] as List<Map<String, String>>;
    final text = '''
🎯 من تاقیکردنەوەی دیاریکردنی بەشی زانکۆم لە ئەپی خوێندنگاکان ئەنجامدا!

🏆 کەسایەتی من: $badge
🎓 گونجاوترین بەشەکان بۆ من:
١. ${majors[0]['name']}
٢. ${majors[1]['name']}
٣. ${majors[2]['name']}

تۆش لە ٢ خولەکدا بەشە شیاوەکەت بدۆزەرەوە لە ڕێگەی ئەپی Edubook خوێندنگاکان:
https://edubook-iq.com
''';

    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l.careerQuizTitle,
          style: const TextStyle(
            fontFamily: 'Rabar',
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: _isFinished
            ? _buildResultView(isDark, l)
            : _buildQuizView(isDark, l),
      ),
    );
  }

  Widget _buildQuizView(bool isDark, AppLocalizations l) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      children: [
        // Progress Bar & Step Indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l.questionLabel} ${_currentIndex + 1} لە ${_questions.length}',
                    style: TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white70 : AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),

        // Question Title and Options
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                        AppColors.primary.withValues(alpha: 0.03),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.15),
                            ),
                            child: Text(
                              question.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question.title,
                              style: const TextStyle(
                                fontFamily: 'Rabar',
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.subtitle,
                        style: TextStyle(
                          fontFamily: 'Rabar',
                          fontSize: 12.5,
                          color: isDark ? Colors.white60 : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Options list
                ...question.options.map((opt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _answerQuestion(opt),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.2 : 0.04,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(alpha: 0.1),
                              ),
                              child: Center(
                                child: Text(
                                  opt.emoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                opt.text,
                                style: TextStyle(
                                  fontFamily: 'Rabar',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textDark,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(bool isDark, AppLocalizations l) {
    final result = _calculateTopResults();
    final badge = result['badge'] as String;
    final desc = result['description'] as String;
    final majors = result['majors'] as List<Map<String, String>>;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Trophy / Badge Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB88728), Color(0xFFE5B242)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB88728).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 8),
                Text(
                  badge,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 13.5,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recommended Majors Header
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              l.recommendedMajors,
              style: const TextStyle(
                fontFamily: 'Rabar',
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Major Cards
          ...majors.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final m = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        '$idx',
                        style: const TextStyle(
                          fontFamily: 'Rabar',
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${m['icon']} ${m['name']}',
                          style: const TextStyle(
                            fontFamily: 'Rabar',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m['sub'] ?? '',
                          style: TextStyle(
                            fontFamily: 'Rabar',
                            fontSize: 11.5,
                            color: isDark ? Colors.white60 : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // Viral Share Button
          GestureDetector(
            onTap: () => _shareResult(result),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE11D48), Color(0xFFF43F5E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE11D48).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l.shareMyResult,
                    style: const TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Explore Institutions Button
          OutlinedButton(
            onPressed: () {
              context.push('/institutions');
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  l.exploreInstitutions,
                  style: const TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Retake Quiz Button
          TextButton(
            onPressed: _restartQuiz,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh_rounded, size: 18),
                const SizedBox(width: 6),
                Text(
                  l.retakeQuiz,
                  style: const TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
