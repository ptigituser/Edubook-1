class ReviewModel {
  final int id;
  final int institutionId;
  final int? userId;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String? comment;
  final String? createdAt;
  final String? updatedAt;

  ReviewModel({
    required this.id,
    required this.institutionId,
    this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      institutionId: json['institution_id'] is int
          ? json['institution_id']
          : int.tryParse('${json['institution_id']}') ?? 0,
      userId: json['user_id'] != null
          ? (json['user_id'] is int
              ? json['user_id']
              : int.tryParse('${json['user_id']}'))
          : null,
      userName: json['user_name'] ?? 'بەکارهێنەر',
      userAvatar: json['user_avatar'],
      rating: json['rating'] is int
          ? json['rating']
          : int.tryParse('${json['rating']}') ?? 5,
      comment: json['comment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'institution_id': institutionId,
        'user_id': userId,
        'user_name': userName,
        'user_avatar': userAvatar,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class ReviewSummaryModel {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> distribution;

  ReviewSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    required this.distribution,
  });

  factory ReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    final distRaw = json['distribution'];
    final Map<int, int> dist = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    if (distRaw is Map) {
      distRaw.forEach((k, v) {
        final starKey = int.tryParse('$k');
        final starCount = int.tryParse('$v');
        if (starKey != null && starCount != null) {
          dist[starKey] = starCount;
        }
      });
    }

    return ReviewSummaryModel(
      averageRating: json['average_rating'] is num
          ? (json['average_rating'] as num).toDouble()
          : double.tryParse('${json['average_rating']}') ?? 0.0,
      totalReviews: json['total_reviews'] is int
          ? json['total_reviews']
          : int.tryParse('${json['total_reviews']}') ?? 0,
      distribution: dist,
    );
  }

  static ReviewSummaryModel empty() {
    return ReviewSummaryModel(
      averageRating: 0.0,
      totalReviews: 0,
      distribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
    );
  }
}

class ReviewsData {
  final ReviewSummaryModel summary;
  final ReviewModel? userReview;
  final List<ReviewModel> reviews;

  ReviewsData({
    required this.summary,
    this.userReview,
    required this.reviews,
  });

  factory ReviewsData.fromJson(Map<String, dynamic> json) {
    final summaryRaw = json['summary'] as Map<String, dynamic>? ?? {};
    final userReviewRaw = json['user_review'] as Map<String, dynamic>?;
    final reviewsRaw = json['reviews'] as List<dynamic>? ?? [];

    return ReviewsData(
      summary: ReviewSummaryModel.fromJson(summaryRaw),
      userReview:
          userReviewRaw != null ? ReviewModel.fromJson(userReviewRaw) : null,
      reviews: reviewsRaw
          .whereType<Map<String, dynamic>>()
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
    );
  }
}
