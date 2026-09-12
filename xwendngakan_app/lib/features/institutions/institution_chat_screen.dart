import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/image_utils.dart';
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
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  File? _selectedImage;
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
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImagePickerModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l.choosePhotoSource,
                  style: const TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPickerOption(
                      icon: Icons.camera_alt_rounded,
                      label: l.camera,
                      color: const Color(0xFF3B82F6),
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.camera);
                      },
                      isDark: isDark,
                    ),
                    _buildPickerOption(
                      icon: Icons.photo_library_rounded,
                      label: l.gallery,
                      color: const Color(0xFF10B981),
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.gallery);
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Rabar',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    final imageFile = _selectedImage;

    if ((text.isEmpty && imageFile == null) || _isSending) return;

    final instId = widget.institution.id;
    if (instId == 0) return;

    final l = AppLocalizations.of(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (!auth.isAuthenticated) {
      _showLoginNotice(l);
      return;
    }

    _textController.clear();
    setState(() {
      _selectedImage = null;
      _isSending = true;
    });

    // Add optimistic message to list immediately
    final tempMsg = <String, dynamic>{
      'sender_type': 'user',
      'message': text.isNotEmpty ? text : null,
      'image': imageFile?.path,
      'is_local_file': imageFile != null,
      'created_at': DateTime.now().toIso8601String(),
      'is_temp': true,
    };

    setState(() {
      _messages.add(tempMsg);
    });
    _scrollToBottom();

    final res = await _api.sendInstitutionMessage(
      instId,
      message: text.isNotEmpty ? text : null,
      imagePath: imageFile?.path,
    );

    if (!mounted) return;
    setState(() => _isSending = false);

    if (res.success) {
      _loadMessages(initial: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res.error ?? l.failedToSendMessage,
            style: const TextStyle(fontFamily: 'Rabar'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showLoginNotice(AppLocalizations l) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l.loginToChat,
          style: const TextStyle(fontFamily: 'Rabar'),
        ),
        action: SnackBarAction(
          label: l.login,
          textColor: Colors.white,
          onPressed: () => context.push('/login'),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _openFullScreenImage(String imageUrl, bool isLocal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: isLocal
                  ? Image.file(File(imageUrl), fit: BoxFit.contain)
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image_rounded,
                            color: Colors.white54, size: 48),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final inst = widget.institution;
    final instName = inst.nku ?? inst.nen ?? inst.nar ?? 'دامەزراوە';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF7F8FA),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primary.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
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
            const SizedBox(width: 12),
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        l.directContact,
                        style: TextStyle(
                          fontFamily: 'Rabar',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white60 : AppColors.textMuted,
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
                      ? _buildEmptyState(isDark, instName, l)
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
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

            // Image Preview Bar if an image is selected
            if (_selectedImage != null) _buildSelectedImagePreview(isDark),

            // Input bar
            _buildInputBar(isDark, l),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, String instName, AppLocalizations l) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.forum_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l.startConversationTitle,
              style: const TextStyle(
                fontFamily: 'Rabar',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                l.startConversationDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rabar',
                  fontSize: 13,
                  height: 1.55,
                  color: isDark ? Colors.white60 : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              _selectedImage!,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'وێنە ئامادەیە بۆ ناردن',
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _selectedImage!.path.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 11,
                    color: isDark ? Colors.white54 : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
            onPressed: () {
              setState(() => _selectedImage = null);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    Map<String, dynamic> msg,
    bool isUser,
    bool isDark,
  ) {
    final text = msg['message']?.toString();
    final rawImage = msg['image']?.toString();
    final isLocalFile = msg['is_local_file'] == true;
    final resolvedImageUrl = (rawImage != null && rawImage.isNotEmpty)
        ? (isLocalFile ? rawImage : ImageUtils.resolveUrl(rawImage))
        : null;

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
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.account_balance_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFFB88728), Color(0xFFD4AF37)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser
                    ? null
                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFE2E8F0),
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Attached Image if present
                  if (resolvedImageUrl != null) ...[
                    GestureDetector(
                      onTap: () =>
                          _openFullScreenImage(resolvedImageUrl, isLocalFile),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: 240,
                            maxWidth: 260,
                          ),
                          child: isLocalFile
                              ? Image.file(
                                  File(resolvedImageUrl),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  resolvedImageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (_, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      height: 180,
                                      width: 220,
                                      color: Colors.black12,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 120,
                                    width: 180,
                                    color: Colors.black12,
                                    child: const Icon(
                                      Icons.broken_image_rounded,
                                      size: 36,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    if (text != null && text.isNotEmpty)
                      const SizedBox(height: 8),
                  ],

                  // Message Text if present
                  if (text != null && text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Rabar',
                          fontSize: 14.5,
                          fontWeight:
                              isUser ? FontWeight.w600 : FontWeight.w500,
                          color: isUser
                              ? Colors.white
                              : (isDark ? Colors.white : AppColors.textDark),
                          height: 1.45,
                        ),
                      ),
                    ),

                  // Timestamp and status checkmark
                  if (timeStr.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isUser
                                ? Colors.white.withValues(alpha: 0.8)
                                : (isDark ? Colors.white38 : Colors.black45),
                          ),
                        ),
                        if (isUser) ...[
                          const SizedBox(width: 4),
                          Icon(
                            msg['is_temp'] == true
                                ? Icons.access_time_rounded
                                : Icons.done_all_rounded,
                            size: 13,
                            color: Colors.white.withValues(alpha: 0.85),
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

  Widget _buildInputBar(bool isDark, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment Button (Image Picker)
          IconButton(
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.add_photo_alternate_rounded,
                color: AppColors.primary,
                size: 21,
              ),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            onPressed: _isSending ? null : _showImagePickerModal,
          ),
          const SizedBox(width: 6),

          // Message Input Field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : const Color(0xFFE2E8F0),
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
                  hintText: l.writeMessageHint,
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

          // Send Button
          GestureDetector(
            onTap: _isSending ? null : _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFB88728), Color(0xFFD4AF37)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB88728).withValues(alpha: 0.35),
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
