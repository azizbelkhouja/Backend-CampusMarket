package com.aziz.campusmarket.modal;

import com.aziz.campusmarket.modal.User;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // PostgreSQL-friendly
    private Long id;

    private String name;
    private String locality;
    private String address;
    private String city;
    private String state;
    private String pinCode;
    private String mobile;

    // Many addresses can belong to one user
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false) // foreign key in Address table
    private User user;
}
