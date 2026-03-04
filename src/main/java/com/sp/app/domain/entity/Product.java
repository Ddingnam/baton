package com.sp.app.domain.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "product")
@Getter
@Setter
public class Product {
	@Id
    @Column(name = "productidx")
    private Long productIdx;

    @Column(name = "likecount")
    private Integer likeCount;

    public void updateLikeCount(int amount) {
        this.likeCount = (this.likeCount == null ? 0 : this.likeCount) + amount;
    }
}
