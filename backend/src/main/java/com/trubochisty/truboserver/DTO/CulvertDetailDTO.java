package com.trubochisty.truboserver.DTO;

import com.trubochisty.truboserver.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CulvertDetailDTO {
    private String id;
    private String address;
    private String coordinates;
    private String road;
    private String serialNumber;
    private String pipeType;
    private String material;
    private String diameter;
    private String length;
    private String headType;
    private String foundationType;
    private String workType;
    private LocalDateTime constructionDate;
    private LocalDateTime lastRepairDate;
    private LocalDateTime lastInspectionDate;
    private Double strengthRating;
    private Double safetyRating;
    private Double maintainabilityRating;
    private Double generalConditionRating;
    private List<String> defects;
    private List<String> photos;
    private List<UserSummaryDTO> users;
}

