package com.sp.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.ExceptionTranslationFilter;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;

import com.sp.app.security.AjaxSessionTimeoutFilter;
import com.sp.app.security.LoginFailureHandler;
import com.sp.app.security.LoginSuccessHandler;

@Configuration
@EnableWebSecurity
public class SpringSecurityConfig {
	@Bean
	SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

		HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
		requestCache.setMatchingRequestParameterName(null);

		String[] excludeUri = { "/", "/index.jsp", "/member/login", "/member/account", "/member/logout", "/member/join", "/member/townAuth",
				"/member/userIdCheck", "/member/complete", "/member/pwdFind", "/member/expired", "/dist/**",
				"/guest/main", "/guest/list", "/uploads/photo/**", "/favicon.ico", "/WEB-INF/views/**", "/static/**",
				"/oauth/kakao/callback", "/js/**" };

		http.cors(Customizer.withDefaults())
			.csrf(AbstractHttpConfigurer::disable)
			.requestCache(request -> request.requestCache(requestCache));
		
		http.headers(headers -> headers
		    .frameOptions(frame -> frame.sameOrigin())
		    .contentSecurityPolicy(csp -> csp
		        .policyDirectives("default-src 'self'; " +
		                         "font-src 'self' data: https://fonts.gstatic.com https://cdn.jsdelivr.net https://unpkg.com; " +
		                         "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net https://unpkg.com; " +
		                         "img-src 'self' data: *; " + "script-src 'self' 'unsafe-inline' 'unsafe-eval';")
		    )
		);

		http.authorizeHttpRequests(authorize -> authorize
			.requestMatchers(excludeUri).permitAll()
			.requestMatchers("/admin/**").hasAnyRole("ADMIN", "EMP")
			.requestMatchers("/**").hasAnyRole("USER", "INSTRUCTOR", "EMP", "ADMIN")
			.requestMatchers("/error").permitAll()
			.anyRequest().authenticated()
		)
		.formLogin(login -> login
			.loginPage("/member/login")
			.loginProcessingUrl("/member/login")
			.usernameParameter("login_id")
			.passwordParameter("password")
			.successHandler(loginSuccessHandler())
			.failureHandler(loginFailureHandler())
			.permitAll()
		)
		.logout(logout -> logout
			.logoutUrl("/member/logout")
			.invalidateHttpSession(true)
			.deleteCookies("JSESSIONID")
			.logoutSuccessUrl("/")
		)
		.addFilterAfter(ajaxSessionTimeoutFilter(), ExceptionTranslationFilter.class)
		.sessionManagement(management -> management
			.maximumSessions(1)
			.expiredUrl("/member/expired"));

		http.exceptionHandling((exceptionConfig) -> exceptionConfig.accessDeniedPage("/member/noAuthorized"));

		return http.build();
	}

	@Bean
	PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	LoginSuccessHandler loginSuccessHandler() {
		LoginSuccessHandler handler = new LoginSuccessHandler();
		handler.setDefaultUrl("/");
		return handler;
	}

	@Bean
	LoginFailureHandler loginFailureHandler() {
		LoginFailureHandler handler = new LoginFailureHandler();
		handler.setDefaultFailureUrl("/member/login?error");
		return handler;
	}

	@Bean
	AjaxSessionTimeoutFilter ajaxSessionTimeoutFilter() {
		AjaxSessionTimeoutFilter filter = new AjaxSessionTimeoutFilter();
		filter.setAjaxHeader("AJAX");
		return filter;
	}
}
