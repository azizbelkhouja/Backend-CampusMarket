package com.aziz.repository;

import com.aziz.modal.SellerReport;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SellerReportRepository extends JpaRepository<SellerReport, Long> {

    SellerReport findBySellerId(Long seller_id);
}
