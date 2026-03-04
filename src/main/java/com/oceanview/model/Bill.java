package com.oceanview.model;

import java.time.LocalDateTime;

/**
 * Bill - Entity class
 * Handles billing with tax and discount
 * @version 1.0.0
 */
public class Bill {

    private int billId;
    private Reservation reservation;
    private double totalAmount;
    private double taxAmount;
    private double discount;
    private double netAmount;
    private LocalDateTime generatedDate;
    private boolean isPaid;

    // ─── CONSTRUCTORS ───
    public Bill() {}

    public Bill(Reservation reservation) {
        this.reservation   = reservation;
        this.generatedDate = LocalDateTime.now();
        this.isPaid        = false;
        this.discount      = 0.0;
        calculateBill();
    }

    // ─── CALCULATE BILL ───
    public void calculateBill() {
        if (reservation != null && reservation.getRoom() != null) {
            double basePrice = reservation.getRoom()
                    .getRoomType()
                    .getBasePrice();
            int nights       = reservation.getNumberOfNights();
            this.totalAmount = basePrice * nights;
            this.taxAmount   = this.totalAmount * 0.10; // 10% tax
            this.netAmount   = this.totalAmount + this.taxAmount - this.discount;
        }
    }

    // ─── APPLY DISCOUNT ───
    public void applyDiscount(double discountAmount) {
        this.discount  = discountAmount;
        this.netAmount = this.totalAmount + this.taxAmount - this.discount;
    }

    // ─── GETTERS ───
    public int getBillId()                  { return billId; }
    public Reservation getReservation()     { return reservation; }
    public double getTotalAmount()          { return totalAmount; }
    public double getTaxAmount()            { return taxAmount; }
    public double getDiscount()             { return discount; }
    public double getNetAmount()            { return netAmount; }
    public LocalDateTime getGeneratedDate() { return generatedDate; }
    public boolean isPaid()                 { return isPaid; }

    // ─── SETTERS ───
    public void setBillId(int id)                   { this.billId = id; }
    public void setReservation(Reservation r)       { this.reservation = r; }
    public void setTotalAmount(double amount)       { this.totalAmount = amount; }
    public void setTaxAmount(double tax)            { this.taxAmount = tax; }
    public void setDiscount(double discount)        { this.discount = discount; }
    public void setNetAmount(double net)            { this.netAmount = net; }
    public void setGeneratedDate(LocalDateTime d)   { this.generatedDate = d; }
    public void setPaid(boolean paid)               { this.isPaid = paid; }
}