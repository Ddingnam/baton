package com.sp.app.controller;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.service.ChatBotProxyService;

import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Flux;

@Controller
@RequestMapping("/chatbot/*")
@RequiredArgsConstructor
public class ChatBotController {
	private final ChatBotProxyService chatBotService;
	
	@GetMapping("room")
    public String chatBotMain() {
        return "chatbot/room";
    }
	
	@GetMapping(value = "question", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	@ResponseBody
	public Flux<String> ask(@RequestParam("question") String question) {
        return chatBotService.getChatResponse(question);
    }
}
