package com.smartwind.admin.model;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "sensor_readings")
public class SensorReading {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "device_id", nullable = false, length = 64)
    private String deviceId;

    @Column(nullable = false)
    private Double voltage;

    private Double temperature;

    private Double humidity;

    @Column(name = "relay_on")
    private Boolean relayOn;

    @Column(name = "recorded_at", nullable = false)
    private OffsetDateTime recordedAt;

    public Long getId() { return id; }
    public String getDeviceId() { return deviceId; }
    public Double getVoltage() { return voltage; }
    public Double getTemperature() { return temperature; }
    public Double getHumidity() { return humidity; }
    public Boolean getRelayOn() { return relayOn; }
    public OffsetDateTime getRecordedAt() { return recordedAt; }
}
