package com.oceanview.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Report - Entity class
 * Generates financial reports
 * @version 1.0.0
 */
public class Report {

    private int reportId;
    private String reportType;
    private LocalDateTime generatedDate;
    private LocalDate startDate;
    private LocalDate endDate;
    private int generatedBy;

    // ─── CONSTRUCTORS ───
    public Report() {}

    public Report(String reportType, LocalDate startDate,
                  LocalDate endDate, int generatedBy) {
        this.reportType    = reportType;
        this.startDate     = startDate;
        this.endDate       = endDate;
        this.generatedBy   = generatedBy;
        this.generatedDate = LocalDateTime.now();
    }

    // ─── GETTERS ───
    public int getReportId()                { return reportId; }
    public String getReportType()           { return reportType; }
    public LocalDateTime getGeneratedDate() { return generatedDate; }
    public LocalDate getStartDate()         { return startDate; }
    public LocalDate getEndDate()           { return endDate; }
    public int getGeneratedBy()             { return generatedBy; }

    // ─── SETTERS ───
    public void setReportId(int id)                 { this.reportId = id; }
    public void setReportType(String type)          { this.reportType = type; }
    public void setGeneratedDate(LocalDateTime d)   { this.generatedDate = d; }
    public void setStartDate(LocalDate date)        { this.startDate = date; }
    public void setEndDate(LocalDate date)          { this.endDate = date; }
    public void setGeneratedBy(int userId)          { this.generatedBy = userId; }
}