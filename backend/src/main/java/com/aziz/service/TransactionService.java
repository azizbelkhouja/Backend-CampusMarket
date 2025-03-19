package com.aziz.service;

import com.aziz.modal.Order;
import com.aziz.modal.Seller;
import com.aziz.modal.Transaction;

import java.util.List;

public interface TransactionService {

    Transaction createTransaction(Order order);
    List<Transaction> getTransactionBySellerId(Seller seller);
    List<Transaction> getAllTransactions();
}
