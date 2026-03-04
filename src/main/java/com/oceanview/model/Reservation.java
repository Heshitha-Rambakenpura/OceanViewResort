package com.oceanview.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Reservation - Entity class
 * Core booking entity
 * @version 1.0.0
 */
public class Reservation {

    private int reservationId;
    private Guest guest;
    private Room room;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private String status;
    private int numberOfNights;
    private int numberOfGuests;
    private String specialRequests;
    private int createdBy;
    private LocalDateTime createdDate;

    // ─── CONSTRUCTORS ───
    public Reservation() {}

    public Reservation(Guest guest, Room room, LocalDate checkInDate,
                       LocalDate checkOutDate, int numberOfGuests,
                       String specialRequests, int createdBy) {
        this.guest           = guest;
        this.room            = room;
        this.checkInDate     = checkInDate;
        this.checkOutDate    = checkOutDate;
        this.numberOfGuests  = numberOfGuests;
        this.specialRequests = specialRequests;
        this.createdBy       = createdBy;
        this.status          = "CONFIRMED";
        this.createdDate     = LocalDateTime.now();
        this.numberOfNights  = calculateNights();
    }

    // ─── CALCULATE NIGHTS ───
    public int calculateNights() {
        if (checkInDate != null && checkOutDate != null) {
            return (int) java.time.temporal.ChronoUnit.DAYS
                    .between(checkInDate, checkOutDate);
        }
        return 0;
    }

    // ─── GETTERS ───
    public int getReservationId()           { return reservationId; }
    public Guest getGuest()                 { return guest; }
    public Room getRoom()                   { return room; }
    public LocalDate getCheckInDate()       { return checkInDate; }
    public LocalDate getCheckOutDate()      { return checkOutDate; }
    public String getStatus()               { return status; }
    public int getNumberOfNights()          { return numberOfNights; }
    public int getNumberOfGuests()          { return numberOfGuests; }
    public String getSpecialRequests()      { return specialRequests; }
    public int getCreatedBy()               { return createdBy; }
    public LocalDateTime getCreatedDate()   { return createdDate; }

    // ─── SETTERS ───
    public void setReservationId(int id)            { this.reservationId = id; }
    public void setGuest(Guest guest)               { this.guest = guest; }
    public void setRoom(Room room)                  { this.room = room; }
    public void setCheckInDate(LocalDate date)      { this.checkInDate = date; }
    public void setCheckOutDate(LocalDate date)     { this.checkOutDate = date; }
    public void setStatus(String status)            { this.status = status; }
    public void setNumberOfNights(int nights)       { this.numberOfNights = nights; }
    public void setNumberOfGuests(int guests)       { this.numberOfGuests = guests; }
    public void setSpecialRequests(String requests) { this.specialRequests = requests; }
    public void setCreatedBy(int createdBy)         { this.createdBy = createdBy; }
    public void setCreatedDate(LocalDateTime date)  { this.createdDate = date; }
}