package com.sp.app.interceptor;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.HandlerMapping;

import com.sp.app.model.Trade;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.TradeService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class TradeHitCountInterceptor implements HandlerInterceptor{
	
	@Autowired
	private TradeService service;
	
	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler)
			throws Exception {
		try {
            HttpSession session = req.getSession();
            
            String productIdxStr = req.getParameter("productIdx");

            if (productIdxStr == null) {
                Object pathVarObj = req.getAttribute(HandlerMapping.URI_TEMPLATE_VARIABLES_ATTRIBUTE);

                if (pathVarObj instanceof Map<?, ?> pathVariables) {
                    Object value = pathVariables.get("productIdx");
                    if (value != null) {
                        productIdxStr = value.toString();
                    }
                }
            }

            if (productIdxStr == null) return true;

            long productIdx = Long.parseLong(productIdxStr);
            
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			
			if (auth != null && auth.getPrincipal() instanceof CustomUserDetails userDetails) {
				long loginUserIdx = userDetails.getUserIdx();

				Trade dto = service.findByIdx(productIdx); 
				
				if (dto != null && dto.getUserIdx() == loginUserIdx) {
					return true; 
				}
			}

            @SuppressWarnings("unchecked")
            Set<Long> viewedTradeIds = (Set<Long>) session.getAttribute("viewedTradeIds");

            if (viewedTradeIds == null) {
                viewedTradeIds = new HashSet<>();
            }

            if (!viewedTradeIds.contains(productIdx)) {
                service.updateHitCount(productIdx);

                viewedTradeIds.add(productIdx);
                session.setAttribute("viewedTradeIds", viewedTradeIds);
            }

        } catch (Exception e) {
            log.info("hitCountInterceptor Error: " + e.toString());
        }

        return true;
	}
}
