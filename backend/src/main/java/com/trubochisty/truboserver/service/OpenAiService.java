package com.trubochisty.truboserver.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.trubochisty.truboserver.model.Culvert;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import org.json.JSONArray;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@Service
public class OpenAiService {

    @Value("${openai.api.key}")
    private String openAiApiKey;

    public Culvert analyzePhotosAndExtractCulvert(List<MultipartFile> files) throws IOException {
        List<String> base64Images = new ArrayList<>();

        for (MultipartFile file : files) {
            byte[] bytes = file.getBytes();
            String base64 = Base64.getEncoder().encodeToString(bytes);
            base64Images.add(base64);
        }

        String prompt = """
        You are an expert in civil engineering.
        You will receive one or more photographs of a road culvert (труба под дорогой).
        Your task is to extract all possible technical characteristics and visible defects.

        Return ONLY a valid JSON object matching this Java class (no comments, no extra text):

        {
            "pipeType": "string",
            "material": "string",
            "diameter": "string",
            "length": "string",
            "headType": "string",
            "foundationType": "string",
            "workType": "string",
            "strengthRating": double,
            "safetyRating": double,
            "maintainabilityRating": double,
            "generalConditionRating": double,
            "defects": ["string", "string", ...]
            "users": null
        }

        Return only a valid JSON object. Do NOT include explanations, code blocks, text, or Markdown.
    """;

        JSONArray imageInputs = new JSONArray();
        for (String base64 : base64Images) {
            JSONObject imageInput = new JSONObject();
            imageInput.put("type", "image_url");
            imageInput.put("image_url", new JSONObject().put("url", "data:image/jpeg;base64," + base64));
            imageInputs.put(imageInput);
        }

        JSONObject payload = new JSONObject()
                .put("model", "gpt-4o")
                .put("messages", List.of(new JSONObject()
                        .put("role", "user")
                        .put("content", new JSONArray()
                                .put(new JSONObject().put("type", "text").put("text", prompt))
                                .putAll(imageInputs)
                        )
                ))
                .put("max_tokens", 1000);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.openai.com/v1/chat/completions"))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + openAiApiKey)
                .POST(HttpRequest.BodyPublishers.ofString(payload.toString()))
                .build();

        HttpClient client = HttpClient.newHttpClient();
        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        JSONObject json = new JSONObject(response.body());
        String content = json.getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content");

        if (content.startsWith("```")) {
            content = content.replaceAll("(?s)```json|```", "").trim();
        }

        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(content, Culvert.class);
    }

}
