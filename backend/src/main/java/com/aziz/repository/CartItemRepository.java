package com.aziz.repository;

import com.aziz.modal.Cart;
import com.aziz.modal.CartItem;
import com.aziz.modal.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {

    CartItem findByCartAndProductAndSize(Cart cart, Product product, String size);
}
