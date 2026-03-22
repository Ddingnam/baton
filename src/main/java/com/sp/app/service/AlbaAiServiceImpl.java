package com.sp.app.service;

import java.net.URI;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.sp.app.config.GeminiConfig;
import com.sp.app.domain.dto.AiResumeRequest;

@Service
public class AlbaAiServiceImpl implements AlbaAiService {

    @Autowired
    private GeminiConfig geminiConfig;

    @Autowired
    private RestTemplate restTemplate;

    @Override
    public String generateResume(AiResumeRequest request) throws Exception {
        String modelName = "gemini-2.5-flash";
        String apiKey = geminiConfig.getApiKey();
        
        String urlStr = "https://generativelanguage.googleapis.com/v1/models/" 
                      + modelName + ":generateContent?key=" + apiKey;
        URI uri = new URI(urlStr);

        // 프론트에서 넘어온 배열을 콤마(,)로 연결된 문자열로 변환
        String skills = (request.getSkills() != null && !request.getSkills().isEmpty()) 
            ? String.join(", ", request.getSkills()) : "없음";
        String strengths = (request.getStrengths() != null && !request.getStrengths().isEmpty()) 
            ? String.join(", ", request.getStrengths()) : "없음";
        String goals = (request.getGoals() != null && !request.getGoals().isEmpty()) 
            ? String.join(", ", request.getGoals()) : "없음";

        // 프롬프트 작성
        String prompt = "당신은 동네 알바 이력서 작성 전문가입니다.\n" +
                "아래 키워드를 바탕으로 알바 지원자의 자기소개서를 작성해주세요.\n\n" +
                "업무 스킬: " + skills + "\n" +
                "장점: " + strengths + "\n" +
                "입사 후 포부: " + goals + "\n\n" +
                "작성 조건:\n" +
                "- 자연스럽고 진솔한 말투로 작성 (딱딱하지 않게)\n" +
                "- 3~4문단, 200~300자 내외\n" +
                "- 동네 알바(카페, 편의점, 식당 등)에 어울리는 톤\n" +
                "- 마크다운 기호(*, #, - 등) 절대 사용 금지\n" +
                "- 인삿말(\"안녕하세요\" 등)로 시작하지 말 것\n" +
                "- 자기소개서 본문만 출력할 것";

        JSONObject requestJson = new JSONObject();
        JSONArray contents = new JSONArray();
        JSONArray partsArray = new JSONArray();
        
        partsArray.put(new JSONObject().put("text", prompt));
        contents.put(new JSONObject().put("parts", partsArray));
        requestJson.put("contents", contents);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> entity = new HttpEntity<>(requestJson.toString(), headers);

        // Gemini API 호출
        ResponseEntity<String> response = restTemplate.postForEntity(uri, entity, String.class);
        
        return parseGeminiResponse(response.getBody());
    }

    private String parseGeminiResponse(String responseBody) {
        try {
            JSONObject json = new JSONObject(responseBody);
            String rawText = json.getJSONArray("candidates")
                                .getJSONObject(0)
                                .getJSONObject("content")
                                .getJSONArray("parts")
                                .getJSONObject(0)
                                .getString("text");
            return rawText.trim();
        } catch (Exception e) {
            System.out.println("Gemini 응답 파싱 오류: " + e.getMessage());
            return "자기소개서 생성 중 오류가 발생했습니다. 다시 시도해주세요.";
        }
    }
}