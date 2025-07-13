package com.trubochisty.truboserver.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "culverts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Culvert {
    
    @Id
    @UuidGenerator
    private String id;

    @ManyToMany
    @JoinTable(
            name = "user_culvert",
            joinColumns = @JoinColumn(name = "culvert_id"),          // 👉 это id текущего класса Culvert
            inverseJoinColumns = @JoinColumn(name = "user_id")       // 👉 это внешний ключ на User
    )
    @JsonManagedReference
    private List<User> users = new ArrayList<>();

    // Identifying information
    @Column(nullable = false, length = 500)
    private String address;

    @Column(nullable = false, length = 100)
    private String coordinates;

    @Column(nullable = true, length = 200)
    private String road;

    @Column(name = "serial_number", length = 100)
    private String serialNumber;

    // Technical parameters
    @Column(name = "pipe_type", nullable = true, length = 100)
    private String pipeType;

    private String material;

    private String diameter;

    private String length;

    @Column(name = "head_type")
    private String headType;

    @Column(name = "foundation_type")
    private String foundationType;

    @Column(name = "work_type")
    private String workType;

    // Additional information
    @Column(name = "construction_date")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime constructionDate;
    //спорно, localDateTime криво работает часто.
    //во фронте тоже ебанина будет, потому-что у меня нормально не получилось фронтом передавать LocalDateTime а с обычным
    //time они клешатся

    @Column(name = "last_repair_date")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lastRepairDate;

    @Column(name = "last_inspection_date")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lastInspectionDate;

    // Condition ratings (0.0 to 10.0)
    @Column(name = "strength_rating")
    @DecimalMin(value = "0.0", message = "Strength rating must be between 0.0 and 10.0")
    @DecimalMax(value = "10.0", message = "Strength rating must be between 0.0 and 10.0")
    private Double strengthRating;

    @Column(name = "safety_rating")
    @DecimalMin(value = "0.0", message = "Safety rating must be between 0.0 and 10.0")
    @DecimalMax(value = "10.0", message = "Safety rating must be between 0.0 and 10.0")
    private Double safetyRating;

    @Column(name = "maintainability_rating")
    @DecimalMin(value = "0.0", message = "Maintainability rating must be between 0.0 and 10.0")
    @DecimalMax(value = "10.0", message = "Maintainability rating must be between 0.0 and 10.0")
    private Double maintainabilityRating;

    @Column(name = "general_condition_rating")
    @DecimalMin(value = "0.0", message = "General condition rating must be between 0.0 and 10.0")
    @DecimalMax(value = "10.0", message = "General condition rating must be between 0.0 and 10.0")
    private Double generalConditionRating;

    // Defects and photos as collections
    @ElementCollection
    @CollectionTable(name = "culvert_defects", joinColumns = @JoinColumn(name = "culvert_id"))
    @Column(name = "defect", length = 500)
    @Builder.Default
    private List<String> defects = new ArrayList<>();

    @ElementCollection
    @CollectionTable(name = "culvert_photos", joinColumns = @JoinColumn(name = "culvert_id"))
    @Column(name = "photo_url", length = 1000)
    @Builder.Default
    private List<String> photos = new ArrayList<>();

    // Audit fields
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;


}
