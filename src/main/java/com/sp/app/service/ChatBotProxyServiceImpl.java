package com.sp.app.service;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Flux;

@Service
@RequiredArgsConstructor
public class ChatBotProxyServiceImpl implements ChatBotProxyService{
	private final WebClient chatBotWebClient;

	@Override
	public Flux<String> getChatResponse(String question) {
		return chatBotWebClient.get()
	            .uri(uriBuilder -> uriBuilder
	                .path("/chatBot/question")
	                .queryParam("question", question)
	                .build())
	            .retrieve()
	            .bodyToFlux(String.class);
	}

}
