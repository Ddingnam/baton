package com.sp.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.WishList;
import com.sp.app.domain.entity.WishListId;

@Repository
public interface WishListRepository extends JpaRepository<WishList, WishListId> {

}
