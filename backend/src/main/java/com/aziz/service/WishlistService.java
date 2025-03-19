package com.aziz.service;

import com.aziz.modal.Product;
import com.aziz.modal.Wishlist;
import com.aziz.modal.User;

public interface WishlistService {

    Wishlist createWishlist(User user);
    Wishlist getWishlistByUserId(User user);
    Wishlist addProductToWishlist(User user, Product product);
}
