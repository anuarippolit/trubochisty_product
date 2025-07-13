package com.trubochisty.truboserver.DTO;

import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.model.User;
import com.trubochisty.truboserver.repository.IUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class CulvertMapper {
    private final IUserRepository userRepository;

    public static CulvertSummaryDTO mapToCulvertSummaryDTO(Culvert culvert) {
        return CulvertSummaryDTO.builder()
                .id(culvert.getId())
                .address(culvert.getAddress())
                .coordinates(culvert.getCoordinates())
                .road(culvert.getRoad())
                .serialNumber(culvert.getSerialNumber())
                .pipeType(culvert.getPipeType())
                .material(culvert.getMaterial())
                .diameter(culvert.getDiameter())
                .length(culvert.getLength())
                .headType(culvert.getHeadType())
                .foundationType(culvert.getFoundationType())
                .workType(culvert.getWorkType())
                .constructionDate(culvert.getConstructionDate())
                .lastRepairDate(culvert.getLastRepairDate())
                .lastInspectionDate(culvert.getLastInspectionDate())
                .strengthRating(culvert.getStrengthRating())
                .safetyRating(culvert.getSafetyRating())
                .maintainabilityRating(culvert.getMaintainabilityRating())
                .generalConditionRating(culvert.getGeneralConditionRating())
                .defects(culvert.getDefects())
                .photos(culvert.getPhotos())
                .build();
    }

    public static CulvertDetailDTO mapToCulvertDetailDTO(Culvert culvert) {
        return CulvertDetailDTO.builder()
                .id(culvert.getId())
                .address(culvert.getAddress())
                .coordinates(culvert.getCoordinates())
                .road(culvert.getRoad())
                .serialNumber(culvert.getSerialNumber())
                .pipeType(culvert.getPipeType())
                .material(culvert.getMaterial())
                .diameter(culvert.getDiameter())
                .length(culvert.getLength())
                .headType(culvert.getHeadType())
                .foundationType(culvert.getFoundationType())
                .workType(culvert.getWorkType())
                .constructionDate(culvert.getConstructionDate())
                .lastRepairDate(culvert.getLastRepairDate())
                .lastInspectionDate(culvert.getLastInspectionDate())
                .strengthRating(culvert.getStrengthRating())
                .safetyRating(culvert.getSafetyRating())
                .maintainabilityRating(culvert.getMaintainabilityRating())
                .generalConditionRating(culvert.getGeneralConditionRating())
                .defects(culvert.getDefects())
                .photos(culvert.getPhotos())
                .users(
                culvert.getUsers().stream()
                        .map(UserMapper::mapToUserSummaryDTO)
                        .collect(Collectors.toList())
        )
                .build();
    }

    /*public Culvert toEntity(CulvertDTO dto) {
        List<User> users = dto.getUserIds() != null
                ? userRepository.findAllById(dto.getUserIds())
                : new ArrayList<>();

        return Culvert.builder()
                .id(dto.getId())
                .address(dto.getAddress())
                .coordinates(dto.getCoordinates())
                .road(dto.getRoad())
                .serialNumber(dto.getSerialNumber())
                .pipeType(dto.getPipeType())
                .material(dto.getMaterial())
                .diameter(dto.getDiameter())
                .length(dto.getLength())
                .headType(dto.getHeadType())
                .foundationType(dto.getFoundationType())
                .workType(dto.getWorkType())
                .constructionDate(dto.getConstructionDate())
                .lastRepairDate(dto.getLastRepairDate())
                .lastInspectionDate(dto.getLastInspectionDate())
                .strengthRating(dto.getStrengthRating())
                .safetyRating(dto.getSafetyRating())
                .maintainabilityRating(dto.getMaintainabilityRating())
                .generalConditionRating(dto.getGeneralConditionRating())
                .defects(dto.getDefects() != null ? dto.getDefects() : new ArrayList<>())
                .photos(dto.getPhotos() != null ? dto.getPhotos() : new ArrayList<>())
                .users(dto.getUserIds!= null ? users : new ArrayList<>())
                .build();
    }*/

    public static CulvertUpdateDTO mapToCulvertUpdateDTO(Culvert culvert) {
        return CulvertUpdateDTO.builder()
                .address(culvert.getAddress())
                .coordinates(culvert.getCoordinates())
                .road(culvert.getRoad())
                .serialNumber(culvert.getSerialNumber())
                .pipeType(culvert.getPipeType())
                .material(culvert.getMaterial())
                .diameter(culvert.getDiameter())
                .length(culvert.getLength())
                .headType(culvert.getHeadType())
                .foundationType(culvert.getFoundationType())
                .workType(culvert.getWorkType())
                .constructionDate(culvert.getConstructionDate())
                .lastRepairDate(culvert.getLastRepairDate())
                .lastInspectionDate(culvert.getLastInspectionDate())
                .strengthRating(culvert.getStrengthRating())
                .safetyRating(culvert.getSafetyRating())
                .maintainabilityRating(culvert.getMaintainabilityRating())
                .generalConditionRating(culvert.getGeneralConditionRating())
                .defects(culvert.getDefects())
                .photos(culvert.getPhotos())
                .userIDs(culvert.getUsers().stream().map(User::getId).collect(Collectors.toList()))
                .build();
    }
}
