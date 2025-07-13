package com.trubochisty.truboserver.DTO;

import jakarta.validation.constraints.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class CulvertCreateDTO {

    @NotBlank(message = "Address is required")
    @Size(max = 500)
    private String address;

    @NotBlank(message = "Coordinates are required")
    @Size(max = 100)
    private String coordinates;

    @Size(max = 200)
    private String road;

    @Size(max = 100)
    private String serialNumber;

    @Size(max = 100)
    private String pipeType;

    private String material;

    private String diameter;

    private String length;

    @NotBlank(message = "Head type is required")
    private String headType;

    @NotBlank(message = "Foundation type is required")
    private String foundationType;

    @NotBlank(message = "Work type is required")
    private String workType;

    // Даты можно валидировать отдельно при необходимости
    private LocalDateTime constructionDate;
    private LocalDateTime lastRepairDate;
    private LocalDateTime lastInspectionDate;

    @DecimalMin(value = "0.0", inclusive = true, message = "Strength rating must be ≥ 0.0")
    @DecimalMax(value = "10.0", inclusive = true, message = "Strength rating must be ≤ 10.0")
    private Double strengthRating;

    @DecimalMin(value = "0.0", inclusive = true, message = "Safety rating must be ≥ 0.0")
    @DecimalMax(value = "10.0", inclusive = true, message = "Safety rating must be ≤ 10.0")
    private Double safetyRating;

    @DecimalMin(value = "0.0", inclusive = true, message = "Maintainability rating must be ≥ 0.0")
    @DecimalMax(value = "10.0", inclusive = true, message = "Maintainability rating must be ≤ 10.0")
    private Double maintainabilityRating;

    @DecimalMin(value = "0.0", inclusive = true, message = "General condition rating must be ≥ 0.0")
    @DecimalMax(value = "10.0", inclusive = true, message = "General condition rating must be ≤ 10.0")
    private Double generalConditionRating;

    @Size(max = 50, message = "Too many defects")
    private List<@Size(max = 500, message = "Each defect must be ≤ 500 characters") String> defects;

    @Size(max = 50, message = "Too many user IDs")
    private List<String> userIDs;
}

