package com.trubochisty.truboserver.controller;

import com.trubochisty.truboserver.DTO.*;
import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.service.CulvertService;
import jakarta.validation.Valid;
import org.springframework.core.io.Resource;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

/**
 * REST для управления {@link Culvert}.
 *
 */
@RestController
@RequestMapping("/culvert")
@RequiredArgsConstructor
public class CulvertController {

    private final CulvertService culvertService;

    /**
     * test
     *
     * @return строка "Culvert API is up"
     */
    @GetMapping("/test")
    public String test() {
        return "Culvert API test";
    }

    /**
     * Получить объект {@link Culvert} по id.
     *
     * @param id уникальный идентификатор трубы
     * @return объект Culvert, если найден
     */
    @GetMapping("/culverts/{id}")
    public ResponseEntity<CulvertDetailDTO> getCulvert(@PathVariable String id) {
        Culvert culvert = culvertService.getCulvert(id);
        return ResponseEntity.ok(CulvertMapper.mapToCulvertDetailDTO(culvert));
    }

    /**
     * Список всех {@link Culvert}.
     *
     * @return список всех труб
     */
    @GetMapping
    public ResponseEntity<List<Culvert>> getAllCulverts() {
        return ResponseEntity.ok(culvertService.getAllCulverts());
    }

    /**
     * Найти объекты {@link Culvert} по адресу.
     *
     * @param address часть адреса для поиска
     * @return список совпадающих труб
     */
    @GetMapping("/by-address")
    public ResponseEntity<List<Culvert>> getByAddress(@RequestParam String address) {
        return ResponseEntity.ok(culvertService.getCulvertsByAddress(address));
    }

    /**
     * Создать новый {@link Culvert}.
     *
     * @param culvertDTO объект, который нужно сохранить
     * @param photos - фотографии
     * @return созданный объект с присвоенным ID
     */
    @PostMapping
    public ResponseEntity<CulvertDetailDTO> createCulvert(
            @RequestPart("culvert") @Valid CulvertCreateDTO culvertDTO,
            @RequestPart(value = "photos", required = false) List<MultipartFile> photos) {

        Culvert created = culvertService.createCulvert(culvertDTO, photos);
        return ResponseEntity.ok(CulvertMapper.mapToCulvertDetailDTO(created));
    }

    /**
     * Обновить существующий {@link Culvert} по id.
     *
     * @param id      ID объекта, который нужно обновить
     * @param culvert новые данные
     * @return обновлённый объект
     */
    @PutMapping("/{id}")
    public ResponseEntity<Culvert> updateCulvert(@PathVariable String id, @RequestBody CulvertUpdateDTO culvert) {
        try{
            Culvert updated = culvertService.updateCulvert(id, culvert);
            return ResponseEntity.ok(updated);
        }
        catch (Exception e) {
            //по идее лучше кастом написать
            System.out.println(e);
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * Удалить {@link Culvert} по id.
     *
     * @param id, который нужно удалить
     * @return HTTP 204 No Content, если успешно
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCulvert(@PathVariable String id) {
        try{
            culvertService.deleteCulvert(id);
            return ResponseEntity.noContent().build();
        }
        catch (Exception e) {
            //по идее лучше кастом написать
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @GetMapping("/photos/{filename:.+}")
    public ResponseEntity<Resource> getPhoto(@PathVariable String filename) {
        try {
            Path file = Paths.get("uploads").resolve(filename).normalize();
            Resource resource = new UrlResource(file.toUri());

            if (!resource.exists()) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok()
                    .contentType(MediaType.IMAGE_JPEG)
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/photos/{id}")
    public ResponseEntity<List<String>> uploadPhotos(
            @PathVariable String id,
            @RequestParam("photos") List<MultipartFile> files
    ) {
        Culvert culvert = culvertService.getCulvert(id);

        if (files == null || files.isEmpty()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        Path uploadDir = Paths.get(System.getProperty("user.dir")).resolve("uploads");

        List<String> photoUrls = new ArrayList<>();

        try {
            Files.createDirectories(uploadDir);

            for (MultipartFile file : files) {
                String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
                Path filepath = uploadDir.resolve(filename);
                file.transferTo(filepath.toFile());

                String photoUrl = "/photos/" + filename;
                photoUrls.add(photoUrl);
                culvert.getPhotos().add(photoUrl);
            }

            culvertService.updateCulvert(culvert.getId(), CulvertMapper.mapToCulvertUpdateDTO(culvert));
            return ResponseEntity.ok(photoUrls);

        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/photos/replace/{id}")
    public ResponseEntity<List<String>> replacePhotos(
            @PathVariable String id,
            @RequestParam("files") List<MultipartFile> files
    ) {
        Culvert culvert = culvertService.getCulvert(id);

        if (files == null || files.isEmpty()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        Path uploadDir = Paths.get(System.getProperty("user.dir")).resolve("uploads");
        List<String> newPhotoUrls = new ArrayList<>();

        try {
            Files.createDirectories(uploadDir);

            for (String oldUrl : culvert.getPhotos()) {
                Path oldFile = uploadDir.resolve(Paths.get(oldUrl).getFileName().toString());
                Files.deleteIfExists(oldFile);
            }

            culvert.getPhotos().clear();

            for (MultipartFile file : files) {
                String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
                Path filepath = uploadDir.resolve(filename);
                file.transferTo(filepath.toFile());

                String photoUrl = "/photos/" + filename;
                newPhotoUrls.add(photoUrl);
                culvert.getPhotos().add(photoUrl);
            }

            culvertService.updateCulvert(culvert.getId(), CulvertMapper.mapToCulvertUpdateDTO(culvert));
            return ResponseEntity.ok(newPhotoUrls);

        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @DeleteMapping("/photos/{id}")
    public ResponseEntity<String> deletePhoto(
            @PathVariable String id,
            @RequestParam("url") String url
    ) {
        System.out.println(url);
        System.out.println("deletePhoto");
        Culvert culvert = culvertService.getCulvert(id);

        boolean removed = culvert.getPhotos().remove(url);
        if (!removed) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Фото не найдено в списке");
        }

        Path uploadDir = Paths.get(System.getProperty("user.dir")).resolve("uploads");
        Path fileToDelete = uploadDir.resolve(Paths.get(url).getFileName().toString());
        try {
            Files.deleteIfExists(fileToDelete);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Не удалось удалить файл: " + e.getMessage());
        }

        culvertService.updateCulvert(culvert.getId(), CulvertMapper.mapToCulvertUpdateDTO(culvert));
        return ResponseEntity.ok("Фото удалено");
    }




}
