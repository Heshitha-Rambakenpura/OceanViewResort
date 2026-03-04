package com.oceanview.model;

/**
 * CardPayment - Extends Payment (Strategy Pattern)
 * @version 1.0.0
 */
public class CardPayment extends Payment {

    private String cardNumber;
    private String cardHolderName;
    private String expiryDate;
    private String cvv;

    // ─── CONSTRUCTORS ───
    public CardPayment() {}

    public CardPayment(Bill bill, double amount, String cardNumber,
                       String cardHolderName, String expiryDate, String cvv) {
        super(bill, amount);
        this.cardNumber     = cardNumber;
        this.cardHolderName = cardHolderName;
        this.expiryDate     = expiryDate;
        this.cvv            = cvv;
    }

    // ─── STRATEGY PATTERN - processPayment implementation ───
    @Override
    public boolean processPayment() {
        if (cardNumber != null && !cardNumber.isEmpty()
                && cvv != null && cvv.length() == 3) {
            setPaymentStatus("SUCCESS");
            return true;
        }
        setPaymentStatus("FAILED");
        return false;
    }

    // ─── GETTERS AND SETTERS ───
    public String getCardNumber()               { return cardNumber; }
    public String getCardHolderName()           { return cardHolderName; }
    public String getExpiryDate()               { return expiryDate; }
    public String getCvv()                      { return cvv; }
    public void setCardNumber(String num)       { this.cardNumber = num; }
    public void setCardHolderName(String name)  { this.cardHolderName = name; }
    public void setExpiryDate(String date)      { this.expiryDate = date; }
    public void setCvv(String cvv)              { this.cvv = cvv; }
}