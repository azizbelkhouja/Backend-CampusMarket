package com.aziz.service;

import com.aziz.domain.OrderStatus;
import com.aziz.modal.*;

import java.util.List;
import java.util.Set;

public interface OrderService {

    Set<Order> createOrder(User user, Address shippingAddress, Cart cart);
    Order findOrderById(Long id) throws Exception;
    List<Order> userOrdersHistory(Long userId);
    List<Order> sellerOrders(Long SellerId);
    Order updateOrderStatus(Long id, OrderStatus orderStatus) throws Exception;
    Order cancelOrder(Long orderId, User user) throws Exception;
    OrderItem getOrderItemById(Long id) throws Exception;
}
