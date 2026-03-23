package com.sp.app.security;

public class NumericRoleGranted {
	public final static int INACTIVE = 0;
	public final static int USER = 1;
	public final static int EX_EMP = 50;
	public final static int EMP = 51;
	public final static int ADMIN = 99;
	
	public static int getUserLevel(String authority) {
		try {
			if (authority == null) return 0;
			String a = authority.replace("ROLE_", "").trim();
			switch (a) {
			case "USER" : return USER;
			case "EX_EMP" : return EX_EMP;
			case "EMP" : return EMP;
			case "ADMIN" : return ADMIN;
			}
		} catch (Exception e) {
		}
		
		return 0;
	}
}