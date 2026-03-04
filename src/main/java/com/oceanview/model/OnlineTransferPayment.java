package com.oceanview.model;

import java.time.LocalDate;

/**
 * OnlineTransferPayment - Extends Payment (Strategy Pattern)
 * @version 1.0.0
 */
public class OnlineTransferPayment extends Payment {

    private String bankName;
    private String referenceNumber;
    private LocalDate transferDate;
    private String senderName;

    // ─── CONSTRUCTORS ───
    public OnlineTransferPayment() {}

    public OnlineTransferPayment(Bill bill, double amount, String bankName,
                                 String referenceNumber, LocalDate transferDate,
                                 String senderName) {
        super(bill, amount);
        this.bankName        = bankName;
        this.referenceNumber = referenceNumber;
        this.transferDate    = transferDate;
        this.senderName      = senderName;
    }

    // ─── STRATEGY PATTERN - processPayment implementation ───
    @Override
    public boolean processPayment() {
        if (referenceNumber != null && !referenceNumber.isEmpty()
                && bankName != null && !bankName.isEmpty()) {
            setPaymentStatus("SUCCESS");
            return true;
        }
        setPaymentStatus("FAILED");
        return false;
    }

    // ─── VERIFY TRANSFER ───
    public boolean verifyTransfer() {
        return referenceNumber != null && !referenceNumber.isEmpty();
    }

    // ─── GETTERS AND SETTERS ───
    public String getBankName()                 { return bankName; }
    public String getReferenceNumber()          { return referenceNumber; }
    public LocalDate getTransferDate()          { return transferDate; }
    public String getSenderName()               { return senderName; }
    public void setBankName(String bank)        { this.bankName = bank; }
    public void setReferenceNumber(String ref)  { this.referenceNumber = ref; }
    public void setTransferDate(LocalDate date) { this.transferDate = date; }
    public void setSenderName(String name)      { this.senderName = name; }
}