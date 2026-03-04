package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.model.*;
import java.util.List;

/**
 * ReservationController - Business Logic for Reservation operations
 * @version 1.0.0
 */
public class ReservationController {

    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;
    private BillDAO billDAO;
    private AuditLogDAO auditLogDAO;
    private GuestController guestController;

    public ReservationController() {
        this.reservationDAO  = new ReservationDAO();
        this.roomDAO         = new RoomDAO();
        this.billDAO         = new BillDAO();
        this.auditLogDAO     = new AuditLogDAO();
        this.guestController = new GuestController();
    }

    // ─── ADD RESERVATION ───
    public String addReservation(Reservation reservation,
                                 int userId, String ipAddress) {
        // Step 1 - Check guest exists
        Guest guest = guestController.getGuestById(
                reservation.getGuest().getGuestId());
        if (guest == null) {
            return "GUEST_NOT_FOUND";
        }

        // Step 2 - Check room availability
        boolean available = roomDAO.checkAvailability(
                reservation.getRoom().getRoomId(),
                reservation.getCheckInDate().toString(),
                reservation.getCheckOutDate().toString()
        );
        if (!available) {
            return "ROOM_NOT_AVAILABLE";
        }

        // Step 3 - Save reservation
        boolean saved = reservationDAO.saveReservation(reservation);
        if (!saved) {
            return "ERROR";
        }

        // Step 4 - Generate bill
        Bill bill = new Bill(reservation);
        billDAO.saveBill(bill);

        // Step 5 - Update room availability
        roomDAO.updateAvailability(
                reservation.getRoom().getRoomId(), false);

        // Step 6 - Log action
        auditLogDAO.logAction(userId,
                "RESERVATION_ADDED", ipAddress);
        return "SUCCESS";
    }

    // ─── GET RESERVATION BY ID ───
    public Reservation getReservationById(int reservationId) {
        return reservationDAO.getReservationById(reservationId);
    }

    // ─── GET ALL RESERVATIONS ───
    public List<Reservation> getAllReservations() {
        return reservationDAO.getAllReservations();
    }

    // ─── CANCEL RESERVATION ───
    public String cancelReservation(int reservationId,
                                    int userId, String ipAddress) {
        Reservation res = reservationDAO
                .getReservationById(reservationId);
        if (res == null) {
            return "NOT_FOUND";
        }
        boolean updated = reservationDAO.updateStatus(
                reservationId, "CANCELLED");
        if (updated) {
            // Free up room
            roomDAO.updateAvailability(
                    res.getRoom().getRoomId(), true);
            auditLogDAO.logAction(userId,
                    "RESERVATION_CANCELLED", ipAddress);
            return "SUCCESS";
        }
        return "ERROR";
    }

    // ─── GET AVAILABLE ROOMS ───
    public List<Room> getAvailableRooms() {
        return roomDAO.getAvailableRooms();
    }
}