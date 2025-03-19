package com.aziz.service;

import com.aziz.modal.Cart;
import com.aziz.modal.CartItem;
import com.aziz.modal.Product;
import com.aziz.modal.User;

public interface CartService {

    public CartItem addCartItem(User user, Product product, String size, int quantity);
    public Cart findUserCart(User user);
}
