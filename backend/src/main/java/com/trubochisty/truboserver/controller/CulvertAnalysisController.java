package com.trubochisty.truboserver.controller;

import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.service.OpenAiService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/culvert-analysis")
@RequiredArgsConstructor
public class CulvertAnalysisController {

    private final OpenAiService openAiService;

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Culvert> analyzeCulvertPhotos(@RequestParam("files") List<MultipartFile> files) {
        try {
            Culvert culvert = openAiService.analyzePhotosAndExtractCulvert(files);

            return ResponseEntity.ok(culvert);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);

        }
    }
}

