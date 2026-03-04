package com.oceanview.model;

/**
 * RoomType - Entity class
 * Represents room categories
 * @version 1.0.0
 */
public class RoomType {

    private int roomTypeId;
    private String typeName;
    private String description;
    private double basePrice;
    private String amenities;

    // ─── CONSTRUCTORS ───
    public RoomType() {}

    public RoomType(String typeName, String description,
                    double basePrice, String amenities) {
        this.typeName    = typeName;
        this.description = description;
        this.basePrice   = basePrice;
        this.amenities   = amenities;
    }

    // ─── GETTERS ───
    public int getRoomTypeId()      { return roomTypeId; }
    public String getTypeName()     { return typeName; }
    public String getDescription()  { return description; }
    public double getBasePrice()    { return basePrice; }
    public String getAmenities()    { return amenities; }

    // ─── SETTERS ───
    public void setRoomTypeId(int id)           { this.roomTypeId = id; }
    public void setTypeName(String name)        { this.typeName = name; }
    public void setDescription(String desc)     { this.description = desc; }
    public void setBasePrice(double price)      { this.basePrice = price; }
    public void setAmenities(String amenities)  { this.amenities = amenities; }
}