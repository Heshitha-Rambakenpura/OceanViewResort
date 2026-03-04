package com.oceanview.controller;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.dao.GuestDAO;
import com.oceanview.model.Guest;
import java.util.List;

/**
 * GuestController - Business Logic for Guest operations
 * @version 1.0.0
 */
public class GuestController {

    private GuestDAO guestDAO;
    private AuditLogDAO auditLogDAO;

    public GuestController() {
        this.guestDAO    = new GuestDAO();
        this.auditLogDAO = new AuditLogDAO();
    }

    // ─── REGISTER GUEST ───
    public String registerGuest(Guest guest, int userId,
                                String ipAddress) {
        // Step 1 - Check NIC exists
        if (guestDAO.checkNICExists(guest.getNic())) {
            return "DUPLICATE_NIC";
        }
        // Step 2 - Validate details
        String validation = validateGuestDetails(guest);
        if (!validation.equals("VALID")) {
            return validation;
        }
        // Step 3 - Save guest
        boolean saved = guestDAO.saveGuest(guest);
        if (saved) {
            auditLogDAO.logAction(userId,
                    "GUEST_REGISTERED", ipAddress);
            return "SUCCESS";
        }
        return "ERROR";
    }

    // ─── VALIDATE GUEST DETAILS ───
    private String validateGuestDetails(Guest guest) {
        if (guest.getName() == null
                || guest.getName().trim().isEmpty()) {
            return "INVALID_NAME";
        }
        if (guest.getNic() == null
                || guest.getNic().trim().isEmpty()) {
            return "INVALID_NIC";
        }
        if (guest.getEmail() == null
                || !guest.getEmail().contains("@")) {
            return "INVALID_EMAIL";
        }
        if (guest.getContactNumber() == null
                || guest.getContactNumber().trim().isEmpty()) {
            return "INVALID_CONTACT";
        }
        return "VALID";
    }

    // ─── GET GUEST BY ID ───
    public Guest getGuestById(int guestId) {
        return guestDAO.getGuestById(guestId);
    }

    // ─── GET GUEST BY NIC ───
    public Guest getGuestByNIC(String nic) {
        return guestDAO.getGuestByNIC(nic);
    }

    // ─── GET ALL GUESTS ───
    public List<Guest> getAllGuests() {
        return guestDAO.getAllGuests();
    }

    // ─── CHECK NIC EXISTS ───
    public boolean checkNICExists(String nic) {
        return guestDAO.checkNICExists(nic);
    }
}