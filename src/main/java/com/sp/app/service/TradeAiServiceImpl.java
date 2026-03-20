package com.sp.app.service;

import java.net.URI;
import java.util.Base64;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.config.GeminiConfig;
import com.sp.app.model.TradeAiResponse;

@Service
public class TradeAiServiceImpl implements TradeAiService{
	
	@Autowired
    private GeminiConfig geminiConfig;

    @Autowired
    private RestTemplate restTemplate;
	
	@Override
	public TradeAiResponse analyzeProductImage(MultipartFile imageFile) throws Exception {
		String modelName = "gemini-2.5-flash";
		
	    String apiKey = geminiConfig.getApiKey();
	    System.out.println(">>>> [DEBUG] 불러온 API KEY: [" + apiKey + "]");

	    String urlStr = "https://generativelanguage.googleapis.com/v1/models/" 
	              + modelName + ":generateContent?key=" + apiKey;
	    URI uri = new URI(urlStr);

	    System.out.println(">>> 최종 요청 URL: " + uri);

	    if (imageFile == null || imageFile.isEmpty()) {
	        throw new IllegalArgumentException("이미지 파일이 비어있습니다.");
	    }

        String base64Image = Base64.getEncoder().encodeToString(imageFile.getBytes());

        String prompt = "중고거래 플랫폼 'Baton Touch'의 상품 등록 도우미야. 사진을 보고 "
                      + "매력적인 제목과 상세 설명(2000자 이내)을 JSON 형식으로 써줘. "
                      + "형식: {\"title\": \"...\", \"content\": \"...\"}";

        JSONObject requestJson = new JSONObject();
        JSONArray contents = new JSONArray();
        JSONArray partsArray = new JSONArray();
        
        String mimeType = imageFile.getContentType() != null 
                ? imageFile.getContentType() 
                : "image/jpeg";
        
        partsArray.put(new JSONObject().put("text", prompt));
        partsArray.put(new JSONObject().put("inline_data", new JSONObject()
                .put("mime_type", mimeType)
                .put("data", base64Image)));

        contents.put(new JSONObject().put("parts", partsArray));
        requestJson.put("contents", contents);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> entity = new HttpEntity<>(requestJson.toString(), headers);

        ResponseEntity<String> response = restTemplate.postForEntity(uri, entity, String.class);
        
        return parseGeminiResponse(response.getBody());
	}
	
	private TradeAiResponse parseGeminiResponse(String responseBody) {
		TradeAiResponse dto = new TradeAiResponse();
        try {
            JSONObject json = new JSONObject(responseBody);
            String rawText = json.getJSONArray("candidates")
                                .getJSONObject(0)
                                .getJSONObject("content")
                                .getJSONArray("parts")
                                .getJSONObject(0)
                                .getString("text");

            String cleanJson = rawText.replaceAll("```json|```", "").trim();
            JSONObject result = new JSONObject(cleanJson);
            
            dto.setTitle(result.getString("title"));
            dto.setContent(result.getString("content"));
        } catch (Exception e) {
            dto.setTitle("분석된 제목이 없습니다.");
            dto.setContent("이미지를 분석하는 중 오류가 발생했습니다.");
        }
        return dto;
    }

}
