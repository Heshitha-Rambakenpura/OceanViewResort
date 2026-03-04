package com.oceanview.model;

/**
 * Room - Entity class
 * Represents individual hotel rooms
 * @version 1.0.0
 */
public class Room {

    private int roomId;
    private String roomNumber;
    private RoomType roomType;
    private int floorNumber;
    private int maxOccupancy;
    private boolean isAvailable;
    private String description;

    // ─── CONSTRUCTORS ───
    public Room() {}

    public Room(String roomNumber, RoomType roomType,
                int floorNumber, int maxOccupancy) {
        this.roomNumber   = roomNumber;
        this.roomType     = roomType;
        this.floorNumber  = floorNumber;
        this.maxOccupancy = maxOccupancy;
        this.isAvailable  = true;
    }

    // ─── GETTERS ───
    public int getRoomId()          { return roomId; }
    public String getRoomNumber()   { return roomNumber; }
    public RoomType getRoomType()   { return roomType; }
    public int getFloorNumber()     { return floorNumber; }
    public int getMaxOccupancy()    { return maxOccupancy; }
    public boolean isAvailable()    { return isAvailable; }
    public String getDescription()  { return description; }

    // ─── SETTERS ───
    public void setRoomId(int id)               { this.roomId = id; }
    public void setRoomNumber(String num)       { this.roomNumber = num; }
    public void setRoomType(RoomType type)      { this.roomType = type; }
    public void setFloorNumber(int floor)       { this.floorNumber = floor; }
    public void setMaxOccupancy(int max)        { this.maxOccupancy = max; }
    public void setAvailable(boolean available) { this.isAvailable = available; }
    public void setDescription(String desc)     { this.description = desc; }
}