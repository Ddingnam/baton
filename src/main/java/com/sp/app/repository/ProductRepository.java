package com.sp.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

}
