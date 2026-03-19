package com.sp.app.service;

import reactor.core.publisher.Flux;

public interface ChatBotProxyService {
	public Flux<String> getChatResponse(String question);
}
