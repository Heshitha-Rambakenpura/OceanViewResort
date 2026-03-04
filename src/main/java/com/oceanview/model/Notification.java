package com.oceanview.model;

import java.time.LocalDateTime;

/**
 * Notification - Entity class
 * Manages system notifications
 * @version 1.0.0
 */
public class Notification {

    private int notificationId;
    private int reservationId;
    private String message;
    private LocalDateTime sentDate;
    private String type;
    private String status;
    private String recipientEmail;
    private String recipientPhone;

    // ─── CONSTRUCTORS ───
    public Notification() {}

    public Notification(int reservationId, String message,
                        String type, String recipientEmail) {
        this.reservationId  = reservationId;
        this.message        = message;
        this.type           = type;
        this.recipientEmail = recipientEmail;
        this.sentDate       = LocalDateTime.now();
        this.status         = "PENDING";
    }

    // ─── GETTERS ───
    public int getNotificationId()          { return notificationId; }
    public int getReservationId()           { return reservationId; }
    public String getMessage()              { return message; }
    public LocalDateTime getSentDate()      { return sentDate; }
    public String getType()                 { return type; }
    public String getStatus()               { return status; }
    public String getRecipientEmail()       { return recipientEmail; }
    public String getRecipientPhone()       { return recipientPhone; }

    // ─── SETTERS ───
    public void setNotificationId(int id)       { this.notificationId = id; }
    public void setReservationId(int id)        { this.reservationId = id; }
    public void setMessage(String message)      { this.message = message; }
    public void setSentDate(LocalDateTime d)    { this.sentDate = d; }
    public void setType(String type)            { this.type = type; }
    public void setStatus(String status)        { this.status = status; }
    public void setRecipientEmail(String email) { this.recipientEmail = email; }
    public void setRecipientPhone(String phone) { this.recipientPhone = phone; }

    // ─── SEND EMAIL (simulated) ───
    public boolean sendEmail() {
        // JavaMail implementation would go here
        // For now simulated
        this.status = "SENT";
        System.out.println("Email sent to: " + recipientEmail);
        return true;
    }

    // ─── SIMULATE SMS ───
    public boolean simulateSMS() {
        // SMS stored in database as simulation
        this.status = "SENT";
        System.out.println("SMS simulated to: " + recipientPhone);
        return true;
    }
}