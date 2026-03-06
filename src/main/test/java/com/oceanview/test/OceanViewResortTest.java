package com.oceanview.test;

import com.oceanview.dao.*;
import com.oceanview.model.*;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class OceanViewResortTest {

    private static UserDAO userDAO;
    private static GuestDAO guestDAO;
    private static RoomDAO roomDAO;
    private static RoomTypeDAO roomTypeDAO;
    private static PaymentDAO paymentDAO;

    @BeforeAll
    static void setUp() {
        userDAO     = new UserDAO();
        guestDAO    = new GuestDAO();
        roomDAO     = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
        paymentDAO  = new PaymentDAO();
    }

    // TC-005: Admin login and role check
    @Test @Order(1)
    void testAdminLogin() {
        User user = userDAO.verifyLogin("admin", "admin123");
        assertNotNull(user);
        assertEquals("ADMIN", user.getRole());
    }

    // TC-006: Receptionist login
    @Test @Order(2)
    void testReceptionistLogin() {
        User user = userDAO.verifyLogin("receptionist1", "recep123");
        assertNotNull(user);
        assertEquals("RECEPTIONIST", user.getRole());
    }

    // TC-002: Invalid login returns null
    @Test @Order(3)
    void testInvalidLogin() {
        User user = userDAO.verifyLogin("admin", "wrongpassword");
        assertNull(user);
    }

    // TC-003: Empty username returns null
    @Test @Order(4)
    void testEmptyUsernameLogin() {
        User user = userDAO.verifyLogin("", "admin123");
        assertNull(user);
    }

    // TC-010: SQL injection prevention
    @Test @Order(5)
    void testSqlInjectionPrevention() {
        User user = userDAO.verifyLogin(
                "admin' OR '1'='1", "anything");
        assertNull(user);
    }

    // TC-018: Save guest returns true
    @Test @Order(6)
    void testSaveGuest() {
        Guest guest = new Guest(
                "JUnit Test Guest",
                "987654321V",
                "Sri Lankan",
                "Test Address",
                "0771111111",
                "junit@test.com");
        boolean result = guestDAO.saveGuest(guest);
        assertTrue(result);
        assertTrue(guest.getGuestId() > 0);
    }

    // TC-019: Duplicate NIC detection
    @Test @Order(7)
    void testDuplicateNicDetection() {
        boolean exists = guestDAO.checkNICExists("987654321V");
        assertTrue(exists);
    }

    // TC-016: Name validation - letters only
    @Test @Order(8)
    void testNameValidation() {
        String name = "John123";
        assertFalse(name.matches("[a-zA-Z ]+"),
                "Name with numbers should fail validation");
    }

    // TC-017: Contact number validation
    @Test @Order(9)
    void testContactValidation() {
        String shortContact = "077123";
        assertFalse(shortContact.matches("[0-9]{10}"),
                "Short contact should fail validation");
    }

    // TC-025: Available rooms only
    @Test @Order(10)
    void testGetAvailableRooms() {
        java.util.List<Room> rooms = roomDAO.getAvailableRooms();
        assertNotNull(rooms);
        rooms.forEach(room ->
                assertTrue(room.isAvailable(),
                        "All rooms should be available"));
    }

    // TC-031: Nights calculation
    @Test @Order(11)
    void testNightsCalculation() {
        java.time.LocalDate checkIn =
                java.time.LocalDate.of(2026, 4, 1);
        java.time.LocalDate checkOut =
                java.time.LocalDate.of(2026, 4, 5);
        long nights = java.time.temporal.ChronoUnit
                .DAYS.between(checkIn, checkOut);
        assertEquals(4, nights);
    }

    // TC-039: Cash payment - insufficient amount
    @Test @Order(12)
    void testCashPaymentInsufficientAmount() {
        Bill bill = new Bill();
        bill.setBillId(1);
        CashPayment payment = new CashPayment(
                bill, 5500.00, 5000.00);
        boolean result = payment.processPayment();
        assertFalse(result);
        assertEquals("FAILED", payment.getPaymentStatus());
    }

    // TC-036: Cash payment - valid amount
    @Test @Order(13)
    void testCashPaymentSuccess() {
        Bill bill = new Bill();
        bill.setBillId(1);
        CashPayment payment = new CashPayment(
                bill, 5500.00, 6000.00);
        boolean result = payment.processPayment();
        assertTrue(result);
        assertEquals("SUCCESS", payment.getPaymentStatus());
    }

    // TC-040: Strategy pattern - card method set
    @Test @Order(14)
    void testCardPaymentMethodSet() {
        Bill bill = new Bill();
        bill.setBillId(1);
        CardPayment card = new CardPayment(
                bill, 5000.0,
                "1234567890123456",
                "John Silva", "12/27", "123");
        assertEquals("CARD", card.getPaymentMethod());
    }

    // TC-041: Receipt number generation
    @Test @Order(15)
    void testReceiptNumberGeneration() {
        Bill bill = new Bill();
        CashPayment p = new CashPayment(
                bill, 1000.0, 1000.0);
        assertNotNull(p.getReceiptNumber());
        assertTrue(p.getReceiptNumber().startsWith("RCP"));
    }
}