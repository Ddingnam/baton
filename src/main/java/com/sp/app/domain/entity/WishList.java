package com.sp.app.domain.entity;

import java.time.LocalDateTime;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "wishlist")
@IdClass(WishListId.class)
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class WishList {
	
	@Id
    @Column(name = "productidx")
    private Long productIdx;

    @Id
    @Column(name = "useridx")
    private Long userIdx;

    @Column(name = "likedate", 
            nullable = false, 
            columnDefinition = "TIMESTAMP DEFAULT SYSDATE", 
            insertable = false, 
            updatable = false)
    private LocalDateTime likeDate;
}
