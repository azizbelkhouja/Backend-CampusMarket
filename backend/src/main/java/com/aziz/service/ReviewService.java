package com.aziz.service;

import com.aziz.modal.Product;
import com.aziz.modal.Review;
import com.aziz.modal.User;
import com.aziz.request.CreateReviewRequest;

import java.util.List;

public interface ReviewService {

    Review createReview(CreateReviewRequest req,
                        User user,
                        Product product
    );

    List<Review> getReviewByProductId(Long productId);
    Review updateReview(Long reviewId, String reviewText, double reviewRating, Long userId) throws Exception;
    void deleteReview(Long reviewId, Long userId) throws Exception;
    Review getReviewById(Long reviewId) throws Exception;
}
