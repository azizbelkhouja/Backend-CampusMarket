package com.aziz.modal;

import com.aziz.domain.PaymentMethod;
import com.aziz.domain.PaymentOrderStatus;
import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode
public class PaymentOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private Long amount;

    private PaymentOrderStatus status = PaymentOrderStatus.PENDING;

    private PaymentMethod paymentMethod;

    private String paymentLinkId;

    // A payment order belongs to one user
    @ManyToOne
    private User user;

    // A payment order can include multiple orders
    @OneToMany
    private Set<Order> orders = new HashSet<>();
}
