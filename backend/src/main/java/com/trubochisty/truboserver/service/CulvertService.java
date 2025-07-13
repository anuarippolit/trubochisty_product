package com.trubochisty.truboserver.service;

import com.trubochisty.truboserver.DTO.CulvertCreateDTO;
import com.trubochisty.truboserver.DTO.CulvertUpdateDTO;
import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.model.User;
import com.trubochisty.truboserver.repository.ICulvertRepository;
import com.trubochisty.truboserver.repository.IUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CulvertService {
    private final ICulvertRepository culvertRepository;
    private final IUserRepository userRepository;

    public Culvert getCulvert(String id) {
        return culvertRepository.findById(id).orElseThrow(() -> new RuntimeException("Culvert not found with id: " + id));
    }

    public List<Culvert> getAllCulverts() {
        return culvertRepository.findAll();
    }

    public List<Culvert> getCulvertsByAddress(String address) {
        return culvertRepository.findByAddressContainingIgnoreCase(address);
    }

    /*public Culvert createCulvert(CulvertCreateDTO culvertDTO, List<MultipartFile> photos) {
        List<String> photoUrls = new ArrayList<>();

        try {
            if (photos != null && !photos.isEmpty()) {
                Path uploadDir = Paths.get("uploads");
                Files.createDirectories(uploadDir);

                for (MultipartFile file : photos) {
                    String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
                    Path filepath = uploadDir.resolve(filename);

                    System.out.println("Saving to: " + filepath.toAbsolutePath());

                    file.transferTo(filepath.toFile());

                    photoUrls.add("/photos/" + filename); // можно заменить на URL если есть endpoint
                }

            }
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        List<User> users = culvertDTO.getUserIDs() != null
                ? userRepository.findAllById(culvertDTO.getUserIDs())
                : new ArrayList<>();

        Culvert culvert = Culvert.builder()
                .address(culvertDTO.getAddress())
                .coordinates(culvertDTO.getCoordinates())
                .road(culvertDTO.getRoad())
                .serialNumber(culvertDTO.getSerialNumber())
                .pipeType(culvertDTO.getPipeType())
                .material(culvertDTO.getMaterial())
                .diameter(culvertDTO.getDiameter())
                .length(culvertDTO.getLength())
                .headType(culvertDTO.getHeadType())
                .foundationType(culvertDTO.getFoundationType())
                .workType(culvertDTO.getWorkType())
                .constructionDate(culvertDTO.getConstructionDate())
                .lastRepairDate(culvertDTO.getLastRepairDate())
                .lastInspectionDate(culvertDTO.getLastInspectionDate())
                .strengthRating(culvertDTO.getStrengthRating())
                .safetyRating(culvertDTO.getSafetyRating())
                .maintainabilityRating(culvertDTO.getMaintainabilityRating())
                .generalConditionRating(culvertDTO.getGeneralConditionRating())
                .defects(culvertDTO.getDefects() != null ? culvertDTO.getDefects() : new ArrayList<>())
                .photos(photoUrls)
                .users(users)
                .build();

        return culvertRepository.save(culvert);
    }*/

    @Transactional
    public Culvert updateCulvert(String id, CulvertUpdateDTO culvertUpdateDTO) {
        Culvert existing = culvertRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Culvert not found with id: " + id));

        // Обновляем все поля
        existing.setAddress(culvertUpdateDTO.getAddress());
        existing.setCoordinates(culvertUpdateDTO.getCoordinates());
        existing.setRoad(culvertUpdateDTO.getRoad());
        existing.setSerialNumber(culvertUpdateDTO.getSerialNumber());
        existing.setPipeType(culvertUpdateDTO.getPipeType());
        existing.setMaterial(culvertUpdateDTO.getMaterial());
        existing.setDiameter(culvertUpdateDTO.getDiameter());
        existing.setLength(culvertUpdateDTO.getLength());
        existing.setHeadType(culvertUpdateDTO.getHeadType());
        existing.setFoundationType(culvertUpdateDTO.getFoundationType());
        existing.setWorkType(culvertUpdateDTO.getWorkType());
        existing.setConstructionDate(culvertUpdateDTO.getConstructionDate());
        existing.setLastRepairDate(culvertUpdateDTO.getLastRepairDate());
        existing.setLastInspectionDate(culvertUpdateDTO.getLastInspectionDate());
        existing.setStrengthRating(culvertUpdateDTO.getStrengthRating());
        existing.setSafetyRating(culvertUpdateDTO.getSafetyRating());
        existing.setMaintainabilityRating(culvertUpdateDTO.getMaintainabilityRating());
        existing.setGeneralConditionRating(culvertUpdateDTO.getGeneralConditionRating());
        existing.setDefects(culvertUpdateDTO.getDefects());
        existing.setPhotos(culvertUpdateDTO.getPhotos());
        //existing.setUserId(updated.getUserId());

        List<String> userIds = culvertUpdateDTO.getUserIDs();
        if (userIds != null && !userIds.isEmpty()) {
            List<User> usersFromDb = userRepository.findAllById(userIds);
            existing.setUsers(usersFromDb);
        }

        return culvertRepository.save(existing);
    }

    public Culvert createCulvert(CulvertCreateDTO culvertDTO, List<MultipartFile> photos) {
        List<String> photoUrls = new ArrayList<>();

        Path uploadDir = Paths.get(System.getProperty("user.dir")).resolve("uploads");
        try {
            Files.createDirectories(uploadDir);
        } catch (IOException e) {
            throw new RuntimeException("Не удалось создать папку для фото: " + uploadDir, e);
        }

        if (photos != null && !photos.isEmpty()) {
            for (MultipartFile file : photos) {
                try {
                    String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
                    Path filepath = uploadDir.resolve(filename);

                    System.out.println("Saving to: " + filepath.toAbsolutePath());

                    file.transferTo(filepath.toFile());

                    photoUrls.add("/photos/" + filename);
                } catch (IOException e) {
                    throw new RuntimeException("Ошибка при сохранении файла: " + file.getOriginalFilename(), e);
                }
            }
        }

        List<User> users = culvertDTO.getUserIDs() != null
                ? userRepository.findAllById(culvertDTO.getUserIDs())
                : new ArrayList<>();

        Culvert culvert = Culvert.builder()
                .address(culvertDTO.getAddress())
                .coordinates(culvertDTO.getCoordinates())
                .road(culvertDTO.getRoad())
                .serialNumber(culvertDTO.getSerialNumber())
                .pipeType(culvertDTO.getPipeType())
                .material(culvertDTO.getMaterial())
                .diameter(culvertDTO.getDiameter())
                .length(culvertDTO.getLength())
                .headType(culvertDTO.getHeadType())
                .foundationType(culvertDTO.getFoundationType())
                .workType(culvertDTO.getWorkType())
                .constructionDate(culvertDTO.getConstructionDate())
                .lastRepairDate(culvertDTO.getLastRepairDate())
                .lastInspectionDate(culvertDTO.getLastInspectionDate())
                .strengthRating(culvertDTO.getStrengthRating())
                .safetyRating(culvertDTO.getSafetyRating())
                .maintainabilityRating(culvertDTO.getMaintainabilityRating())
                .generalConditionRating(culvertDTO.getGeneralConditionRating())
                .defects(culvertDTO.getDefects() != null ? culvertDTO.getDefects() : new ArrayList<>())
                .photos(photoUrls)
                .users(users)
                .build();

        return culvertRepository.save(culvert);
    }



    @Transactional
    public void deleteCulvert(String id) {
        Culvert culvert = culvertRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Culvert not found with id: " + id));

        // Удаляем связи с user-ами (с обеих сторон!)
        for (User user : new ArrayList<>(culvert.getUsers())) {
            user.getCulverts().remove(culvert);
        }
        culvert.getUsers().clear();

        culvertRepository.save(culvert); // Зафиксируем обновление

        // Удалим сам объект
        culvertRepository.delete(culvert);
    }


    public Page<Culvert> getAllCulvertsPageable(Pageable pageable) {
        return culvertRepository.findAll(pageable);
    }

    //TO-DO
    public Page<Culvert> getCulvertsByUserId(String userId, Pageable pageable) {
        return null;
    }

    @Transactional
    public Culvert assignUsers(String culvertId, List<User> usersWithOnlyIds) {
        // Найти трубу
        Culvert culvert = culvertRepository.findById(culvertId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Culvert not found with id: " + culvertId));

        // Извлечь ID пользователей
        List<String> userIds = usersWithOnlyIds.stream()
                .map(User::getId)
                .filter(Objects::nonNull)
                .toList();

        if (userIds.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No user IDs provided");
        }

        List<User> usersFromDb = userRepository.findAllById(userIds);

        if (usersFromDb.size() != userIds.size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Some user IDs are invalid or do not exist");
        }

        //culvert.setUsers(usersFromDb);

        return culvertRepository.save(culvert);
    }

}

