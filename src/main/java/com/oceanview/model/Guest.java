package com.oceanview.model;

import java.time.LocalDateTime;

/**
 * Guest - Entity class
 * Represents hotel guests
 * @version 1.0.0
 */
public class Guest {

    private int guestId;
    private String name;
    private String nic;
    private String nationality;
    private String address;
    private String contactNumber;
    private String email;
    private LocalDateTime createdDate;

    // ─── CONSTRUCTORS ───
    public Guest() {}

    public Guest(String name, String nic, String nationality,
                 String address, String contactNumber, String email) {
        this.name          = name;
        this.nic           = nic;
        this.nationality   = nationality;
        this.address       = address;
        this.contactNumber = contactNumber;
        this.email         = email;
        this.createdDate   = LocalDateTime.now();
    }

    // ─── GETTERS ───
    public int getGuestId()             { return guestId; }
    public String getName()             { return name; }
    public String getNic()              { return nic; }
    public String getNationality()      { return nationality; }
    public String getAddress()          { return address; }
    public String getContactNumber()    { return contactNumber; }
    public String getEmail()            { return email; }
    public LocalDateTime getCreatedDate() { return createdDate; }

    // ─── SETTERS ───
    public void setGuestId(int id)              { this.guestId = id; }
    public void setName(String name)            { this.name = name; }
    public void setNic(String nic)              { this.nic = nic; }
    public void setNationality(String n)        { this.nationality = n; }
    public void setAddress(String address)      { this.address = address; }
    public void setContactNumber(String num)    { this.contactNumber = num; }
    public void setEmail(String email)          { this.email = email; }
    public void setCreatedDate(LocalDateTime d) { this.createdDate = d; }
}