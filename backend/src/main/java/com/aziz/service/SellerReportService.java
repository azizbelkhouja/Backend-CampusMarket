package com.aziz.service;

import com.aziz.modal.Seller;
import com.aziz.modal.SellerReport;

public interface SellerReportService {

    SellerReport getSellerReport(Seller seller);
    SellerReport updateSellerReport(SellerReport sellerReport);
}
