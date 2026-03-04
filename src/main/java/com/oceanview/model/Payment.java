package com.oceanview.model;

import java.time.LocalDateTime;

/**
 * Payment - Abstract class (Strategy Pattern)
 * Parent for all payment types
 * @version 1.0.0
 */
public abstract class Payment {

    private int paymentId;
    private Bill bill;
    private double amount;
    private LocalDateTime paymentDate;
    private String paymentStatus;
    private String receiptNumber;

    // ─── CONSTRUCTORS ───
    public Payment() {}

    public Payment(Bill bill, double amount) {
        this.bill          = bill;
        this.amount        = amount;
        this.paymentDate   = LocalDateTime.now();
        this.paymentStatus = "PENDING";
        this.receiptNumber = generateReceiptNumber();
    }

    // ─── GENERATE RECEIPT NUMBER ───
    private String generateReceiptNumber() {
        return "RCP" + System.currentTimeMillis();
    }

    // ─── ABSTRACT METHOD - Strategy Pattern ───
    // Each subclass implements differently
    public abstract boolean processPayment();

    // ─── GETTERS ───
    public int getPaymentId()               { return paymentId; }
    public Bill getBill()                   { return bill; }
    public double getAmount()               { return amount; }
    public LocalDateTime getPaymentDate()   { return paymentDate; }
    public String getPaymentStatus()        { return paymentStatus; }
    public String getReceiptNumber()        { return receiptNumber; }

    // ─── SETTERS ───
    public void setPaymentId(int id)                { this.paymentId = id; }
    public void setBill(Bill bill)                  { this.bill = bill; }
    public void setAmount(double amount)            { this.amount = amount; }
    public void setPaymentDate(LocalDateTime date)  { this.paymentDate = date; }
    public void setPaymentStatus(String status)     { this.paymentStatus = status; }
    public void setReceiptNumber(String receipt)    { this.receiptNumber = receipt; }
}