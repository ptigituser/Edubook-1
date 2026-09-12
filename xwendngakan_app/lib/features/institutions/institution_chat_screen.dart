import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/institution_model.dart';
import '../../data/services/api_service.dart';
import '../../providers/auth_provider.dart';

class InstitutionChatScreen extends StatefulWidget {
  final InstitutionModel institution;

  const InstitutionChatScreen({
    super.key,
    required this.institution,
  });

  @override
  State<InstitutionChatScreen> createState() => _InstitutionChatScreenState();
}

class _InstitutionChatScreenState extends State<InstitutionChatScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages(initial: true);

    // Poll every 3.5s for incoming replies from the dashboard
    _pollTimer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (mounted && !_isSending) {
        _loadMessages(initial: false);
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages({bool initial = false}) async {
    final instId = widget.institution.id;
    if (instId == 0) return;

    if (initial) {
      setState(() => _isLoading = true);
    }

    final res = await _api.getInstitutionChat(instId);
    if (!mounted) return;

    if (res.success && res.data != null) {
      final rawList = res.data!['messages'] as List<dynamic>? ?? [];
      final list = rawList
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final previousCount = _messages.length;
      setState(() {
        _messages = list;
        if (initial) _isLoading = false;
      });

      // If new messages arrived, scroll to bottom
      if (list.length > previousCount || initial) {
        _scrollToBottom();
      }
    } else {
      if (initial) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    final instId = widget.institution.id;
    if (instId == 0) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) return;

    _textController.clear();
    setState(() => _isSending = true);

    // Add optimistic message to list immediately
    final tempMsg = {
      'sender_type': 'user',
      'message': text,
      'created_at': DateTime.now().toIso8601String(),
      'is_temp': true,
    };
    setState(() {
      _messages.add(tempMsg);
    });
    _scrollToBottom();

    final res = await _api.sendInstitutionMessage(instId, text);
    if (!mounted) return;

    setState(() => _isSending = false);

    if (res.success) {
      // Reload actual message
      _loadMessages(initial: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res.error ?? 'ناردنی نامەکە سەرکەوتوو نەبوو',
            style: const TextStyle(fontFamily: 'Rabar'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inst = widget.institution;
    final instName = inst.nku ?? inst.nen ?? inst.nar ?? 'دامەزراوە';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: inst.logoUrl.isNotEmpty
                  ? Image.network(
                      inst.logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          instName.isNotEmpty ? instName[0] : '🏫',
                          style: const TextStyle(
                            fontFamily: 'Rabar',
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        instName.isNotEmpty ? instName[0] : '🏫',
                        style: const TextStyle(
                          fontFamily: 'Rabar',
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    instName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        inst.city ?? 'پەیوەندی ڕاستەوخۆ',
                        style: TextStyle(
                          fontFamily: 'Rabar',
                          fontSize: 11,
                          color: isDark ? Colors.white54 : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages list area
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _messages.isEmpty
                      ? _buildEmptyState(isDark, instName)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            final isUser = msg['sender_type'] == 'user';
                            return _buildMessageBubble(msg, isUser, isDark);
                          },
                        ),
            ),

            // Input bar
            _buildInputBar(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, String instName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'دەستپێکردنی گفتوگۆ',
              style: TextStyle(
                fontFamily: 'Rabar',
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'پرسیارەکەت یان داواکارییەکەت بنووسە، کارگێڕیی $instName لە کاتێکی گونجاودا وەڵامت دەدەنەوە.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rabar',
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.white60 : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
    Map<String, dynamic> msg,
    bool isUser,
    bool isDark,
  ) {
    final text = msg['message']?.toString() ?? '';
    final createdAt = msg['created_at']?.toString();
    String timeStr = '';
    if (createdAt != null) {
      try {
        final dt = DateTime.parse(createdAt).toLocal();
        final h = dt.hour.toString().padLeft(2, '0');
        final m = dt.minute.toString().padLeft(2, '0');
        timeStr = '$h:$m';
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser ? AppColors.primaryGradient : null,
                color: isUser
                    ? null
                    : (isDark ? AppColors.darkCard : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 14,
                      color: isUser
                          ? Colors.white
                          : (isDark ? Colors.white : AppColors.textDark),
                      height: 1.45,
                    ),
                  ),
                  if (timeStr.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 10,
                            color: isUser
                                ? Colors.white70
                                : (isDark ? Colors.white38 : Colors.black38),
                          ),
                        ),
                        if (isUser) ...[
                          const SizedBox(width: 3),
                          Icon(
                            msg['is_temp'] == true
                                ? Icons.access_time_rounded
                                : Icons.done_all_rounded,
                            size: 12,
                            color: Colors.white70,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                ),
              ),
              child: TextField(
                controller: _textController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                maxLines: 4,
                minLines: 1,
                style: const TextStyle(
                  fontFamily: 'Rabar',
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'نامەکەت لێرە بنووسە...',
                  hintStyle: TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 13,
                    color: isDark ? Colors.white38 : AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isSending ? null : _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: _isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
