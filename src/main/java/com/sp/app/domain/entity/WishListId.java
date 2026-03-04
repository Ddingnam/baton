package com.sp.app.domain.entity;

import java.io.Serializable;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Getter
@Setter
public class WishListId implements Serializable {
	private static final long serialVersionUID = 1L;
	private Long productIdx;
    private Long userIdx;
}
